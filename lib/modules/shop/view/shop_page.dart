import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../misc/colors.dart';
import '../../../misc/text_style.dart';
import '../../../misc/theme.dart';
import '../../app/bloc/app_bloc.dart';
import '../bloc/shop_bloc.dart';
import '../widgets/grid_product.dart';
import '../widgets/tab_bar_mart.dart';
import '../../../router/builder.dart';
import '../../../widgets/image/image_card.dart';
import '../../../widgets/pages/empty_page.dart';
import '../../../widgets/pages/loading_page.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:badges/badges.dart' as Badges;

part '../widgets/category_list.dart';
part "../widgets/header_mart.dart";

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ShopBloc>(
        create: (context) => ShopBloc()..add(ShopInitialData()),
        child: const ShopView());
  }
}

class ShopView extends StatelessWidget {
  const ShopView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopBloc, ShopState>(builder: (context, state) {
      return Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification.metrics.axis == Axis.vertical) {
              context.read<ShopBloc>().add(
                    CopyState(
                      newState: context.read<ShopBloc>().state.copyWith(
                            scrollP: notification.metrics.pixels,
                          ),
                    ),
                  );
            }
            return true; // pastikan return true jika ingin terus menerima notifikasi scroll
          },
          child: SmartRefresher(
            header: const WaterDropMaterialHeader(
              backgroundColor: AppColors.buttonBlueColor,
              distance: 60,
              offset: 0,
            ),
            controller: ShopBloc.refreshCtrl,
            onRefresh: () {
              final idCategory = context.read<ShopBloc>().state.idCategory;
              context
                  .read<ShopBloc>()
                  .add(RefreshProduct(idCategory: idCategory));
            },
            enablePullUp: (state.pagination?.currentPage ?? 0) <
                (state.pagination?.totalPages ?? 1),
            enablePullDown: true,
            onLoading: () async {
              print("Scroll");
              print("Pagination Next : ${state.nexPageProduct}");
              context.read<ShopBloc>().add(LoadMoreProduct());
            },
            child: CustomScrollView(
              slivers: [
                const HeaderMart(),
                BlocBuilder<ShopBloc, ShopState>(builder: (context, state) {
                  return SliverAppBar(
                    backgroundColor:
                        state.scrollP > 160 ? Colors.black : Colors.transparent,
                    forceMaterialTransparency: state.scrollP <= 160,
                    pinned: true,
                    elevation: 0,
                    primary: false,
                    automaticallyImplyLeading: false,
                    bottom: const PreferredSize(
                      preferredSize: Size(double.infinity, 0),
                      child: TabBarMart(),
                    ),
                  );
                }),
                state.loading
                    ? const SliverFillRemaining(
                        child: Center(child: CustomLoadingPage()),
                      )
                    : state.product.isEmpty
                        ? const SliverFillRemaining(
                            child: Center(
                                child: EmptyPage(msg: "Tidak ada produk")))
                        : SliverPadding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            sliver: SliverGrid.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 5.0,
                                crossAxisSpacing: 20.0,
                                mainAxisExtent: 270.0,
                              ),
                              itemCount: state.product.length,
                              itemBuilder: (context, index) {
                                final data = state.product[index];
                                return InkWell(
                                  onTap: () {
                                    DetailProductRoute(
                                            idProduct: data.id.toString())
                                        .go(context);
                                  },
                                  child: GridProduct(data: data),
                                );
                              },
                            ),
                          )
              ],
            ),
          ),
        ),
      );
    });
  }
}
