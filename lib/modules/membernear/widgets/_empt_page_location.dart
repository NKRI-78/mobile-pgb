part of '../view/membernear_page.dart';

class EmptyLocation extends StatelessWidget {
  const EmptyLocation(
      {super.key, required this.msg, this.height = 0.75, this.noImage = true});

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
                    "assets/icons/location.png",
                    height: 150,
                  )
                : const SizedBox.shrink(),
            Text(
              msg,
              textAlign: TextAlign.center,
              style: AppTextStyles.textStyleNormal
                  .copyWith(color: AppColors.blackColor),
            ),
          ],
        ),
      ),
    );
  }
}
