import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../misc/colors.dart';
import '../../../misc/text_style.dart';
import '../cubit/register_akun_cubit.dart';

class CustomTextfieldAkun extends StatelessWidget {
  const CustomTextfieldAkun({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
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
            inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
            readOnly: isGoogleLogin,
            textColor: isGoogleLogin ? Colors.red : AppColors.whiteColor);
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
        return _buildTextFormField(
          maxLength: 13,
          label: 'Nomor Handphone',
          initialValue: state.phone,
          keyboardType: TextInputType.phone,
          onChanged: (value) {
            var cubit = context.read<RegisterAkunCubit>();
            cubit.copyState(newState: cubit.state.copyWith(phone: value));
          },
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
}) {
  return Padding(
    padding: EdgeInsets.only(bottom: 12),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.whiteColor),
        ),
        child: TextFormField(
          maxLength: maxLength,
          initialValue: initialValue,
          keyboardType: keyboardType,
          onChanged: onChanged,
          inputFormatters: inputFormatters,
          readOnly: readOnly,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: AppTextStyles.textStyleNormal.copyWith(
              color: AppColors.whiteColor,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            counterStyle: AppTextStyles.textStyleNormal.copyWith(
              color: AppColors.whiteColor.withValues(alpha: 0.5),
              fontSize: 10,
            ),
          ),
          style: AppTextStyles.textStyleNormal.copyWith(
            color: textColor ?? AppColors.whiteColor,
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
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
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
              obscureText: isObscured,
              onChanged: onChanged,
              decoration: InputDecoration(
                labelText: label,
                labelStyle: AppTextStyles.textStyleNormal.copyWith(
                  color: AppColors.whiteColor,
                ),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                suffixIcon: IconButton(
                  icon: Icon(
                    isObscured ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.whiteColor,
                  ),
                  onPressed: () {
                    // Ensure context is available and update visibility through Cubit
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
                color: AppColors.whiteColor,
              ),
            );
          },
        ),
      ),
    ),
  );
}
