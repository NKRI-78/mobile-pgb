import 'package:flutter/material.dart';
import 'package:mobile_pgb/router/builder.dart';
import '../../../misc/colors.dart';
import '../../../misc/text_style.dart';
import '../../../widgets/button/custom_button.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const RegisterView();
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
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: size.height,
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
                      SizedBox(height: 80),
                      Image.asset(
                        'assets/images/logo_transparant.png',
                        height: size.height * 0.25,
                      ),
                      SizedBox(height: 80),
                      CustomButton(
                        text: "Login",
                        backgroundColour: AppColors.whiteColor,
                        textColour: AppColors.blackColor,
                        onPressed: () {
                          LoginRoute().go(context);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          children: [
                            const Expanded(
                              child: Divider(
                                color: AppColors.greyColor,
                                thickness: 0.5,
                              ),
                            ),
                            SizedBox(width: 20),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'Atau',
                                style: AppTextStyles.textStyleNormal.copyWith(
                                  color: AppColors.whiteColor.withValues(
                                    alpha: 0.7,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
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
                        text: "Registrasi",
                        backgroundColour: AppColors.buttonBlueColor,
                        textColour: AppColors.whiteColor,
                        onPressed: () {},
                      ),
                      SizedBox(height: 10),
                      CustomButton(
                        leading: Image.asset(
                          'assets/icons/google.png',
                          height: 20,
                          width: 20,
                        ),
                        text: "Sign Up With Google",
                        backgroundColour: AppColors.whiteColor,
                        textColour: AppColors.blackColor,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
