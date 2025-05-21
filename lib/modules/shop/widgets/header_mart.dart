part of "../view/shop_page.dart";

class HeaderMart extends StatelessWidget {
  const HeaderMart({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return SliverList(
            delegate: SliverChildListDelegate([
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            color: AppColors.secondaryColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                IconButton(
                    onPressed: () {
                      GoRouter.of(context).pop();
                    },
                    icon: Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        color: AppColors.blackColor,
                        shape: BoxShape.circle
                      ),
                      child: Image.asset(
                        "assets/icons/back-icon.png",
                        color: AppColors.primaryColor,
                      ),
                    )
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          "assets/images/logo_transparant.png",
                          width: 76,
                          height: 87,
                        ),
                      ],
                    ),
                   Padding(
                     padding: const EdgeInsets.only(right: 15),
                     child: Badges.Badge(
                                       position: Badges.BadgePosition.topEnd(),
                                       showBadge: state.badgeCart == null ||
                            state.badgeCart?.totalItem == 0
                        ? false
                        : true,
                                       badgeStyle: const Badges.BadgeStyle(padding: EdgeInsets.all(4)),
                                       badgeContent: Text(
                      state.loadingNotif
                          ? '..'
                          : '${state.badgeCart?.totalItem}',
                      style: const TextStyle(
                        fontSize: fontSizeExtraSmall,
                        color: Colors.white,
                      ),
                                       ),
                                       child: Container(
                      clipBehavior: Clip.hardEdge,
                      height: 37,
                      width: 37,
                      decoration: BoxDecoration(
                        color: AppColors.blackColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.shopping_cart_outlined,
                          size: 15,
                          color: AppColors.whiteColor,
                        ),
                        onPressed: () {
                          CartRoute().push(context);
                        },
                      ),
                                       ),
                                     ),
                   ),
                  ],
                ),
              ],
            ),
          )
        ]));
      },
    );
  }
}
