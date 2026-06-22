import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../misc/colors.dart';
import '../../../misc/injections.dart';
import '../../../misc/text_style.dart';
import '../cubit/register_akun_cubit.dart';

class CustomTextfieldAkun extends StatelessWidget {
  const CustomTextfieldAkun({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 15),
        _FieldEmail(),
        _FieldPhone(),
        _FieldPassword(),
        _FieldConfirmPassword(),
      ],
    );
  }
}

class _FieldEmail extends StatelessWidget {
  const _FieldEmail();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterAkunCubit, RegisterAkunState>(
      builder: (context, state) {
        final isGoogleLogin = state.userGoogle?.oauthId != null;
        final email =
            isGoogleLogin ? state.userGoogle?.email ?? '' : state.email;

        return _buildTextFormField(
            label: 'Alamat Email',
            initialValue: email,
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) {
              if (!isGoogleLogin) {
                var cubit = context.read<RegisterAkunCubit>();
                cubit.copyState(newState: cubit.state.copyWith(email: value));
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email tidak boleh kosong';
              }

              if (!value.contains(
                RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)?$'),
              )) {
                return 'Format email tidak valid';
              }

              return null;
            },
            inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
            readOnly: isGoogleLogin,
            textColor:
                isGoogleLogin ? AppColors.greyColor : AppColors.whiteColor);
      },
    );
  }
}

class _FieldPhone extends StatelessWidget {
  const _FieldPhone();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterAkunCubit, RegisterAkunState>(
      builder: (context, state) {
        var isAppleReview =
            getIt<FirebaseRemoteConfig>().getBool("is_review_apple");
        print("is review ? ${isAppleReview}");

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextFormField(
              maxLength: 13,
              label: 'Nomor Handphone',
              initialValue: state.phone,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (!isAppleReview) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor handphone tidak boleh kosong';
                  }

                  if (value.length < 10) {
                    return 'Nomor handphone minimal 10 digit';
                  }

                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'Nomor handphone hanya boleh angka';
                  }
                }

                return null;
              },
              onChanged: (value) {
                var cubit = context.read<RegisterAkunCubit>();
                cubit.copyState(newState: cubit.state.copyWith(phone: value));
              },
            ),
            if (isAppleReview)
              Padding(
                padding: const EdgeInsets.only(left: 5, top: 0, bottom: 10),
                child: Text(
                  '*Opsional: Anda dapat mengisi nomor handphone atau melewati pilihan ini.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.greyColor,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _FieldPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterAkunCubit, RegisterAkunState>(
      builder: (context, state) {
        bool isObscured = state.isPasswordObscured;
        return _buildPasswordField(
          label: 'Password',
          onChanged: (value) {
            var cubit = context.read<RegisterAkunCubit>();
            cubit.copyState(newState: cubit.state.copyWith(password: value));
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Password tidak boleh kosong';
            }

            if (value.length < 8) {
              return 'Password minimal 8 karakter';
            }

            return null;
          },
          isObscured: isObscured,
        );
      },
    );
  }
}

class _FieldConfirmPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterAkunCubit, RegisterAkunState>(
      builder: (context, state) {
        bool isObscured = state.isConfirmPasswordObscured;
        return _buildPasswordField(
          label: 'Konfirmasi Password',
          onChanged: (value) {
            var cubit = context.read<RegisterAkunCubit>();
            cubit.copyState(
                newState: cubit.state.copyWith(passwordConfirm: value));
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Konfirmasi password tidak boleh kosong';
            }

            if (value != state.password) {
              return 'Password tidak cocok';
            }

            return null;
          },
          isObscured: isObscured,
        );
      },
    );
  }
}

Widget _buildTextFormField({
  required String label,
  required ValueChanged<String> onChanged,
  TextInputType keyboardType = TextInputType.text,
  String? initialValue,
  List<TextInputFormatter>? inputFormatters,
  int? maxLength,
  bool readOnly = false,
  Color? textColor,
  String? Function(String?)? validator,
}) {
  return Padding(
    padding: EdgeInsets.only(bottom: 15),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.whiteColor),
        ),
        child: TextFormField(
          cursorColor: AppColors.whiteColor,
          cursorErrorColor: AppColors.redColor,
          maxLength: maxLength,
          initialValue: initialValue,
          keyboardType: keyboardType,
          onChanged: onChanged,
          inputFormatters: inputFormatters,
          readOnly: readOnly,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: AppTextStyles.textStyleNormal.copyWith(
              fontSize: 13,
              color: AppColors.whiteColor,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            counterStyle: AppTextStyles.textStyleNormal.copyWith(
              color: AppColors.whiteColor.withValues(alpha: 0.5),
              fontSize: 10,
            ),
            errorStyle: AppTextStyles.textStyleNormal.copyWith(
              color: AppColors.redColor,
              fontSize: 10,
              height: 1.5,
              wordSpacing: 1.5,
            ),
            errorMaxLines: 2,
          ),
          style: AppTextStyles.textStyleNormal.copyWith(
            fontSize: 14,
            color: textColor ?? AppColors.whiteColor,
            fontWeight: textColor == AppColors.greyColor
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
      ),
    ),
  );
}

Widget _buildPasswordField({
  required String label,
  required ValueChanged<String> onChanged,
  required bool isObscured,
  String? Function(String?)? validator,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 15),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.whiteColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.whiteColor),
        ),
        child: BlocBuilder<RegisterAkunCubit, RegisterAkunState>(
          builder: (context, state) {
            return TextFormField(
              cursorColor: AppColors.whiteColor,
              cursorErrorColor: AppColors.whiteColor,
              obscureText: isObscured,
              onChanged: onChanged,
              validator: validator,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                labelText: label,
                labelStyle: AppTextStyles.textStyleNormal.copyWith(
                  fontSize: 13,
                  color: AppColors.whiteColor,
                ),
                border: InputBorder.none,
                errorStyle: AppTextStyles.textStyleNormal.copyWith(
                  color: AppColors.redColor,
                  fontSize: 10,
                  height: 1.5,
                  wordSpacing: 1.5,
                ),
                errorMaxLines: 2,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                suffixIcon: IconButton(
                  icon: Icon(
                    isObscured ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.whiteColor,
                  ),
                  onPressed: () {
                    if (label == 'Password') {
                      context
                          .read<RegisterAkunCubit>()
                          .togglePasswordVisibility();
                    } else {
                      context
                          .read<RegisterAkunCubit>()
                          .toggleConfirmPasswordVisibility();
                    }
                  },
                ),
              ),
              style: AppTextStyles.textStyleNormal.copyWith(
                fontSize: 14,
                color: AppColors.whiteColor,
              ),
            );
          },
        ),
      ),
    ),
  );
}
