part of '../view/membernear_page.dart';

// ignore: unused_element
class _MemberNearHeader extends StatelessWidget {
  const _MemberNearHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 160,
            height: 40,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.secondaryColor,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Text("Member Near",
                textAlign: TextAlign.center,
                style: AppTextStyles.textStyleBold.copyWith(
                  color: AppColors.whiteColor,
                  fontSize: 16,
                )),
          ),
        ],
      ),
    );
  }
}
