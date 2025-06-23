import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../misc/colors.dart';
import '../../../widgets/header/header_section.dart';
import '../cubit/order_cubit.dart';
import '../widgets/tab_order.dart';
import '../widgets/tab_waiting_payment.dart';
import '../widgets/tabbar_order.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key, required this.initIndex});

  final int initIndex;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderCubit>(
      create: (context) => OrderCubit()..init(initIndex),
      child: const OrderView(),
    );
  }
}

class OrderView extends StatelessWidget {
  const OrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCubit, OrderState>(
      builder: (context, st) {
        return Scaffold(
          backgroundColor: AppColors.primaryColor,
          body: SmartRefresher(
            header: const WaterDropMaterialHeader(
              backgroundColor: AppColors.secondaryColor,
              distance: 60,
              offset: 0,
            ),
            onRefresh: () {
              final tab = context.read<OrderCubit>().state.tabIndex;
              context.read<OrderCubit>().init(tab);
            },
            controller: OrderCubit.refreshCtrl,
            child: CustomScrollView(
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                const HeaderSection(titleHeader: "Pesanan saya"),
                SliverAppBar(
                  forceMaterialTransparency: st.scrollP > 110 ? false : true,
                  backgroundColor: AppColors.whiteColor,
                  centerTitle: false,
                  primary: st.scrollP > 110 ? true : false,
                  pinned: false,
                  elevation: 0,
                  forceElevated: true,
                  automaticallyImplyLeading: false,
                  bottom: const PreferredSize(
                    preferredSize: Size(double.infinity, 0),
                    child: TabbarOrder(),
                  ),
                ),
                SliverList(
                    delegate: SliverChildListDelegate([
                  BlocBuilder<OrderCubit, OrderState>(
                    buildWhen: (previous, current) =>
                        previous.tabIndex != current.tabIndex,
                    builder: (context, state) {
                      if (state.tabIndex == 0) {
                        return const TabWaitingPayment();
                      } else {
                        return const TabOrder();
                      }
                    },
                  )
                ])),
              ],
            ),
          ),
        );
      },
    );
  }
}
