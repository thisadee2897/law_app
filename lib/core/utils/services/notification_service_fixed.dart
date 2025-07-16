// services/notification_service.dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:law_app/core/database/models/reminder_model.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
// Import the timezone data initialization, aliased as 'tz_data'
import 'package:timezone/data/latest_all.dart' as tz_data;

// Import the core timezone library, aliased as 'tz' for its functions
import 'package:timezone/timezone.dart' as tz;

// --- IMPORTANT: TOP-LEVEL FUNCTION FOR BACKGROUND NOTIFICATIONS ---
// ฟังก์ชันนี้ต้องอยู่นอกคลาส (top-level) หรือเป็น static function
// และต้องมี annotation @pragma('vm:entry-point') สำหรับ Android
@pragma('vm:entry-point')
void notificationBackgroundHandler(NotificationResponse notificationResponse) {
  // Logic ที่คุณต้องการให้ทำเมื่อแตะ Notification ขณะแอปอยู่ในพื้นหลัง/ถูกปิด
  // ตรงนี้คุณไม่สามารถเข้าถึง UI ของ Flutter ได้โดยตรง
  print('Background Notification tapped: ${notificationResponse.payload}');
  // ตัวอย่าง: ถ้าคุณต้องการนำทางไปหน้าจอเฉพาะ
  // คุณจะต้องใช้สิ่งที่เรียกว่า "deep linking" หรือ "callback handler" ที่ซับซ้อนกว่านี้
  // เช่นการใช้ Event Channel หรือ Global Key สำหรับ Navigator
}

@singleton
class NotificationService {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    try {
      const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      ); // ตรวจสอบชื่อ icon ในโฟลเดอร์ mipmap ของ Android

