import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../misc/colors.dart';
import '../../../misc/injections.dart';
import '../../../misc/register_akun_extra.dart';
import '../../../misc/text_style.dart';
import '../../../router/builder.dart';
import '../../../widgets/button/custom_button.dart';
import '../../app/models/user_google_model.dart';
import '../../register_akun/model/extrack_ktp_model.dart';
import '../cubit/register_cubit.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: const RegisterView(),
    );
  }
}

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/bg.png',
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: Center(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Selamat Datang di',
                              style: AppTextStyles.textStyleBold.copyWith(
                                color: AppColors.whiteColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 30),
                            Image.asset(
                              'assets/images/logo_transparant.png',
                              height: size.height * 0.25,
                            ),
                            SizedBox(height: 50),
                            CustomButton(
                              text: "Login",
                              backgroundColour: AppColors.whiteColor,
                              textColour: AppColors.blackColor,
                              onPressed: () {
                                LoginRoute().go(context);
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Row(
                                children: [
                                  const Expanded(
                                    child: Divider(
                                      color: AppColors.greyColor,
                                      thickness: 0.5,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      'Atau',
                                      style: AppTextStyles.textStyleNormal
                                          .copyWith(
                                        color: AppColors.whiteColor.withValues(
                                          alpha: 0.7,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  const Expanded(
                                    child: Divider(
                                      color: AppColors.greyColor,
                                      thickness: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            CustomButton(
                              text: "Register",
                              backgroundColour: AppColors.buttonBlueColor,
                              textColour: AppColors.whiteColor,
                              onPressed: () async {
                                try {
                                  var isAppleReview =
                                      getIt<FirebaseRemoteConfig>()
                                          .getBool("is_review_apple");
                                  print("is review ? ${isAppleReview}");

                                  if (isAppleReview) {
                                    final extra = RegisterAkunExtra(
                                      extrackKtp: ExtrackKtpModel(),
                                      userGoogle: UserGoogleModel(),
                                    );
                                    RegisterAkunRoute($extra: extra)
                                        .push(context);
                                  } else {
                                    KycTutorialRoute(
                                      $extra: RegisterAkunExtra(),
                                    ).push(context);
                                  }
                                } catch (e) {
                                  debugPrint('Remote Config Error: $e');
                                }
                              },
                            ),
                            SizedBox(height: 10),
                            Platform.isAndroid
                                ? CustomButton(
                                    leading: Image.asset(
                                      'assets/icons/google.png',
                                      height: 25,
                                      width: 25,
                                    ),
                                    text: "Sign Up With Google",
                                    backgroundColour: AppColors.whiteColor,
                                    textColour: AppColors.blackColor,
                                    onPressed: () {
                                      context
                                          .read<RegisterCubit>()
                                          .loginWithGoogle(context);
                                    })
                                : SizedBox.shrink()
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
