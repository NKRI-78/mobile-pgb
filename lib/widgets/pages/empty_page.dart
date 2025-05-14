import 'package:flutter/cupertino.dart';
import 'package:mobile_pgb/misc/theme.dart';

import '../../misc/colors.dart';
import '../../misc/text_style.dart';

class EmptyPage extends StatelessWidget {
  const EmptyPage(
      {super.key, required this.msg, this.height = .75, this.noImage = true});

  final String msg;
  final double? height;
  final bool? noImage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * height!,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            noImage!
                ? Image.asset(
                    imageDefaultData,
                    height: 150,
                  )
                : const SizedBox.shrink(),
            Text(
              msg,
              style: AppTextStyles.textStyleNormal
                  .copyWith(color: AppColors.blackColor),
            ),
          ],
        ),
      ),
    );
  }
}