      const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        requestCriticalPermission: true,
        requestProvisionalPermission: true,
      );

      const InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, 
        iOS: initializationSettingsIOS,
      );

      await _flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
          // นี่คือ handler สำหรับเมื่อแอปทำงานอยู่ใน Foreground หรือ Background
          // เมื่อมีการแตะ Notification
          print('Notification tapped: ${notificationResponse.payload}');
          // ตรงนี้สามารถทำการนำทางใน UI ได้ เช่น:
          // Navigator.of(context).push(MaterialPageRoute(builder: (_) => SomeDetailPage(payload: notificationResponse.payload)));
        },
        // ส่งฟังก์ชัน Top-Level ที่สร้างไว้สำหรับ Background Notifications
        onDidReceiveBackgroundNotificationResponse: notificationBackgroundHandler,
      );

      // Request permissions explicitly
      await requestNotificationPermissions();
      
      // Create notification channel for Android
      await _createNotificationChannel();

      // Initializing Timezones
      tz_data.initializeTimeZones();
      final String timeZoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneName));
      
      print('NotificationService initialized successfully');
    } catch (e) {
      print('❌ Error initializing NotificationService: $e');
      // Don't rethrow to prevent app crash
    }
  }

  static Future<void> scheduleNotification(ReminderModel reminder) async {
    try {
      final int notificationId = reminder.id;
      final DateTime scheduledDateTime = reminder.getScheduledDateTime;

      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          'reminder_channel_id', // ID ที่ไม่ซ้ำกันสำหรับ Channel
          'Reminder Channel', // ชื่อ Channel ที่ผู้ใช้จะเห็น
          channelDescription: 'Channel for reminder notifications',
          importance: Importance.high,
          priority: Priority.high,
          ticker: 'ticker',
        ),
        iOS: DarwinNotificationDetails(
          sound: 'default.wav', // ตรวจสอบว่ามีไฟล์เสียงนี้อยู่ใน Runner project ของ iOS (ถ้าใช้เสียง custom)
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

      DateTimeComponents? matchDateTimeComponents;
      switch (reminder.recurrenceType) {
        case RecurrenceType.daily:
          matchDateTimeComponents = DateTimeComponents.time; // ทุกวันเวลาเดิม
          break;
        case RecurrenceType.weekly:
          matchDateTimeComponents = DateTimeComponents.dayOfWeekAndTime; // ทุกวันของสัปดาห์และเวลาเดิม
          break;
        case RecurrenceType.monthly:
          matchDateTimeComponents = DateTimeComponents.dayOfMonthAndTime; // ทุกวันของเดือนและเวลาเดิม
          break;
        case RecurrenceType.yearly:
          matchDateTimeComponents = DateTimeComponents.dateAndTime; // ทุกวันและเดือนของปีและเวลาเดิม
          break;
        case RecurrenceType.none:
          matchDateTimeComponents = null; // ไม่เกิดซ้ำ
          break;
      }

      if (matchDateTimeComponents != null) {
        // สำหรับการแจ้งเตือนซ้ำ
        await _flutterLocalNotificationsPlugin.zonedSchedule(
          notificationId,
          reminder.title,
          reminder.description,
          _nextInstanceOfReminder(scheduledDateTime, reminder), // คำนวณเวลาที่ใกล้ที่สุดในอนาคต
          notificationDetails,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: matchDateTimeComponents,
          payload: reminder.id.toString(), // ส่ง ID Reminder เป็น String
        );
        print('Scheduled RECURRING notification (ID: ${reminder.id}): ${reminder.title} at ${reminder.scheduledTime} - Recurrence: ${reminder.recurrenceType}');
      } else {
        // สำหรับการแจ้งเตือนครั้งเดียว
        // ตรวจสอบว่าเวลาที่ตั้งเตือนยังไม่ถึง เพื่อไม่ให้ schedule notification ในอดีต
        print("notificationId: $notificationId");
        print("scheduledDateTime: $scheduledDateTime");
        print("Current time: ${DateTime.now()}");
        print("Is scheduledDateTime after now? ${scheduledDateTime.isAfter(DateTime.now())}");
        if (scheduledDateTime.isAfter(DateTime.now())) {
          await _flutterLocalNotificationsPlugin.zonedSchedule(
            notificationId,
            reminder.title,
            reminder.description,
            tz.TZDateTime.from(scheduledDateTime, tz.local),
            notificationDetails,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
            payload: reminder.id.toString(),
          );
          print('Scheduled SINGLE notification (ID: ${reminder.id}): ${reminder.title} at ${reminder.scheduledTime}');
        } else {
          print('Reminder ID: ${reminder.id} - Scheduled time is in the past for single notification. Not scheduling.');
        }
      }
    } catch (e) {
      print('❌ Error scheduling notification for reminder ${reminder.title}: $e');
      // Don't rethrow to prevent app crash
    }
  }

  // Helper method to get the next instance of a recurring reminder
  // This is crucial for `zonedSchedule` with `matchDateTimeComponents`
  // It ensures the initial scheduled time is in the future if the original
  // scheduled time has passed for the current day/week/month/year.
  static tz.TZDateTime _nextInstanceOfReminder(DateTime scheduledTime, ReminderModel reminder) {
    tz.TZDateTime scheduledTZ = tz.TZDateTime.from(scheduledTime, tz.local);
    tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    switch (reminder.recurrenceType) {
      case RecurrenceType.daily:
        tz.TZDateTime nextInstance = tz.TZDateTime(tz.local, now.year, now.month, now.day, scheduledTZ.hour, scheduledTZ.minute, scheduledTZ.second);
        if (nextInstance.isBefore(now)) {
          nextInstance = nextInstance.add(const Duration(days: 1));
        }
        return nextInstance;
      case RecurrenceType.weekly:
        // Dart DateTime.weekday: 1 = Monday, ..., 7 = Sunday
        // reminder.dayOfWeek ควรเก็บค่าตาม Dart's weekday (1-7)
        int targetWeekday = reminder.dayOfWeek ?? DateTime.monday; // Default to Monday if null

        tz.TZDateTime nextInstance = tz.TZDateTime(tz.local, now.year, now.month, now.day, scheduledTZ.hour, scheduledTZ.minute, scheduledTZ.second);

        // Find the next occurrence of the targetWeekday
        while (nextInstance.weekday != targetWeekday) {
          nextInstance = nextInstance.add(const Duration(days: 1));
        }

        // If the calculated next instance is in the past (e.g., today's target time has passed)
        if (nextInstance.isBefore(now)) {
          nextInstance = nextInstance.add(const Duration(days: 7)); // Move to next week
        }
        return nextInstance;
      case RecurrenceType.monthly:
        tz.TZDateTime nextInstance = tz.TZDateTime(
          tz.local,
          now.year,
          now.month,
          (reminder.dayOfMonth ?? 1).clamp(1, 31), // Clamp day of month to valid range
          scheduledTZ.hour,
          scheduledTZ.minute,
          scheduledTZ.second,
        );
        if (nextInstance.isBefore(now)) {
          // If the day in the current month has passed, move to next month
          nextInstance = tz.TZDateTime(
            tz.local,
            now.year,
            now.month + 1,
            (reminder.dayOfMonth ?? 1).clamp(1, 31),
            scheduledTZ.hour,
            scheduledTZ.minute,
            scheduledTZ.second,
          );
          // Handle month overflow (e.g., month 13 becomes next year, month 1)
          if (nextInstance.month > 12) {
            nextInstance = tz.TZDateTime(
              tz.local,
              nextInstance.year + 1,
              1, // January
              nextInstance.day,
              nextInstance.hour,
              nextInstance.minute,
              nextInstance.second,
            );
          }
        }
        return nextInstance;
      case RecurrenceType.yearly:
        tz.TZDateTime nextInstance = tz.TZDateTime(
          tz.local,
          now.year,
          (reminder.monthOfYear ?? 1).clamp(1, 12),
          (reminder.dayOfMonth ?? 1).clamp(1, 31),
          scheduledTZ.hour,
          scheduledTZ.minute,
          scheduledTZ.second,
        );
        if (nextInstance.isBefore(now)) {
          // If the date in the current year has passed, move to next year
          nextInstance = tz.TZDateTime(
            tz.local,
            now.year + 1,
            (reminder.monthOfYear ?? 1).clamp(1, 12),
            (reminder.dayOfMonth ?? 1).clamp(1, 31),
            scheduledTZ.hour,
            scheduledTZ.minute,
            scheduledTZ.second,
          );
        }
        return nextInstance;
      case RecurrenceType.none:
        return scheduledTZ;
    }
  }

  static Future<void> cancelNotification(int reminderId) async {
    try {
      await _flutterLocalNotificationsPlugin.cancel(reminderId);
      print('Cancelled notification for reminder ID: $reminderId');
    } catch (e) {
      print('❌ Error cancelling notification for reminder ID $reminderId: $e');
      // Don't rethrow - continue execution
    }
  }

  static Future<void> cancelAllNotifications() async {
    try {
      await _flutterLocalNotificationsPlugin.cancelAll();
      print('Cancelled all notifications');
    } catch (e) {
      print('❌ Error cancelling all notifications: $e');
      // Don't rethrow - continue execution
    }
  }

  static Future<void> showInstantNotification() async {
    try {
      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          'test_channel_id', // ID ใหม่สำหรับ Channel ทดสอบ
          'Test Channel',
          channelDescription: 'Channel for testing notifications',
          importance: Importance.max, // ตั้งค่าสูงสุดเพื่อให้เด้งขึ้นมา
          priority: Priority.max,
          ticker: 'Test Ticker',
          fullScreenIntent: true, // ลองเปิด fullScreenIntent เพื่อให้เด้งขึ้นมาเต็มจอ
        ),
        iOS: DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true),
      );

      await _flutterLocalNotificationsPlugin.show(
        999, // ID ที่ไม่ซ้ำกัน
        'Test Notification',
        'This is an instant test notification!',
        notificationDetails,
        payload: 'test_payload',
      );
      print('Attempted to show instant notification.');
    } catch (e) {
      print('❌ Error showing instant notification: $e');
    }
  }

  /// Request notification permissions for both Android and iOS
  static Future<bool> requestNotificationPermissions() async {
    try {
      bool granted = false;
      
      // For Android 13+ (API level 33+)
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        final bool? androidGranted = await androidImplementation.requestNotificationsPermission();
        granted = androidGranted ?? false;
        print('Android notification permission granted: $granted');
      }

      // For iOS
      final IOSFlutterLocalNotificationsPlugin? iosImplementation =
          _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();

      if (iosImplementation != null) {
        final bool? iosGranted = await iosImplementation.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
          critical: true,
        );
        granted = iosGranted ?? granted;
        print('iOS notification permission granted: $iosGranted');
      }

      return granted;
    } catch (e) {
      print('❌ Error requesting notification permissions: $e');
      return false;
    }
  }

  /// Create notification channel for Android
  static Future<void> _createNotificationChannel() async {
    try {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'reminder_channel_id',
        'Reminder Channel',
        description: 'Channel for reminder notifications',
        importance: Importance.high,
        enableVibration: true,
        playSound: true,
      );

      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      await androidImplementation?.createNotificationChannel(channel);
      print('Notification channel created: ${channel.id}');
    } catch (e) {
      print('❌ Error creating notification channel: $e');
    }
  }

  /// Check if notifications are enabled
  static Future<bool> areNotificationsEnabled() async {
    try {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        final bool? enabled = await androidImplementation.areNotificationsEnabled();
        return enabled ?? false;
      }

      final IOSFlutterLocalNotificationsPlugin? iosImplementation =
          _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();

      if (iosImplementation != null) {
        final permissions = await iosImplementation.checkPermissions();
        return permissions?.isEnabled ?? false;
      }

      return false;
    } catch (e) {
      print('❌ Error checking notification permissions: $e');
      return false;
    }
  }

  /// Get pending notifications for debugging
  static Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    try {
      return await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
    } catch (e) {
      print('❌ Error getting pending notifications: $e');
      return [];
    }
  }
}
