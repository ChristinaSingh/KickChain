import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../firebase_options.dart';

const String firebaseWebVapidKey = String.fromEnvironment(
  'FIREBASE_WEB_VAPID_KEY',
  defaultValue:
      'BAWDGeL6DRA6tr8_E7_-FrKlca8-HRKst3Zm2FeKqcIhSmh3ZdVfgl6f0fjww3_I3eYwYdiVE51Cp0XiS2DlZrs',
);

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  importance: Importance.high,
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('Handling a background message ${message.messageId}');
}

class PushNotificationService {
  FirebaseMessaging fcm = FirebaseMessaging.instance;

  Future initialize({bool requestPermission = true}) async {
    if (kIsWeb) {
      if (requestPermission) {
        await FirebaseMessaging.instance.requestPermission(
          alert: true,
          badge: true,
          sound: true,
        );
      }

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Got a web foreground message!');
        print('Message data: ${message.data}');
        if (message.notification != null) {
          print('Message notification: ${message.notification}');
        }
      });

      if (requestPermission) {
        await getToken();
      }
      return;
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  static Future<String?> getToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    if (kIsWeb) {
      if (firebaseWebVapidKey.isEmpty) {
        print('Firebase web VAPID key is missing.');
        return null;
      }
      final settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        print('Web notification permission denied.');
        return null;
      }
      final token = await messaging.getToken(vapidKey: firebaseWebVapidKey);
      print('Web Firebase Token: $token');
      return token;
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      String? token = await messaging.getToken();
      print('My Token:- $token');
      return token;
    } else {
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        await messaging.requestPermission();
        String? apnsToken;
        while (apnsToken == null) {
          apnsToken = await messaging.getAPNSToken();
          if (apnsToken == null) {
            await Future.delayed(const Duration(seconds: 1));
          }
        }
        print("APNS Token: $apnsToken");
        String? token = await messaging.getToken();
        print("Firebase Token: $token");
        return token ?? 'hiuhjkuhj';
        // Handle token, register it with your server if needed
      }
    }
    return null;
  }
}
