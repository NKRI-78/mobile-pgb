import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../misc/helper.dart';
import 'package:upgrader/upgrader.dart';
import '../../../misc/firebase_messangging.dart';

import '../../../misc/injections.dart';
import '../../../misc/theme.dart';
import '../../../router/router.dart';
import '../bloc/app_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final app = getIt<AppBloc>();
    return BlocProvider<AppBloc>.value(
      value: app..add(InitialAppData()),
      child: AppView(),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  Future<void> checkReview() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final review = InAppReview.instance;

      final now = DateTime.now();
      final lastShownMillis = prefs.getInt('review_last');

      // jika pernah tampil
      if (lastShownMillis != null) {
        final lastShown = DateTime.fromMillisecondsSinceEpoch(lastShownMillis);

        final diff = now.difference(lastShown).inDays;

        // belum 3 bulan (90 hari)
        if (diff < 90) {
          return;
        }
      }

      if (await review.isAvailable()) {
        await Future.delayed(const Duration(seconds: 4));

        await review.requestReview();

        await prefs.setInt('review_last', now.millisecondsSinceEpoch);
      }
    } catch (e) {
      debugPrint("Review error: $e");
    }
  }

  final router = MyRouter.init(getIt<AppBloc>());
  final _upgrader = Upgrader(
    countryCode: 'id',
    debugLogging: false,
    messages: UpgraderMessagesIndonesian(),
  );

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      FirebaseMessagingMisc.init();
      checkReview();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (_, localState) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: baseTheme.copyWith(),
          routerConfig: router,
          builder: (context, child) {
            return UpgradeAlert(
              barrierDismissible: false,
              shouldPopScope: () => false,
              showIgnore: false,
              showLater: false,
              upgrader: _upgrader,
              showReleaseNotes: false,
              dialogStyle: Platform.isAndroid
                  ? UpgradeDialogStyle.material
                  : UpgradeDialogStyle.cupertino,
              navigatorKey: router.configuration.navigatorKey,
              child: child,
            );
          },
        );
      },
    );
  }
}
