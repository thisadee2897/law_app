// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:injectable/injectable.dart';

// import '../constants/app_constants.dart';

// @singleton
// class NotificationService {
//   final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

//   Future<void> init() async {
//     const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

//     const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     );

//     const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

//     await _notificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: _onNotificationTapped);

//     await _createNotificationChannel();
//   }

//   Future<void> _createNotificationChannel() async {
//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       AppConstants.notificationChannelId,
//       AppConstants.notificationChannelName,
//       description: AppConstants.notificationChannelDescription,
//       importance: Importance.high,
//     );

//     await _notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
//   }

//   Future<void> scheduleNotification({required int id, required String title, required String body, required DateTime scheduledDate}) async {
//     const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//       AppConstants.notificationChannelId,
//       AppConstants.notificationChannelName,
//       channelDescription: AppConstants.notificationChannelDescription,
//       importance: Importance.high,
//       priority: Priority.high,
//     );

//     const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

//     const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidDetails, iOS: iosDetails);

//     await _notificationsPlugin.zonedSchedule(
//       id,
//       title,
//       body,
//       tz.TZDateTime.from(scheduledDate, tz.local),
//       platformChannelSpecifics,
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//       uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
//       matchDateTimeComponents: DateTimeComponents.time,
//     );
//   }

//   Future<void> scheduleRepeatingNotification({
//     required int id,
//     required String title,
//     required String body,
//     required DateTime scheduledDate,
//     required RepeatInterval repeatInterval,
//   }) async {
//     const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//       AppConstants.notificationChannelId,
//       AppConstants.notificationChannelName,
//       channelDescription: AppConstants.notificationChannelDescription,
//       importance: Importance.high,
//       priority: Priority.high,
//     );

//     const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

//     const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidDetails, iOS: iosDetails);

//     await _notificationsPlugin.periodicallyShow(
//       id,
//       title,
//       body,
//       repeatInterval,
//       platformChannelSpecifics,
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//     );
//   }

//   Future<void> cancelNotification(int id) async {
//     await _notificationsPlugin.cancel(id);
//   }

//   Future<void> cancelAllNotifications() async {
//     await _notificationsPlugin.cancelAll();
//   }

//   Future<List<PendingNotificationRequest>> getPendingNotifications() async {
//     return await _notificationsPlugin.pendingNotificationRequests();
//   }

//   void _onNotificationTapped(NotificationResponse response) {
//     // Handle notification tap
//     // You can navigate to specific screens based on the notification payload
//   }

//   Future<bool> requestPermissions() async {
//     final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
//         _notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

//     final bool? grantedAndroid = await androidImplementation?.requestNotificationsPermission();

//     final IOSFlutterLocalNotificationsPlugin? iosImplementation =
//         _notificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();

//     final bool? grantedIOS = await iosImplementation?.requestPermissions(alert: true, badge: true, sound: true);

//     return grantedAndroid ?? grantedIOS ?? false;
//   }
// }
