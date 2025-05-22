import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_pgb/misc/colors.dart';

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
          mainAxisAlignment: MainAxisAlignment.center,
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
            const SizedBox(width: 10),
            _MyCustomButton(
              backgroundColour: AppColors.secondaryColor,
              textColour: AppColors.whiteColor,
              text: 'Video',
              icon: Icons.videocam,
              onPressed: () async {
                await context.read<ForumCreateCubit>().uploadVid(context);
              },
            ),
            const SizedBox(width: 10),
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
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: textColour, size: 14),
              const SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(
                  color: textColour,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
