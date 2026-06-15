part of '../view/forum_create_page.dart';

class InputDescription extends StatelessWidget {
  const InputDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForumCreateCubit, ForumCreateState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(1000),
              ],
              textCapitalization: TextCapitalization.sentences,
              minLines: 5,
              maxLines: null,
              style: AppTextStyles.textStyleNormal.copyWith(height: 1.5),
              onChanged: (value) {
                final ct = context.read<ForumCreateCubit>();
                ct.copyState(newState: ct.state.copyWith(description: value));
              },
              cursorColor: AppColors.secondaryColor,
              decoration: InputDecoration(
                hintText: "Apa yang kamu pikirkan...",
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 18.0),
                isDense: true,
                fillColor: Colors.white,
                filled: true,
                hintStyle: TextStyle(
                  color: Color(0xFF9CA3AF),
                  fontSize: 15,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.secondaryColor,
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFE5E7EB),
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
