import 'package:badges/badges.dart' as Badges;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../misc/colors.dart';
import '../../../misc/injections.dart';
import '../../../misc/text_style.dart';
import '../../../misc/theme.dart';
import '../../../router/builder.dart';
import '../../../widgets/image/image_card.dart';
import '../../../widgets/pages/empty_page.dart';
import '../../../widgets/pages/loading_page.dart';
import '../../app/bloc/app_bloc.dart';
import '../bloc/shop_bloc.dart';
import '../widgets/grid_product.dart';
import '../widgets/tab_bar_mart.dart';

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
        body: SmartRefresher(
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
            context.read<ShopBloc>().add(LoadMoreProduct());
          },
          child: CustomScrollView(
            slivers: [
              const HeaderMart(),
              BlocBuilder<ShopBloc, ShopState>(builder: (context, state) {
                return SliverAppBar(
                  backgroundColor: Colors.transparent,
                  forceMaterialTransparency: true,
                  pinned: false,
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
                          child:
                              Center(child: EmptyPage(msg: "Tidak ada produk")))
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
      );
    });
  }
}
