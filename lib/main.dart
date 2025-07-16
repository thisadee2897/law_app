import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:law_app/core/database/objectbox_database.dart';
import 'package:law_app/core/utils/services/notification_service.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.remove();

  // จัดการ Error ที่เกิดจาก Flutter
  FlutterError.onError = (FlutterErrorDetails details) {
    print('❌ Flutter Error: ${details.exception}');
    print('❌ Stack Trace: ${details.stack}');
  };

  try {
    // ✅ 1. Init ObjectBox
    await ObjectBoxDatabase.init();
    print('✅ ObjectBox database initialized successfully');

    // ✅ 2. Init Notification
    await NotificationService.init();
    print('✅ NotificationService initialized successfully');

    // ✅ 3. ตรวจสอบว่าเปิดสิทธิ์แจ้งเตือนหรือยัง
    final isEnabled = await NotificationService.areNotificationsEnabled();
    print('📱 Notifications enabled: $isEnabled');

    // ✅ 4. เรียก schedule เฉพาะ reminders ที่ active และ scheduledTime > now
    final allReminders = ObjectBoxDatabase.instance.reminderBox.getAll();
    final activeReminders = allReminders.where((r) =>
      r.isActive && r.getScheduledDateTime.isAfter(DateTime.now())
    );

    print('📋 Found ${activeReminders.length} active future reminders');

    int successCount = 0;
    for (final reminder in activeReminders) {
      try {
        await NotificationService.scheduleNotification(reminder);
        print('✅ Scheduled reminder: ${reminder.title}');
        successCount++;
      } catch (e) {
        print('❌ Failed to schedule reminder: ${reminder.title} - $e');
      }
    }
    print('🎯 Rescheduled $successCount reminders successfully');
  } catch (e) {
    print('❌ Error during app initialization: $e');
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appRouter = ref.watch(appRouterProvider);
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Law Reminder App',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.light,
          routerConfig: appRouter,
          localizationsDelegates: const [GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
          supportedLocales: const [Locale('en', 'US'), Locale('th', 'TH')],
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
