import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../misc/colors.dart';
import '../../../misc/text_style.dart';
import '../../../widgets/button/custom_button.dart';
import '../cubit/lupa_password_cubit.dart';
import '../cubit/lupa_password_state.dart';

part '../widget/_field_email.dart';

class LupaPasswordPage extends StatelessWidget {
  const LupaPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LupaPasswordCubit>(
        create: (context) => LupaPasswordCubit(),
        child: const LupaPasswordView());
  }
}

class LupaPasswordView extends StatelessWidget {
  const LupaPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LupaPasswordCubit, LupaPasswordState>(
        builder: (context, state) {
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
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        "Masukan alamat email anda untuk\nmendapatkan kode OTP, untuk\nmereset Password",
                        style: AppTextStyles.textStyleBold.copyWith(
                          fontSize: 14,
                          color: AppColors.whiteColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 20),
                    _FieldEmail(),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        backgroundColour: AppColors.primaryColor,
                        textColour: AppColors.blackColor,
                        text: 'Kirim',
                        onPressed: () {
                          context.read<LupaPasswordCubit>().submit(context);
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
