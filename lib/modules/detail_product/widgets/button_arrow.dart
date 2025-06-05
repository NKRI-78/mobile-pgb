part of '../view/detail_product_page.dart';

class ButtonArrow extends StatelessWidget {
  const ButtonArrow({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = getIt<AppBloc>().state.user != null;
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
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.greyColor.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 20,
                    color: AppColors.whiteColor,
                  ),
                ),
              ),
              Badges.Badge(
                position: Badges.BadgePosition.topEnd(),
                showBadge:
                    state.badgeCart == null || state.badgeCart?.totalItem == 0
                        ? false
                        : true,
                badgeStyle: const Badges.BadgeStyle(padding: EdgeInsets.all(4)),
                badgeContent: Text(
                  state.loadingNotif ? '..' : '${state.badgeCart?.totalItem}',
                  style: const TextStyle(
                    fontSize: fontSizeExtraSmall,
                    color: Colors.white,
                  ),
                ),
                child: Container(
                  key: _cartKey,
                  clipBehavior: Clip.hardEdge,
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.greyColor.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.shopping_cart_outlined,
                      size: 22,
                      color: AppColors.whiteColor,
                    ),
                    onPressed: () {
                      isLoggedIn
                          ? CartRoute().push(context)
                          : RegisterRoute().push(context);
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
