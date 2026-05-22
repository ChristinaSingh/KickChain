import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/common/theme_data.dart';
import 'app/common/PushNotificationService.dart';
import 'app/common/wallet_service.dart';
import 'app/routes/app_pages.dart';
import 'firebase_options.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('Background message: ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Register WalletService (initialization happens when context is ready)
  Get.put(WalletService());

  await GetStorage.init();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
  );

  // ── Push notifications ────────────────────────────────────
  if (kIsWeb) {
    // Keep first paint fast on web; do not block startup on notification flows.
    Future<void>(() async {
      await PushNotificationService().initialize(requestPermission: false);
    });
  } else if (defaultTargetPlatform == TargetPlatform.android) {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: (payload) async {
        print('Notification tapped: ${payload.payload}');
      },
    );

    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation;
    // AndroidFlutterLocalNotificationsPlugin>()
    //     ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
  } else if (defaultTargetPlatform == TargetPlatform.iOS) {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation;
    // IOSFlutterLocalNotificationsPlugin>()!
    //     .requestPermissions(alert: true, badge: true, sound: true);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  runApp(
    GetMaterialApp(
      title: "Kick chain",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      theme: MThemeData.themeData(),
      fallbackLocale: const Locale('en', 'US'),
    ),
  );
}
