import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../firebase_options.dart';
import 'navigation.dart';
import '../router/builder.dart';

class FirebaseMessagingMisc {
  static Future<void> init() async {
    // FirebaseMessaging.instance.requestPermission();
    FirebaseMessaging.instance.getInitialMessage().then(
      (message) async {
        debugPrint('Pasklik');
        debugPrint("Data : ${message?.data}");
        await Future.delayed(const Duration(seconds: 2));
        if (myNavigatorKey.currentContext != null &&
            message?.data['type'] == "PAYMENT") {
          WaitingPaymentV2Route(id: message?.data['id'] ?? "0")
              .push(myNavigatorKey.currentContext!);
        }
        if (myNavigatorKey.currentContext != null &&
            message?.data['type'] == "SOS") {
          NotificationDetailRoute(idNotif: int.parse(message?.data['id'] ?? "0"))
              .push(myNavigatorKey.currentContext!);
        }
        if (myNavigatorKey.currentContext != null &&
            message?.data['type'] == "BROADCAST") {
          NotificationDetailRoute(idNotif: int.parse(message?.data['id'] ?? "0"))
              .push(myNavigatorKey.currentContext!);
        }
        if (myNavigatorKey.currentContext != null &&
            message?.data['type'] == "FORUM") {
          ForumDetailRoute(idForum: message?.data['id'] ?? "0")
              .push(myNavigatorKey.currentContext!);
        }
        if (myNavigatorKey.currentContext != null &&
            message?.data['type'] == "EVENT") {
          EventDetailRoute(idEvent: int.parse(message?.data['id'] ?? "0"))
              .push(myNavigatorKey.currentContext!);
        }
        if (myNavigatorKey.currentContext != null &&
            message?.data['type'] == "NEWS") {
          NewsDetailRoute(newsId: int.parse(message?.data['id'] ?? "0"))
              .push(myNavigatorKey.currentContext!);
        }
      },
    );

    FirebaseMessaging.onMessage.listen(showFlutterNotification);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      debugPrint("Test comment id${message.data['title']}");
      debugPrint("Data notif: ${message.data}");
      await Future.delayed(const Duration(seconds: 2));
      if (myNavigatorKey.currentContext != null &&
          message.data['type'] == "PAYMENT") {
        WaitingPaymentV2Route(id: message.data['id'] ?? "0")
            .push(myNavigatorKey.currentContext!);
      }
      if (myNavigatorKey.currentContext != null &&
          message.data['type'] == "SOS") {
        NotificationDetailRoute(idNotif: int.parse(message.data['id'] ?? "0"))
            .push(myNavigatorKey.currentContext!);
      }
      if (myNavigatorKey.currentContext != null &&
          message.data['type'] == "BROADCAST") {
        NotificationDetailRoute(idNotif: int.parse(message.data['id'] ?? "0"))
            .push(myNavigatorKey.currentContext!);
      }
      if (myNavigatorKey.currentContext != null &&
          message.data['type'] == "FORUM") {
        ForumDetailRoute(idForum: message.data['id'] ?? "0")
            .push(myNavigatorKey.currentContext!);
      }
      if (myNavigatorKey.currentContext != null &&
          message.data['type'] == "EVENT") {
        EventDetailRoute(idEvent: int.parse(message.data['id'] ?? "0"))
            .push(myNavigatorKey.currentContext!);
      }
      if (myNavigatorKey.currentContext != null &&
          message.data['type'] == "EVENT") {
        NewsDetailRoute(newsId: int.parse(message.data['id'] ?? "0"))
            .push(myNavigatorKey.currentContext!);
      }
    });
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupFlutterNotifications();

  // showFlutterNotification(message);
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  debugPrint('Handling a background message ${message.data}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

bool isFlutterLocalNotificationsInitialized = false;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }

  channel = const AndroidNotificationChannel(
    'pgb_notif', // id
    'pgb Notification', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  isFlutterLocalNotificationsInitialized = true;

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');

  const DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
    requestSoundPermission: false,
    requestBadgePermission: false,
    requestAlertPermission: false,
  );

  const LinuxInitializationSettings initializationSettingsLinux =
      LinuxInitializationSettings(defaultActionName: 'Open notification');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
    macOS: initializationSettingsDarwin,
    linux: initializationSettingsLinux,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
  );
}

void onDidReceiveLocalNotification(
    int id, String? title, String? body, String? payload) async {
  // display a dialog with the notification details, tap ok to go to another page
}

void onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse) async {
  final String? payload = notificationResponse.payload;
  if (notificationResponse.payload != null) {
    debugPrint("Test comment id ${json.decode(payload!)}");
    if (json.decode(payload)['type'] == "PAYMENT") {
      WaitingPaymentV2Route(id: json.decode(payload)['id'])
          .push(myNavigatorKey.currentContext!);
    }
    if (json.decode(payload)['type'] == "SOS") {
      NotificationDetailRoute(idNotif: int.parse(json.decode(payload)['id']))
          .push(myNavigatorKey.currentContext!);
    }
    if (json.decode(payload)['type'] == "BROADCAST") {
      NotificationDetailRoute(idNotif: int.parse(json.decode(payload)['id']))
          .push(myNavigatorKey.currentContext!);
    }
    if (json.decode(payload)['type'] == "FORUM") {
      ForumDetailRoute(idForum: json.decode(payload)['id'])
          .push(myNavigatorKey.currentContext!);
    }
    if (json.decode(payload)['type'] == "EVENT") {
      EventDetailRoute(idEvent: int.parse(json.decode(payload)['id']))
          .push(myNavigatorKey.currentContext!);
    }
    if (json.decode(payload)['type'] == "NEWS") {
      NewsDetailRoute(newsId: int.parse(json.decode(payload)['id']))
          .push(myNavigatorKey.currentContext!);
    }
  }
}

void showFlutterNotification(RemoteMessage message) async {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;

  if (notification != null && android != null && !kIsWeb) {
    debugPrint("Channel name : ${notification.title}");
    flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: '@drawable/ic_notification',
            // sound: const RawResourceAndroidNotificationSound('notification'),
            // playSound: true,
          ),
        ),
        payload: json.encode(message.data));
  }
}

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
