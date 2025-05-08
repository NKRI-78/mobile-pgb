import 'package:flutter/material.dart';
import 'package:mobile_pgb/misc/colors.dart';
import 'package:mobile_pgb/misc/text_style.dart';
import 'package:mobile_pgb/widgets/button/custom_button.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RegisterView();
  }
}

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/bg.png',
            fit: BoxFit.cover,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Selamat Datang di',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 50),
                  Image.asset(
                    'assets/images/logo_transparant.png',
                    height: 200,
                  ),
                  SizedBox(height: 50),
                  CustomButton(
                    text: "Login",
                    backgroundColour: AppColors.whiteColor,
                    textColour: AppColors.blackColor,
                    onPressed: () {},
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: AppColors.greyColor,
                            thickness: 0.5,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('Atau',
                              style: AppTextStyles.textStyleNormal.copyWith(
                                color: AppColors.greyColor,
                              )),
                        ),
                        Expanded(
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
        ],
      ),
    );
  }
}
