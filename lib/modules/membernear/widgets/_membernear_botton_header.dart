part of '../view/membernear_page.dart';

// ignore: unused_element
class _MemberNearBottonHeader extends StatelessWidget {
  const _MemberNearBottonHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
              onPressed: () {
                GoRouter.of(context).pop();
              },
              icon: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.secondaryColor, 
                  shape: BoxShape.circle
                ),
                child: Icon(
                Icons.arrow_back_ios_new,
                size: 20,
                color: AppColors.whiteColor,
              ),
              )),
        ],
      ),
    );
  }
}
