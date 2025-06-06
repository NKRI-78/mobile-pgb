import 'package:flutter/material.dart';

import '../../misc/text_style.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color backgroundColour;
  final Color textColour;
  final void Function()? onPressed;
  final Widget? leading;
  final double? radius;
  final bool isLoading;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.text,
    required this.backgroundColour,
    required this.textColour,
    this.onPressed,
    this.leading,
    this.radius,
    this.isLoading = false,
    SizedBox? child,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColour,
          foregroundColor: textColour,
          elevation: 4,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? 12),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: AppTextStyles.textStyleBold.copyWith(
                fontWeight: FontWeight.w500,
                color: textColour,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
