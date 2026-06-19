import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../app/models/user_google_model.dart';

import '../../../misc/colors.dart';
import '../../../misc/text_style.dart';
import '../../../widgets/button/custom_button.dart';
import '../../../widgets/pages/loading_page.dart';
import '../cubit/register_ktp_cubit.dart';
import '../widget/custom_textfield_register_ktp.dart';
import 'ktp_camera_capture_page.dart';

class RegisterKtpPage extends StatelessWidget {
  const RegisterKtpPage({super.key, this.userGoogle});
  final UserGoogleModel? userGoogle;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterKtpCubit>(
      create: (_) => RegisterKtpCubit()..init(userGoogle: userGoogle),
      child: RegisterKtpView(userGoogle: userGoogle),
    );
  }
}

class RegisterKtpView extends StatefulWidget {
  const RegisterKtpView({super.key, this.userGoogle});

  final UserGoogleModel? userGoogle;

  @override
  State<RegisterKtpView> createState() => _RegisterKtpViewState();
}

class _RegisterKtpViewState extends State<RegisterKtpView> {
  bool _openingCamera = false;
  bool _didAutoOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_didAutoOpen) {
        _didAutoOpen = true;
        _openCameraCapture();
      }
    });
  }

  Future<void> _openCameraCapture() async {
    if (_openingCamera) return;
    _openingCamera = true;
    final cubit = context.read<RegisterKtpCubit>();
    cubit.clearValidationMessage();

    final imagePath = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) => const KtpCameraCapturePage(),
      ),
    );

    _openingCamera = false;
    if (!mounted || imagePath == null || imagePath.isEmpty) {
      return;
    }

    await cubit.processCapturedKtp(imagePath);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterKtpCubit, RegisterKtpState>(
      builder: (context, state) {
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
                GoogleSignIn().signOut();
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
                        return Center(
                          child: CustomLoadingPage(
                            color: AppColors.primaryColor,
                          ),
                        );
                      }

                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            if (state.error != null) ...[
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.redColor.withValues(alpha: 0.9),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  state.error!,
                                  style: AppTextStyles.textStyleNormal.copyWith(
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],
                            if (state.validationMessage != null) ...[
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.redColor.withValues(alpha: 0.9),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  state.validationMessage!,
                                  style: AppTextStyles.textStyleNormal.copyWith(
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],
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
                                    fit: BoxFit.fitWidth,
                                  )),
                              const SizedBox(height: 12),
                            ],
                            OutlinedButton.icon(
                              onPressed: _openCameraCapture,
                              icon: const Icon(Icons.refresh,
                                  color: Colors.white),
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
      },
    );
  }
}
