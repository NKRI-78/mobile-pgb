import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../misc/colors.dart';
import '../../../misc/text_style.dart';
import '../../../widgets/button/custom_button.dart';
import '../cubit/register_akun_cubit.dart';
import '../model/extrack_ktp_model.dart';
import '../widget/custom_textfield_akun.dart';
import '../widget/customfield_foto.dart';

class RegisterAkunPage extends StatelessWidget {
  const RegisterAkunPage({
    super.key,
    required this.extrackKtp,
  });

  final ExtrackKtpModel extrackKtp;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterAkunCubit>(
      create: (context) => RegisterAkunCubit()..init(extrackKtp),
      child: RegisterAkunView(
        extrackKtp: extrackKtp,
      ),
    );
  }
}

class RegisterAkunView extends StatelessWidget {
  const RegisterAkunView({super.key, required this.extrackKtp});

  final ExtrackKtpModel extrackKtp;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterAkunCubit, RegisterAkunState>(
      builder: (context, state) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            title: Text(
              'Registrasi Akun',
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
                  padding: EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          'Pastikan data yang anda input sudah benar',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.textStyleBold.copyWith(
                            color: AppColors.whiteColor,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 15),
                        CustomfieldFoto(),
                        CustomTextfieldAkun(),
                        SizedBox(height: 15),
                        CustomButton(
                          onPressed: () {
                            context.read<RegisterAkunCubit>().submit(context);
                          },
                          text: "Selanjutnya",
                          backgroundColour: AppColors.primaryColor,
                          textColour: AppColors.secondaryColor,
                        )
                      ],
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
