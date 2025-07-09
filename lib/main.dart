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
  
  // Initialize notification service
  await NotificationService.init();
  
  // Initialize ObjectBox database
  await ObjectBoxDatabase.init();
  
  // Check notification permissions
  final isEnabled = await NotificationService.areNotificationsEnabled();
  print('Notifications enabled: $isEnabled');
  
  // Test notification to verify it's working
  await NotificationService.showInstantNotification(); 
  
  // Reschedule all active reminders
  final allReminders = ObjectBoxDatabase.instance.reminderBox.getAll();
  print('Found ${allReminders.length} reminders in database');
  
  for (var reminder in allReminders) {
    if (reminder.isActive) {
      await NotificationService.scheduleNotification(reminder);
      print('Rescheduled reminder: ${reminder.title}');
    }
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
