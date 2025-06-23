import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../misc/colors.dart';
import '../../../misc/register_akun_extra.dart';
import '../../../misc/text_style.dart';
import '../../../widgets/button/custom_button.dart';
import '../cubit/register_change_cubit.dart';

part '../widget/_field_email.dart';

class RegisterChangePage extends StatelessWidget {
  const RegisterChangePage({
    super.key,
    required this.email,
    required this.akunExtra,
    required this.isLogin,
  });

  final String email;
  final bool isLogin;
  final RegisterAkunExtra akunExtra;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterChangeCubit(),
      child: RegisterChangeView(
        email: email,
        isLogin: isLogin,
      ),
    );
  }
}

class RegisterChangeView extends StatelessWidget {
  const RegisterChangeView({
    super.key,
    required this.email,
    required this.isLogin,
  });

  final String email;
  final bool isLogin;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterChangeCubit, RegisterChangeState>(
      builder: (context, state) {
        final cubit = context.read<RegisterChangeCubit>();

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            title: Text(
              'Resend Email',
              style: AppTextStyles.textStyleBold.copyWith(
                color: AppColors.whiteColor,
                fontSize: 24,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.whiteColor,
              ),
              onPressed: () => Navigator.pop(context),
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
                child: Column(
                  children: [
                    // Text(
                    //   "Email Lama: $email",
                    //   style: AppTextStyles.textStyleNormal.copyWith(
                    //     color: AppColors.whiteColor,
                    //   ),
                    // ),
                    // const SizedBox(height: 16),

                    _FieldEmail(),
                    const SizedBox(height: 14),
                    CustomButton(
                      text: "Kirim",
                      backgroundColour: AppColors.whiteColor,
                      textColour: AppColors.secondaryColor,
                      onPressed: state.isLoading
                          ? null
                          : () {
                              cubit.resendEmail(
                                context: context,
                                emailOld: email,
                              );
                            },
                      leading: state.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.whiteColor,
                                ),
                              ),
                            )
                          : null,
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
