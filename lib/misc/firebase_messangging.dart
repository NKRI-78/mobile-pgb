import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobile_pgb/modules/app/bloc/app_bloc.dart';

import '../firebase_options.dart';
import '../router/builder.dart';
import 'navigation.dart';

class FirebaseMessagingMisc {
  static Future<void> init() async {
    FirebaseMessaging.instance.getInitialMessage().then(
      (message) async {
        await Future.delayed(const Duration(seconds: 2));
        if (message != null) {
          await handleNavigation(message.data);
        }
      },
    );

    FirebaseMessaging.onMessage.listen(showFlutterNotification);

    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) async {
        await Future.delayed(const Duration(seconds: 2));
        await handleNavigation(message.data);
      },
    );
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

  if (payload != null) {
    final data = json.decode(payload);
    await handleNavigation(data);
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

Future<void> handleNavigation(Map<String, dynamic> data) async {
  final context = myNavigatorKey.currentContext;
  if (context == null) return;

  final appState = context.read<AppBloc>().state;

  final type = data['type'];

  if ((type == "FORUM" || type == "BROADCAST") && !appState.isLoggedIn) {
    LoginRoute().push(context);
    return;
  }

  switch (type) {
    case "PAYMENT":
      WaitingPaymentV2Route(id: data['id'] ?? "0").push(context);
      break;

    case "SOS":
      NotificationDetailRoute(
        idNotif: int.tryParse(data['id']?.toString() ?? '') ?? 0,
      ).push(context);
      break;

    case "BROADCAST":
      NotificationDetailRoute(
        idNotif: int.parse(data['notif_id'] ?? "0"),
      ).push(context);
      break;

    case "FORUM":
      ForumDetailRoute(
        idForum: data['id'] ?? "0",
      ).push(context);
      break;

    case "EVENT":
      EventDetailRoute(
        idEvent: int.tryParse(data['id']?.toString() ?? '') ?? 0,
      ).push(context);
      break;

    case "NEWS":
      NewsDetailRoute(
        newsId: int.tryParse(data['id']?.toString() ?? '') ?? 0,
      ).push(context);
      break;
  }
}
