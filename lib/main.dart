import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:law_app/core/database/objectbox_database.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'package:timezone/data/latest_all.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
late ObjectBoxDatabase objectBox;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.remove();
  
  // notification
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  
  const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );
  
  const DarwinInitializationSettings initializationSettingsMacOS = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );
  
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
    macOS: initializationSettingsMacOS,
  );
  
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
  );
  
  // Create notification channel for Android
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'your_channel_id',
    'your_channel_name',
    description: 'your_channel_description',
    importance: Importance.max,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  tz.initializeTimeZones();

  objectBox = await ObjectBoxDatabase.init();
  runApp(const ProviderScope(child: MyApp()));
}

void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
  print('Notification response received: ${notificationResponse.payload}');
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
