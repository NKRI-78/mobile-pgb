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
          disabledBackgroundColor: backgroundColour,
          disabledForegroundColor: textColour,
          elevation: 4,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? 12),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLoading) ...[
              SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(textColour),
                ),
              ),
              const SizedBox(width: 12),
            ] else if (leading != null) ...[
              leading!,
              const SizedBox(width: 8),
            ] else if (icon != null) ...[
              Icon(
                icon,
                color: textColour,
                size: 20,
              ),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                isLoading ? 'Mohon Tunggu...' : text,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: AppTextStyles.textStyleBold.copyWith(
                  color: textColour,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
