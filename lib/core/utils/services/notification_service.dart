// services/notification_service.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

      const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

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
      final DateTime scheduledDateTime = reminder.getScheduledDateTime;

      if (!scheduledDateTime.isAfter(DateTime.now())) {
        debugPrint('⚠️ Reminder ID: ${reminder.id} - Scheduled time is in the past. Skipping notification.');
        return;
      }

      final tz.TZDateTime tzScheduledDateTime = tz.TZDateTime.from(scheduledDateTime, tz.local);

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        reminder.id, // ID
        reminder.title, // title
        reminder.description, // body
        tzScheduledDateTime, // เมื่อไร
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'reminder_channel_id',
            'Reminder Channel',
            channelDescription: 'Channel for reminder notifications',
            importance: Importance.max,
            priority: Priority.high,
            enableVibration: true,
            playSound: true,
            fullScreenIntent: true,
          ),
          iOS: DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true, interruptionLevel: InterruptionLevel.timeSensitive),
        ),
        matchDateTimeComponents: DateTimeComponents.time,
        payload: 'reminder_payload_${reminder.id}',
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle
      );

      debugPrint('✅ Scheduled reminder: ${reminder.title}');
    } catch (e) {
      debugPrint('❌ Error in scheduleNotification: $e');
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
      // Skip the problematic pendingNotificationRequests call in release mode
      // and directly use cancelAll as the safest approach
      debugPrint('🧹 Attempting to clear notifications...');

      // Simple direct approach - no pending requests check
      await _flutterLocalNotificationsPlugin.cancelAll();
      debugPrint('Cancelled all notifications directly');
    } catch (e) {
      debugPrint('❌ Error cancelling all notifications: $e');
      // Don't try any fallbacks to avoid the "Missing type parameter" bug
      debugPrint('🧹 Cleared all existing notifications (with errors ignored)');
    }
  }

  static Future<void> showInstantNotification() async {
    try {
      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          'reminder_channel_id', // ใช้ channel เดียวกัน
          'Reminder Channel',
          channelDescription: 'Channel for reminder notifications',
          importance: Importance.max, // ตั้งค่าสูงสุดเพื่อให้เด้งขึ้นมา
          priority: Priority.max,
          ticker: 'Test Ticker',
          fullScreenIntent: true, // ลองเปิด fullScreenIntent เพื่อให้เด้งขึ้นมาเต็มจอ
          enableVibration: true,
          playSound: true,
          enableLights: true,
          sound: null, // ใช้เสียงเริ่มต้นของระบบ
          autoCancel: true,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          sound: null, // ใช้เสียงเริ่มต้นของระบบ
          interruptionLevel: InterruptionLevel.timeSensitive,
        ),
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
          _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        final bool? androidGranted = await androidImplementation.requestNotificationsPermission();
        granted = androidGranted ?? false;
        print('Android notification permission granted: $granted');
      }

      // For iOS
      final IOSFlutterLocalNotificationsPlugin? iosImplementation =
          _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();

      if (iosImplementation != null) {
        final bool? iosGranted = await iosImplementation.requestPermissions(alert: true, badge: true, sound: true, critical: true);
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
      final AndroidNotificationChannel channel = AndroidNotificationChannel(
        'reminder_channel_id',
        'Reminder Channel',
        description: 'Channel for reminder notifications',
        importance: Importance.max, // เพิ่มเป็น max
        enableVibration: true,
        vibrationPattern: Int64List.fromList([0, 1000, 500, 1000]), // รูปแบบการสั่น
        playSound: true,
        enableLights: true,
        ledColor: const Color.fromARGB(255, 255, 0, 0), // ไฟ LED สีแดง
        showBadge: true,
        sound: null, // ใช้เสียงเริ่มต้นของระบบ
      );

      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

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
          _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        final bool? enabled = await androidImplementation.areNotificationsEnabled();
        return enabled ?? false;
      }

      final IOSFlutterLocalNotificationsPlugin? iosImplementation =
          _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();

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
      // Skip the problematic call that causes "Missing type parameter" in release mode
      debugPrint('⚠️ getPendingNotifications temporarily disabled to avoid platform bugs');
      return <PendingNotificationRequest>[];
    } catch (e) {
      debugPrint('❌ Error getting pending notifications: $e');
      // Return empty list if there's an error
      return <PendingNotificationRequest>[];
    }
  }
}
