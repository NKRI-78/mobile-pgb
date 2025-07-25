part of "../view/shop_page.dart";

class HeaderMart extends StatefulWidget {
  const HeaderMart({super.key});

  @override
  State<HeaderMart> createState() => _HeaderMartState();
}

class _HeaderMartState extends State<HeaderMart> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ShopBloc, ShopState>(
      listenWhen: (prev, curr) => prev.searchQuery != curr.searchQuery,
      listener: (context, state) {
        if (state.searchQuery.isEmpty) {
          _controller.clear();
        }
      },
      child: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) {
          final isLoggedIn = getIt<AppBloc>().state.user != null;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            color: AppColors.secondaryColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).padding.top + 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => GoRouter.of(context).pop(),
                      icon: Container(
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
                    Expanded(
                      child: Center(
                        child: Text("Mart",
                            style: AppTextStyles.textStyleBold.copyWith(
                              color: AppColors.whiteColor,
                            )),
                      ),
                    ),
                    IconButton(
                      onPressed: () => isLoggedIn
                          ? CartRoute().push(context)
                          : RegisterRoute().push(context),
                      icon: Badges.Badge(
                        position: Badges.BadgePosition.topEnd(),
                        showBadge: state.badgeCart == null ||
                                state.badgeCart?.totalItem == 0
                            ? false
                            : true,
                        badgeStyle:
                            Badges.BadgeStyle(padding: EdgeInsets.all(5)),
                        badgeContent: Text(
                          state.loadingNotif
                              ? '..'
                              : '${state.badgeCart?.totalItem}',
                          style: const TextStyle(
                            fontSize: fontSizeDefault,
                            color: Colors.white,
                          ),
                        ),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.greyColor.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.shopping_cart_outlined,
                            size: 22,
                            color: AppColors.whiteColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Logo + Search Bar
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/logo_transparant.png",
                      width: 60,
                      height: 60,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search, color: Colors.grey),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: _controller,
                                style: AppTextStyles.textStyleNormal.copyWith(
                                  color: AppColors.greyColor,
                                  fontSize: 12,
                                ),
                                decoration: InputDecoration(
                                  hintText: "Cari produk...",
                                  hintStyle:
                                      AppTextStyles.textStyleNormal.copyWith(
                                    color: AppColors.greyColor,
                                    fontSize: 12,
                                  ),
                                  border: InputBorder.none,
                                  isDense: true,
                                ),
                                onChanged: (query) {
                                  context
                                      .read<ShopBloc>()
                                      .add(SearchProduct(query));
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
