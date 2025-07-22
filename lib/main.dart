import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'misc/remote_config.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:upgrader/upgrader.dart';

import 'firebase_options.dart';
import 'misc/firebase_messangging.dart';
import 'misc/injections.dart';
import 'modules/app/bloc_observer.dart';
import 'modules/app/view/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting("id_ID", null);
  timeago.setLocaleMessages('id', timeago.IdMessages());

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );
  Bloc.observer = const AppBlocObserver();
  MyInjection.setup();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await MyRemoteConfig.init();
  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    await setupFlutterNotifications();
  }
  if (kDebugMode) await Upgrader.clearSavedSettings();

  runApp(const App());
}
