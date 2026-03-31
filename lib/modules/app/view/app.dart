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

      debugPrint("=== REVIEW CHECK START ===");
      debugPrint("NOW: $now");

      // ✅ first install
      int? firstInstallMillis = prefs.getInt('review_first_install');

      if (firstInstallMillis == null) {
        await prefs.setInt(
          'review_first_install',
          now.millisecondsSinceEpoch,
        );

        await prefs.setInt('review_next_day', 30);

        debugPrint("First install detected → set nextDay = 30");
        debugPrint("=== REVIEW END (FIRST INSTALL) ===");

        return;
      }

      final firstInstall =
          DateTime.fromMillisecondsSinceEpoch(firstInstallMillis);

      final daysSinceInstall = now.difference(firstInstall).inDays;

      int nextDay = prefs.getInt('review_next_day') ?? 30;

      debugPrint("First Install: $firstInstall");
      debugPrint("Days Since Install: $daysSinceInstall");
      debugPrint("Next Target Day: $nextDay");

      // ❌ belum sampai target
      if (daysSinceInstall < nextDay) {
        debugPrint(
            "SKIP: belum sampai target (${daysSinceInstall} < $nextDay)");
        debugPrint("=== REVIEW END (SKIP) ===");
        return;
      }

      debugPrint("TARGET REACHED → try show review");

      // ✅ cek availability
      if (await review.isAvailable()) {
        debugPrint("Review AVAILABLE");

        await Future.delayed(const Duration(seconds: 3));

        await review.requestReview();

        int newNextDay = nextDay + 30;

        await prefs.setInt('review_next_day', newNextDay);

        debugPrint("REVIEW SHOWN");
        debugPrint("Next target updated → $newNextDay");
      } else {
        debugPrint("Review NOT available");
      }

      debugPrint("=== REVIEW END ===");
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
