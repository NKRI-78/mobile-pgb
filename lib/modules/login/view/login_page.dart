import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_pgb/misc/text_style.dart';
import 'package:mobile_pgb/modules/login/cubit/login_cubit.dart';
import 'package:mobile_pgb/modules/login/widget/custom_textfield_login.dart';
import 'package:mobile_pgb/widgets/button/custom_button.dart';

import '../../../misc/colors.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginCubit>(
      create: (context) => LoginCubit(),
      child: LoginView(),
    );
  }
}

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: Text(
              'Login',
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
              SafeArea(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: size.height,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/logo_transparant.png',
                            height: size.height * 0.25,
                          ),
                          SizedBox(height: 100),
                          CustomTextfieldLogin(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            spacing: 5,
                            children: [
                              Text(
                                "Klik",
                                style: TextStyle(
                                  color: AppColors.whiteColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'Intel',
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // LupaPasswordRoute().go(context);
                                  debugPrint("Lupa Password");
                                },
                                child: Text(
                                  "Disini",
                                  style: TextStyle(
                                    color: AppColors.redColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Intel',
                                  ),
                                ),
                              ),
                              Text(
                                "jika lupa Password",
                                style: TextStyle(
                                  color: AppColors.whiteColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'Intel',
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 30),
                          CustomButton(
                            text: 'Masuk',
                            backgroundColour: AppColors.buttonWhiteColor,
                            textColour: AppColors.blackColor,
                            onPressed: () {
                              context.read<LoginCubit>().submit(context);
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
