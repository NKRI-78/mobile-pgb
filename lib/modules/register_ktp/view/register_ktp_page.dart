import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/register_ktp_cubit.dart';
import '../widget/custom_textfield_register_ktp.dart';

import '../../../misc/colors.dart';
import '../../../misc/text_style.dart';

class RegisterKtpPage extends StatelessWidget {
  const RegisterKtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterKtpCubit()..scanKtp(),
      child: const RegisterKtpView(),
    );
  }
}

class RegisterKtpView extends StatelessWidget {
  const RegisterKtpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Registrasi KTP',
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
              child: BlocBuilder<RegisterKtpCubit, RegisterKtpState>(
                builder: (context, state) {
                  if (state.loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          'Pastikan data yang tertera sudah benar',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.textStyleNormal.copyWith(
                            color: AppColors.whiteColor,
                          ),
                        ),
                        SizedBox(height: 20),
                        CustomTextfieldRegisterKtp(),
                      ],
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
