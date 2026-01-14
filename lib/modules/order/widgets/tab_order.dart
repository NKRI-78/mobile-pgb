import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../misc/colors.dart';
import '../../../misc/date_helper.dart';
import '../../../misc/price_currency.dart';
import '../../../misc/theme.dart';
import '../../../router/builder.dart';
import '../../../widgets/button/custom_button.dart';
import '../../../widgets/image/image_card.dart';
import '../../../widgets/pages/empty_page.dart';
import '../../../widgets/pages/loading_page.dart';
import '../cubit/order_cubit.dart';

class TabOrder extends StatelessWidget {
  const TabOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCubit, OrderState>(
      builder: (context, state) {
        return state.loading
            ? const CustomLoadingPage()
            : state.order.isEmpty
                ? const EmptyPage(msg: "Belum ada transaksi")
                : ListView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    children: state.order.map((e) {
                      print(e.status);
                      return InkWell(
                        onTap: () {
                          DetailOrderRoute(
                                  idOrder: e.id ?? 0, initIndex: state.tabIndex)
                              .go(context);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  color: AppColors.blackColor
                                      .withValues(alpha: 0.2))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text("Tanggal Pembelian"),
                                        Text(
                                          DateHelper.formatFullDate(
                                              e.createdAt ?? ""),
                                        )
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          color: e.status == "CANCEL_SYSTEM"
                                              ? AppColors.secondaryColor
                                              : AppColors.blueColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          border: Border.fromBorderSide(
                                              BorderSide(
                                                  color: AppColors.whiteColor,
                                                  width: 1,
                                                  strokeAlign: 1))),
                                      child: Text(
                                        e.status == "ON_PROCESS"
                                            ? "Diproses"
                                            : e.status == "DELIVERY"
                                                ? "Dikirim"
                                                : e.status == "DELIVERED"
                                                    ? "Tiba di tujuan"
                                                    : e.status == "FINISHED"
                                                        ? "Selesai"
                                                        : e.status ==
                                                                "DELIVERED"
                                                            ? "Tiba di tujuan"
                                                            : e.status ==
                                                                    "CANCEL"
                                                                ? "Dibatalkan"
                                                                : e.status ==
                                                                        "CANCEL_SYSTEM"
                                                                    ? "Dibatalkan Dari Sistem"
                                                                    : "Menunggu Konfirmasi",
                                        style: const TextStyle(
                                            color: AppColors.whiteColor,
                                            fontSize: fontSizeSmall),
                                      ),
                                    )
                                  ],
                                ),
                                Divider(
                                    thickness: 0.3,
                                    color: AppColors.blackColor
                                        .withValues(alpha: 0.10)),
                                Column(
                                  children: e.items!
                                      .map((e) => Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 10,
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: ImageCard(
                                                    image: (e.product?.pictures
                                                                ?.isEmpty ??
                                                            false)
                                                        ? ""
                                                        : e.product?.pictures
                                                                ?.first.link ??
                                                            "",
                                                    height: 50,
                                                    radius: 0,
                                                    width: 50,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  flex: 5,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        e.product?.name ?? "",
                                                        maxLines: 2,
                                                        style: const TextStyle(
                                                          color: AppColors
                                                              .blackColor,
                                                          fontSize:
                                                              fontSizeDefault,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        '${e.quantity} Barang',
                                                        style: const TextStyle(
                                                          color: AppColors
                                                              .blackColor,
                                                          fontSize:
                                                              fontSizeDefault,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ))
                                      .toList(),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Total Harga',
                                          style: TextStyle(
                                            color: AppColors.blackColor,
                                            fontSize: fontSizeDefault,
                                          ),
                                        ),
                                        Text(
                                          '${Price.currency(e.payment?.totalPrice?.toDouble() ?? 0.0)}',
                                          style: const TextStyle(
                                            color: AppColors.blackColor,
                                            fontSize: fontSizeDefault,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    e.needReview == true
                                        ? SizedBox(
                                            width: 150,
                                            height: 40,
                                            child: CustomButton(
                                                onPressed: () {
                                                  NeedRiviewRoute().go(context);
                                                },
                                                radius: 8,
                                                backgroundColour:
                                                    AppColors.buttonBlueColor,
                                                textColour:
                                                    AppColors.whiteColor,
                                                text: "Beri Penilaian"),
                                          )
                                        : Container()
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
      },
    );
  }
}
