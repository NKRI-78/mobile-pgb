import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../misc/colors.dart';
import '../../../repositories/shop_repository/models/category_model.dart';
import '../bloc/shop_bloc.dart';

class TabBarMart extends StatelessWidget {
  const TabBarMart({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopBloc, ShopState>(
        buildWhen: (previous, current) => previous.category != current.category,
        builder: (context, state) {
          final tabs = [
            const Tab(text: 'Semua'),
            if (state.category.isNotEmpty)
              ...state.category.map((e) => Tab(text: e.name)),
          ];
          final List<CategoryModel> categories = [
            CategoryModel(id: 0, name: 'Semua'), // <- ini index 0
            ...state.category
          ];
          return DefaultTabController(
            length: 1 + state.category.length,
            initialIndex: 0,
            child: TabBar(
              tabAlignment: TabAlignment.start,
              automaticIndicatorColorAdjustment: true,
              padding: EdgeInsets.zero,
              isScrollable: true, // Required// Other tabs color
              onTap: (index) {
                final selectedId = categories[index].id;
                context.read<ShopBloc>().add(
                      ChangeProduct(idCategory: index == 0 ? 0 : selectedId),
                    );
              },
              unselectedLabelColor: AppColors.greyColor,
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: AppColors.secondaryColor,
              indicatorColor: AppColors.greyColor,
              tabs: tabs,
            ),
          );
        });
  }
}
