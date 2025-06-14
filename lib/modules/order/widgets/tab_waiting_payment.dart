import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../misc/colors.dart';
import '../../../misc/date_helper.dart';
import '../../../misc/price_currency.dart';
import '../../../misc/theme.dart';
import '../../../router/builder.dart';
import '../../../widgets/image/image_card.dart';
import '../../../widgets/pages/empty_page.dart';
import '../../../widgets/pages/loading_page.dart';
import '../cubit/order_cubit.dart';

class TabWaitingPayment extends StatelessWidget {
  const TabWaitingPayment({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCubit, OrderState>(
      builder: (context, state) {
        return state.loading
            ? const CustomLoadingPage()
            : state.waitingPayment.isEmpty
                ? const EmptyPage(msg: "Belum ada transaksi")
                : ListView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    children: state.waitingPayment.reversed
                        .map((e) => InkWell(
                              onTap: () {
                                WaitingPaymentV2Route(id: e.id.toString())
                                    .push(context);
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(
                                    color: AppColors.whiteColor,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: AppColors.blackColor
                                            .withValues(alpha: 0.10))),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Tanggal Pembelian",
                                                style: TextStyle(
                                                  color: AppColors.blackColor,
                                                  fontSize: fontSizeDefault,
                                                ),
                                              ),
                                              Text(
                                                DateHelper.parseDate(
                                                    e.createdAt ?? ""),
                                                style: const TextStyle(
                                                  color: AppColors.blackColor,
                                                  fontSize: fontSizeDefault,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              const Text(
                                                "Bayar sebelum",
                                                style: TextStyle(
                                                  color: AppColors.blackColor,
                                                  fontSize: fontSizeDefault,
                                                ),
                                              ),
                                              Text(
                                                DateHelper.parseDateExpired(
                                                    e.createdAt ??
                                                        DateTime.now()
                                                            .toString(),
                                                    e.type ?? ""),
                                                style: const TextStyle(
                                                  color: AppColors.blackColor,
                                                  fontSize: fontSizeDefault,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      const Divider(
                                          thickness: 0.3,
                                          color: AppColors.blackColor),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                ImageCard(
                                                  image: e.logoUrl ?? "",
                                                  height: 50,
                                                  radius: 0,
                                                  width: 50,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      e.name ?? "",
                                                      style: const TextStyle(
                                                        color: AppColors
                                                            .blackColor,
                                                        fontSize:
                                                            fontSizeDefault,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    e.type == "VIRTUAL_ACCOUNT"
                                                        ? Text(
                                                            '${e.data?.vaNumber}',
                                                            style:
                                                                const TextStyle(
                                                              color: AppColors
                                                                  .blackColor,
                                                              fontSize:
                                                                  fontSizeDefault,
                                                            ),
                                                          )
                                                        : Container(),
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      const Text(
                                        'Total Harga',
                                        style: TextStyle(
                                          color: AppColors.blackColor,
                                          fontSize: fontSizeDefault,
                                        ),
                                      ),
                                      Text(
                                        '${Price.currency(e.totalPrice?.toDouble() ?? 0.0)}',
                                        style: const TextStyle(
                                          color: AppColors.blackColor,
                                          fontSize: fontSizeDefault,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  );
      },
    );
  }
}
