import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../misc/colors.dart';
import '../../../misc/text_style.dart';
import '../../../widgets/button/custom_button.dart';
import '../cubit/lupa_password_change_cubit.dart';

part '../widget/custom_textfield_password.dart';

class LupaPasswordChangePage extends StatelessWidget {
  const LupaPasswordChangePage(
      {super.key, required this.email, required this.otp});

  final String email;
  final String otp;

  @override
  Widget build(BuildContext context) {
    debugPrint("otp : $otp");
    return BlocProvider<LupaPasswordChangeCubit>(
      create: (context) => LupaPasswordChangeCubit(email: email, otp: otp),
      child: LupaPasswordChangeView(),
    );
  }
}

class LupaPasswordChangeView extends StatelessWidget {
  const LupaPasswordChangeView({super.key});

  @override
  Widget build(BuildContext context) {
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
        leading: SizedBox(),
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
              padding: const EdgeInsets.only(top: 100, left: 24, right: 24),
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          "Masukkan Password baru kamu, kali ini\njangan sampai lupa yaa!",
                          style: AppTextStyles.textStyleBold.copyWith(
                            fontSize: 14,
                            color: AppColors.whiteColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 30),
                      CustomTextFieldPassword(),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              left: 24,
              right: 24,
              child: SizedBox(
                width: double.infinity,
                child: CustomButton(
                  backgroundColour: AppColors.whiteColor,
                  textColour: AppColors.blackColor,
                  text: 'Konfirmasi',
                  onPressed: () {
                    context.read<LupaPasswordChangeCubit>().submit(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
