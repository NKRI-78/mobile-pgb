import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

import '../../../misc/colors.dart';
import '../../../misc/register_akun_extra.dart';
import '../../../misc/text_style.dart';
import '../../../router/builder.dart';
import '../cubit/register_otp_cubit.dart';

class RegisterOtpPage extends StatelessWidget {
  const RegisterOtpPage(
      {super.key,
      required this.email,
      required this.isLogin,
      required this.akunExtra});

  final String email;
  final bool isLogin;
  final RegisterAkunExtra akunExtra;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterOtpCubit>(
      create: (context) => RegisterOtpCubit(isLogin)..init(email),
      child: RegisterOtpView(),
    );
  }
}

class RegisterOtpView extends StatelessWidget {
  const RegisterOtpView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterOtpCubit, RegisterOtpState>(
      builder: (context, state) {
        // Hitung detik yang tersisa
        final minutes = (state.timeRemaining / 60).floor();
        final seconds = state.timeRemaining % 60;
        final timeRemaining =
            '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

        return WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              surfaceTintColor: Colors.transparent,
              title: Text(
                'Kode OTP',
                style: AppTextStyles.textStyleBold.copyWith(
                  color: AppColors.whiteColor,
                  fontSize: 24,
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: const SizedBox(),
            ),
            body: WillPopScope(
              onWillPop: () async => false,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/bg.png',
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 100, left: 24, right: 24),
                    child: SingleChildScrollView(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 20),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: AppTextStyles.textStyleBold.copyWith(
                                  color: AppColors.whiteColor,
                                  fontSize: 15,
                                ),
                                children: [
                                  TextSpan(
                                      text:
                                          "Kami telah mengirimkan Kode OTP ke "),
                                  TextSpan(
                                    text: state.email,
                                    style: AppTextStyles.textStyleBold.copyWith(
                                      color: AppColors.yellowColor,
                                      fontSize: 15,
                                    ),
                                  ),
                                  TextSpan(
                                      text:
                                          " yang di gunakan pada saat Registrasi."),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Email Anda salah? ',
                                    style: AppTextStyles.textStyleBold.copyWith(
                                      color: AppColors.whiteColor,
                                      fontSize: 15,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Klik di sini',
                                    style: AppTextStyles.textStyleBold.copyWith(
                                      color: AppColors.yellowColor,
                                      fontSize: 15,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                        final result =
                                            await RegisterChangeRoute(
                                          isLogin: true,
                                          email: state.email,
                                          $extra: RegisterAkunExtra(),
                                        ).push(context);
                                        if (result != null && context.mounted) {
                                          context
                                              .read<RegisterOtpCubit>()
                                              .updateEmail(result);
                                        }
                                      },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 40),
                            Text(
                              "Masukkan Kode OTP pada kolom yang tersedia",
                              style: AppTextStyles.textStyleNormal.copyWith(
                                fontSize: 12,
                                color: AppColors.whiteColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20),
                            Pinput(
                              androidSmsAutofillMethod:
                                  AndroidSmsAutofillMethod.none,
                              length: 4,
                              defaultPinTheme: PinTheme(
                                width: 60,
                                height: 70,
                                textStyle: AppTextStyles.textStyleBold.copyWith(
                                  color: AppColors.whiteColor,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border:
                                      Border.all(color: AppColors.whiteColor),
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
                                  border:
                                      Border.all(color: AppColors.whiteColor),
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
                                    .read<RegisterOtpCubit>()
                                    .submit(value, context);
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
                                              .read<RegisterOtpCubit>()
                                              .resendOtp(context);
                                        }
                                      },
                                  ),
                                  TextSpan(
                                    text:
                                        " apabila belum mendapatkan\nKode OTP",
                                    style: AppTextStyles.textStyleBold.copyWith(
                                      color: AppColors.whiteColor,
                                      fontSize: 15,
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
            ),
          ),
        );
      },
    );
  }
}
