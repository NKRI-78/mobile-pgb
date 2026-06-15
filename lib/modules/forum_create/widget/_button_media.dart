import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../misc/colors.dart';
import '../cubit/forum_create_cubit.dart';

class ButtonMedia extends StatelessWidget {
  const ButtonMedia({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _MyCustomButton(
              backgroundColour: AppColors.secondaryColor,
              textColour: AppColors.whiteColor,
              text: 'Photo',
              icon: Icons.photo,
              onPressed: () async {
                await context.read<ForumCreateCubit>().uploadImg(context);
              },
            ),
            const SizedBox(width: 12),
            _MyCustomButton(
              backgroundColour: AppColors.secondaryColor,
              textColour: AppColors.whiteColor,
              text: 'Video',
              icon: Icons.videocam,
              onPressed: () async {
                await context.read<ForumCreateCubit>().uploadVid(context);
              },
            ),
            const SizedBox(width: 12),
            _MyCustomButton(
              backgroundColour: AppColors.secondaryColor,
              textColour: AppColors.whiteColor,
              text: 'Document',
              icon: Icons.insert_drive_file,
              onPressed: () async {
                await context.read<ForumCreateCubit>().uploadDoc(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _MyCustomButton extends StatelessWidget {
  final Color backgroundColour;
  final Color textColour;
  final String text;
  final IconData icon;
  final VoidCallback? onPressed;

  const _MyCustomButton({
    required this.backgroundColour,
    required this.textColour,
    required this.text,
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColour,
      borderRadius: BorderRadius.circular(12),
      elevation: 2,
      shadowColor: backgroundColour.withValues(alpha: 0.3),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: textColour, size: 18),
              const SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(
                  color: textColour,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
