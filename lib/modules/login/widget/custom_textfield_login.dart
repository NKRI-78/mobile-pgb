import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../misc/colors.dart';
import '../cubit/login_cubit.dart';

class CustomTextfieldLogin extends StatelessWidget {
  const CustomTextfieldLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _FieldEmail(),
        _FieldPassword(),
      ],
    );
  }
}

class _FieldEmail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return _buildTextFormField(
          label: 'Email',
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) {
            var cubit = context.read<LoginCubit>();
            cubit.copyState(newState: cubit.state.copyWith(email: value));
          },
          inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
        );
      },
    );
  }
}

class _FieldPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        bool isObscured = state.isPasswordObscured;
        return _buildPasswordField(
          label: 'Password',
          onChanged: (value) {
            var cubit = context.read<LoginCubit>();
            cubit.copyState(newState: cubit.state.copyWith(password: value));
          },
          isObscured: isObscured,
        );
      },
    );
  }
}

Widget _buildTextFormField({
  required String label,
  TextInputType keyboardType = TextInputType.text,
  bool obscureText = false,
  int maxLines = 1,
  required ValueChanged<String> onChanged,
  List<TextInputFormatter>? inputFormatters,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.whiteColor),
        ),
        child: TextFormField(
          maxLines: maxLines,
          keyboardType: keyboardType,
          obscureText: obscureText,
          onChanged: onChanged,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: AppColors.buttonWhiteColor),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          ),
          style: TextStyle(color: AppColors.whiteColor),
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
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.whiteColor),
        ),
        child: BlocBuilder<LoginCubit, LoginState>(
          builder: (context, state) {
            return TextFormField(
              obscureText: isObscured,
              onChanged: onChanged,
              decoration: InputDecoration(
                labelText: label,
                labelStyle: TextStyle(color: AppColors.buttonWhiteColor),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                suffixIcon: label == 'Password'
                    ? IconButton(
                        icon: Icon(
                          isObscured ? Icons.visibility_off : Icons.visibility,
                          color: AppColors.buttonWhiteColor,
                        ),
                        onPressed: () {
                          context.read<LoginCubit>().togglePasswordVisibility();
                        },
                      )
                    : null,
              ),
              style: TextStyle(color: AppColors.whiteColor),
            );
          },
        ),
      ),
    ),
  );
}
