part of '../view/detail_product_page.dart';

class ButtonArrow extends StatelessWidget {
  const ButtonArrow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
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
                ),
              ),
              Badges.Badge(
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
                    key: _cartKey,
                    clipBehavior: Clip.hardEdge,
                    height: 30,
                    width: 30,
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
            ],
          ),
        );
      },
    );
  }
}
