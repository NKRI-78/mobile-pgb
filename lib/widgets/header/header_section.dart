import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../misc/colors.dart';
import '../../router/builder.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection(
      {super.key,
      required this.titleHeader,
      this.isShowBack = true,
      this.showAction = false,
      this.onPressedAction,
      this.isShowCart});

  final String titleHeader;
  final bool? isShowBack;
  final bool? isShowCart;
  final bool? showAction;
  final Function()? onPressedAction;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      toolbarHeight: 60,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Text(
            titleHeader,
            style: const TextStyle(
                color: AppColors.blackColor, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      actions: [
        showAction == true
            ? IconButton(
                onPressed: onPressedAction,
                icon: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      color: AppColors.blueColor, shape: BoxShape.circle),
                  child: const Icon(
                    Icons.add,
                    color: AppColors.whiteColor,
                  ),
                ))
            : Container(),
        isShowCart == true
            ? IconButton(
                onPressed: () {
                  CartRoute().go(context);
                },
                icon: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      color: AppColors.blueColor, shape: BoxShape.circle),
                  child: const Icon(
                    Icons.shopping_cart,
                    color: AppColors.whiteColor,
                  ),
                ))
            : Container()
      ],
      leading: isShowBack == true
          ? IconButton(
              onPressed: () {
                GoRouter.of(context).pop();
              },
              icon: Image.asset(
                "assets/icons/back-icon.png",
              ))
          : Container(),
    );
  }
}
