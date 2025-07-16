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
  
  // Handle uncaught errors
  FlutterError.onError = (FlutterErrorDetails details) {
    print('❌ Flutter Error: ${details.exception}');
    print('❌ Stack Trace: ${details.stack}');
  };
  
  try {
    // Initialize notification service
    await NotificationService.init();
    print('✅ NotificationService initialized successfully');
    
    // Initialize ObjectBox database
    await ObjectBoxDatabase.init();
    print('✅ ObjectBox database initialized successfully');
    
    // Check notification permissions
    final isEnabled = await NotificationService.areNotificationsEnabled();
    print('📱 Notifications enabled: $isEnabled');
    
    // Test notification to verify it's working (only if enabled)
    // if (isEnabled) {
    //   await NotificationService.showInstantNotification();
    //   print('🔔 Test notification sent');
    // } else {
    //   print('⚠️ Notifications not enabled - skipping test notification');
    // }
    
    // Reschedule all active reminders with better error handling
    try {
      final allReminders = ObjectBoxDatabase.instance.reminderBox.getAll();
      print('📋 Found ${allReminders.length} reminders in database');
      
      // First, cancel all existing notifications to avoid conflicts
      try {
        await NotificationService.cancelAllNotifications();
        print('🧹 Cleared all existing notifications');
      } catch (e) {
        print('⚠️ Warning: Could not clear existing notifications: $e');
      }
      
      int rescheduledCount = 0;
      for (var reminder in allReminders) {
        if (reminder.isActive) {
          try {
            await NotificationService.scheduleNotification(reminder);
            rescheduledCount++;
            print('✅ Rescheduled reminder: ${reminder.title}');
          } catch (e) {
            print('❌ Failed to reschedule reminder ${reminder.title}: $e');
          }
        }
      }
      
      print('🎯 Successfully rescheduled $rescheduledCount active reminders');
    } catch (e) {
      print('❌ Critical error during notification rescheduling: $e');
      // Continue anyway - app should still work without notifications
    }
    
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
