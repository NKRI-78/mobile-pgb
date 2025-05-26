part of '../view/register_change_page.dart';

class _FieldEmail extends StatelessWidget {
  const _FieldEmail();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterChangeCubit, RegisterChangeState>(
        builder: (context, state) {
      return _buildTextFormField(
        label: 'Masukan Email Anda',
        keyboardType: TextInputType.emailAddress,
        onChanged: (value) {
          var cubit = context.read<RegisterChangeCubit>();
          cubit.onEmailChanged(value);
        },
        inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
      );
    });
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
            labelStyle: AppTextStyles.textStyleNormal.copyWith(
              color: AppColors.whiteColor,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          ),
          style: AppTextStyles.textStyleNormal.copyWith(
            color: AppColors.whiteColor,
          ),
        ),
      ),
    ),
  );
}
