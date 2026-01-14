import 'package:badges/badges.dart' as Badges;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../misc/colors.dart';
import '../../../misc/theme.dart';
import '../cubit/order_cubit.dart';

class TabbarOrder extends StatelessWidget {
  const TabbarOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCubit, OrderState>(
      builder: (context, state) {
        return DefaultTabController(
          length: 7,
          initialIndex: state.tabIndex,
          child: TabBar(
            automaticIndicatorColorAdjustment: true,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            padding: EdgeInsets.zero,
            onTap: (value) {
              print("TabIndex $value");
              final cubit = context.read<OrderCubit>();
              cubit.copyState(newState: cubit.state.copyWith(tabIndex: value));

              if (value == 0) {
                cubit.getPaymentWaiting();
              } else if (value == 1) {
                cubit.getOrderUser("WAITING_CONFIRM");
              } else if (value == 2) {
                cubit.getOrderUser("ON_PROCESS");
              } else if (value == 3) {
                cubit.getOrderUser("DELIVERY");
              } else if (value == 4) {
                cubit.getOrderUser("DELIVERED");
              } else if (value == 5) {
                cubit.getOrderUser("FINISHED");
              } else if (value == 6) {
                cubit.getOrderUser("CANCEL");
              }
            },
            unselectedLabelColor: AppColors.greyColor,
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: AppColors.secondaryColor,
            indicatorColor: AppColors.secondaryColor,
            dividerColor: AppColors.greyColor,
            tabs: [
              TextWithBadge(
                title: 'Belum Bayar',
                showBadge: true,
                textBadge: state.badges?.waitingPaymentCount ?? 0,
              ),
              TextWithBadge(
                title: 'Menunggu Konfirmasi',
                showBadge: true,
                textBadge: state.badges?.waitingConfirmCount ?? 0,
              ),
              TextWithBadge(
                title: 'Diproses',
                showBadge: true,
                textBadge: state.badges?.onProcessCount ?? 0,
              ),
              TextWithBadge(
                title: 'Dikirim',
                showBadge: true,
                textBadge: state.badges?.onDeliveryCount ?? 0,
              ),
              TextWithBadge(
                title: 'Tiba di tujuan',
                showBadge: true,
                textBadge: state.badges?.onDeliveredCount ?? 0,
              ),
              TextWithBadge(
                title: 'Selesai',
                showBadge: true,
                textBadge: state.badges?.onFinishedOrderCount ?? 0,
              ),
              TextWithBadge(
                title: 'Dibatalkan',
                showBadge: false,
                textBadge: state.badges?.onCancelCount ?? 0,
              ),
            ],
          ),
        );
      },
    );
  }
}

class TextWithBadge extends StatelessWidget {
  const TextWithBadge(
      {super.key,
      required this.title,
      this.showBadge = false,
      this.textBadge = 0});

  final String title;
  final bool? showBadge;
  final int? textBadge;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Badges.Badge(
            position: Badges.BadgePosition.custom(end: -20, top: -10),
            showBadge: showBadge == false || textBadge == 0 ? false : true,
            badgeContent: Text(
              textBadge.toString(),
              style: const TextStyle(
                fontSize: fontSizeDefault,
                color: Colors.white,
              ),
            ),
            child: Text(
              title,
            ),
          ),
        ),
        const SizedBox(
          width: 5,
        ),
      ],
    );
  }
}
