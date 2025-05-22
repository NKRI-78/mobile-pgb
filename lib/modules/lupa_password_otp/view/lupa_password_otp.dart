import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

import '../../../misc/colors.dart';
import '../../../misc/text_style.dart';
import '../cubit/lupa_password_otp_cubit.dart';

class LupaPasswordOtpPage extends StatelessWidget {
  const LupaPasswordOtpPage({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LupaPasswordOtpCubit>(
        create: (context) => LupaPasswordOtpCubit()..init(email),
        child: const LupaPasswordOtpView());
  }
}

class LupaPasswordOtpView extends StatelessWidget {
  const LupaPasswordOtpView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LupaPasswordOtpCubit, LupaPasswordOtpState>(
        builder: (context, state) {
      final minutes = (state.timeRemaining / 60).floor();
      final seconds = state.timeRemaining % 60;
      final timeRemaining =
          '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          title: Text(
            'Reset Password',
            style: AppTextStyles.textStyleBold.copyWith(
              color: AppColors.whiteColor,
              fontSize: 24,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.whiteColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/bg.png',
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 100, left: 24, right: 24),
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: AppTextStyles.textStyleBold.copyWith(
                            color: AppColors.whiteColor,
                            fontSize: 15,
                          ),
                          children: [
                            TextSpan(
                                text: "Kami telah mengirimkan Kode OTP ke "),
                            TextSpan(
                              text: state.email,
                              style: AppTextStyles.textStyleBold.copyWith(
                                color: AppColors.yellowColor,
                                fontSize: 15,
                              ),
                            ),
                            TextSpan(
                                text:
                                    " yang di gunakan pada saat Reset Password."),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      Text(
                        "Silakan masukkan kode OTP untuk melanjutkan.",
                        style: AppTextStyles.textStyleNormal.copyWith(
                          fontSize: 12,
                          color: AppColors.whiteColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Pinput(
                        androidSmsAutofillMethod: AndroidSmsAutofillMethod.none,
                        length: 4,
                        defaultPinTheme: PinTheme(
                          width: 60,
                          height: 70,
                          textStyle: AppTextStyles.textStyleBold.copyWith(
                            color: AppColors.whiteColor,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.whiteColor),
                          ),
                        ),
                        focusedPinTheme: PinTheme(
                          width: 60,
                          height: 70,
                          textStyle: AppTextStyles.textStyleBold.copyWith(
                            color: AppColors.whiteColor,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.whiteColor),
                          ),
                        ),
                        cursor: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 2,
                              height: 30,
                              color: AppColors.whiteColor,
                            ),
                          ],
                        ),
                        keyboardType: TextInputType.number,
                        onCompleted: (value) {
                          context
                              .read<LupaPasswordOtpCubit>()
                              .submit(context, value);
                        },
                        onChanged: (value) {
                          debugPrint("OTP: $value");
                        },
                      ),
                      SizedBox(height: 30),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: state.timerFinished
                                  ? 'Klik disini'
                                  : timeRemaining,
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Intel',
                                fontWeight: FontWeight.bold,
                                color: state.timerFinished
                                    ? AppColors.yellowColor
                                    : AppColors.yellowColor,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  if (state.timerFinished) {
                                    context
                                        .read<LupaPasswordOtpCubit>()
                                        .forgotPasswordSendOTP(context);
                                  }
                                },
                            ),
                            TextSpan(
                              text: " apabila belum mendapatkan\nKode OTP",
                              style: AppTextStyles.textStyleBold.copyWith(
                                fontSize: 14,
                                color: AppColors.whiteColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
