class AppConstants {
  // App Info
  static const String appName = 'Law Reminder';
  static const String appVersion = '1.0.0';

  // Database
  static const String databaseName = 'law_app_db';

  // Notification Channels
  static const String notificationChannelId = 'law_reminder_channel';
  static const String notificationChannelName = 'Law Reminders';
  static const String notificationChannelDescription = 'Notifications for law reminders';

  // File Extensions
  static const List<String> supportedPdfExtensions = ['.pdf'];

  // Reminder Types
  static const String reminderTypeOnce = 'once';
  static const String reminderTypeDaily = 'daily';
  static const String reminderTypeWeekly = 'weekly';
  static const String reminderTypeMonthly = 'monthly';
  static const String reminderTypeYearly = 'yearly';

  // Storage Paths
  static const String pdfStoragePath = 'pdfs';
  static const String imagesStoragePath = 'images';
}
