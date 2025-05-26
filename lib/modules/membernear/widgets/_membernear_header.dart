part of '../view/membernear_page.dart';

// ignore: unused_element
class _MemberNearHeader extends StatelessWidget {
  const _MemberNearHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 160,
            height: 35,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.secondaryColor,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: const Text(
              "Dimans?",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20, color: AppColors.whiteColor, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
