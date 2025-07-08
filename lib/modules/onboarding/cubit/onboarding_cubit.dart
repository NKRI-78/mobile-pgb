import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../router/builder.dart';
import '../../app/bloc/app_bloc.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(OnboardingState());
  static PageController pageController = PageController();

  void changeIndex(int index) {
    emit(state.copyWith(index: index));
  }

  void nextPage() {
    OnboardingCubit.pageController.nextPage(
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void finishOnboarding(BuildContext context) async {
    final settings = await FirebaseMessaging.instance.requestPermission();

    if (settings.authorizationStatus != AuthorizationStatus.notDetermined) {
      // ✅ User sudah memilih "Izinkan" atau "Jangan Izinkan"
      context.read<AppBloc>().add(FinishOnboarding());
      HomeRoute().go(context);
    } else {
      // ⚠️ User belum memutuskan (kemungkinan dialog belum ditutup)
      debugPrint('User belum merespons izin notifikasi.');
    }
  }
}
