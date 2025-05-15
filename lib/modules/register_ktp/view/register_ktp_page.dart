import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../misc/colors.dart';
import '../../../misc/text_style.dart';
import '../../../widgets/button/custom_button.dart';
import '../cubit/register_ktp_cubit.dart';
import '../widget/custom_textfield_register_ktp.dart';

class RegisterKtpPage extends StatelessWidget {
  const RegisterKtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterKtpCubit>(
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
                        if (state.imagePaths.isNotEmpty) ...[
                          Text(
                            'Hasil Scan KTP',
                            style: AppTextStyles.textStyleBold.copyWith(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Card(
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Image.file(
                              File(state.imagePaths.first),
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton.icon(
                            onPressed: () {
                              context.read<RegisterKtpCubit>().scanKtp();
                            },
                            icon:
                                const Icon(Icons.refresh, color: Colors.white),
                            label: Text(
                              'Pindai Ulang',
                              style: AppTextStyles.textStyleNormal.copyWith(
                                color: AppColors.whiteColor,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.white),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                        Text(
                          'Pastikan data yang tertera sudah benar',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.textStyleBold.copyWith(
                            color: AppColors.whiteColor,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 20),
                        CustomTextfieldRegisterKtp(),
                        CustomButton(
                          onPressed: () {
                            context
                                .read<RegisterKtpCubit>()
                                .checkNikExistence(context);
                          },
                          text: "Selanjutnya",
                          backgroundColour: AppColors.primaryColor,
                          textColour: AppColors.secondaryColor,
                        )
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
