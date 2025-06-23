import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../misc/colors.dart';
import '../../../misc/date_helper.dart';
import '../../../misc/modal.dart';
import '../../../misc/price_currency.dart';
import '../../../misc/snackbar.dart';
import '../../../misc/theme.dart';
import '../cubit/detail_order_cubit.dart';
import '../widgets/top_up.dart';
import '../../../router/builder.dart';
import '../../../widgets/button/custom_button.dart';
import '../../../widgets/header/header_section.dart';
import '../../../widgets/image/image_avatar.dart';
import '../../../widgets/image/image_card.dart';
import '../../../widgets/pages/empty_page.dart';
import '../../../widgets/pages/loading_page.dart';

class DetailOrderPage extends StatelessWidget {
  const DetailOrderPage(
      {super.key, required this.idOrder, required this.initIndex});

  final int idOrder;
  final int initIndex;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DetailOrderCubit>(
      create: (context) =>
          DetailOrderCubit()..fetchDetailOrder(idOrder.toString(), initIndex),
      child: const DetailOrderView(),
    );
  }
}

class DetailOrderView extends StatelessWidget {
  const DetailOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailOrderCubit, DetailOrderState>(
      builder: (context, state) {
        final shippingAddress = state.detailOrder?.data?.shippingAddress;
        return Scaffold(
          backgroundColor: AppColors.primaryColor,
          body: RefreshIndicator(
            onRefresh: () {
              return context
                  .read<DetailOrderCubit>()
                  .fetchDetailOrder(state.idOrder.toString(), state.initIndex);
            },
            child: CustomScrollView(
              slivers: [
                const HeaderSection(titleHeader: "Detail Pesanan"),
                state.loading
                    ? const SliverFillRemaining(
                        child: Center(child: CustomLoadingPage()),
                      )
                    : state.detailOrder == null
                        ? const SliverFillRemaining(
                            child: Center(
                                child: EmptyPage(msg: "Tidak ada pesanan")))
                        : SliverPadding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            sliver: SliverList(
                                delegate: SliverChildListDelegate([
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                decoration: BoxDecoration(
                                    color: AppColors.whiteColor,
                                    border: Border.all(
                                        color: AppColors.blackColor
                                            .withValues(alpha: 0.2))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      state.detailOrder?.status == "ON_PROCESS"
                                          ? "Diproses"
                                          : state.detailOrder?.status ==
                                                  "DELIVERY"
                                              ? "Dikirim"
                                              : state.detailOrder?.status ==
                                                      "FINISHED"
                                                  ? "Selesai"
                                                  : state.detailOrder?.status ==
                                                          "DELIVERED"
                                                      ? "Tiba di tujuan"
                                                      : state.detailOrder
                                                                  ?.status ==
                                                              "CANCEL"
                                                          ? "Dibatalkan"
                                                          : state.detailOrder
                                                                      ?.status ==
                                                                  "CANCEL_SYSTEM"
                                                              ? "Dibatalkan Dari Sistem"
                                                              : "Menunggu Konfirmasi",
                                      style: const TextStyle(
                                          color: AppColors.blackColor,
                                          fontSize: fontSizeDefault,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Divider(
                                      thickness: .3,
                                      color: AppColors.blackColor,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    state.detailOrder
                                                            ?.orderNumber ??
                                                        "",
                                                    style: const TextStyle(
                                                        fontSize: fontSizeSmall,
                                                        color: AppColors
                                                            .blackColor),
                                                  ),
                                                  InkWell(
                                                    onTap: () async {
                                                      try {
                                                        await Clipboard.setData(
                                                            ClipboardData(
                                                                text: state
                                                                        .detailOrder
                                                                        ?.orderNumber ??
                                                                    ""));
                                                        if (context.mounted) {
                                                          ShowSnackbar.snackbar(
                                                              context,
                                                              "Berhasil menyalin nomor Invoice",
                                                              isSuccess: true);
                                                        }
                                                      } catch (e) {
                                                        ///
                                                      }
                                                    },
                                                    child: const Icon(
                                                      Icons.copy,
                                                      size: fontSizeSmall,
                                                      color:
                                                          AppColors.blueColor,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              const Text(
                                                'Tanggal Pembelian',
                                                style: TextStyle(
                                                  color: AppColors.blackColor,
                                                  fontSize: fontSizeSmall,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  WebViewRoute(
                                                          url:
                                                              "https://atj-ecommerce.langitdigital78.com/api/v1/order/invoice/${state.detailOrder?.orderNumber?.replaceAll("/", "%2F") ?? ""}",
                                                          title: "PGB-MOBILE")
                                                      .push(context);
                                                },
                                                child: const Text(
                                                  "Lihat Invoice",
                                                  style: TextStyle(
                                                    color: AppColors.blueColor,
                                                    fontSize: fontSizeSmall,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                DateHelper.formatFullDate(state
                                                        .detailOrder
                                                        ?.createdAt ??
                                                    DateTime.now().toString()),
                                                style: const TextStyle(
                                                  color: AppColors.blackColor,
                                                  fontSize: fontSizeSmall,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                decoration: BoxDecoration(
                                    color: AppColors.whiteColor,
                                    border: Border.all(
                                        color: AppColors.blackColor
                                            .withValues(alpha: 0.2))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Informasi Produk',
                                            style: TextStyle(
                                                color: AppColors.blackColor,
                                                fontSize: fontSizeDefault,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(
                                      thickness: .7,
                                      color: AppColors.blackColor,
                                    ),
                                    state.detailOrder?.type == "TOPUP"
                                        ? Container()
                                        : Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: ImageAvatar(
                                                    image: state
                                                            .detailOrder
                                                            ?.store
                                                            ?.linkPhoto ??
                                                        "",
                                                    radius: 15,
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 5,
                                                  child: Text(
                                                    state.detailOrder?.store
                                                            ?.name ??
                                                        "",
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        color: AppColors
                                                            .blackColor,
                                                        fontSize:
                                                            fontSizeDefault,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                    state.detailOrder?.type == "TOPUP"
                                        ? Container()
                                        : Column(
                                            children: state.detailOrder?.items
                                                    ?.map((e) => Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 10),
                                                          child: Row(
                                                            children: [
                                                              ImageCard(
                                                                image: (e
                                                                            .product
                                                                            ?.pictures
                                                                            ?.isEmpty ??
                                                                        false)
                                                                    ? ""
                                                                    : e
                                                                            .product
                                                                            ?.pictures
                                                                            ?.first
                                                                            .link ??
                                                                        "",
                                                                height: 50,
                                                                radius: 0,
                                                                width: 50,
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              Expanded(
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      e.product
                                                                              ?.name ??
                                                                          "",
                                                                      maxLines:
                                                                          2,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style:
                                                                          const TextStyle(
                                                                        color: AppColors
                                                                            .blackColor,
                                                                        fontSize:
                                                                            fontSizeDefault,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      '${e.quantity} x  ${Price.currency(e.price?.toDouble() ?? 0.0)}',
                                                                      style:
                                                                          const TextStyle(
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
                                                    .toList() ??
                                                [],
                                          ),
                                    state.detailOrder?.type == "TOPUP"
                                        ? Container()
                                        : const Divider(
                                            thickness: .3,
                                            color: AppColors.blackColor,
                                          ),
                                    state.detailOrder?.type == "TOPUP"
                                        ? Container()
                                        : const Text(
                                            'Total Harga',
                                            style: TextStyle(
                                              color: AppColors.blackColor,
                                              fontSize: fontSizeDefault,
                                            ),
                                          ),
                                    state.detailOrder?.type == "TOPUP"
                                        ? TopUpSection(
                                            priceTopUp: state.detailOrder?.price
                                                    ?.toDouble() ??
                                                0.0,
                                            feeBank: state
                                                    .detailOrder?.payment?.fee
                                                    ?.toDouble() ??
                                                0.0,
                                          )
                                        : Text(
                                            '${Price.currency(state.detailOrder?.price?.toDouble() ?? 0.0)}',
                                            style: const TextStyle(
                                              color: AppColors.blackColor,
                                              fontSize: fontSizeDefault,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                              state.detailOrder?.type == "TOPUP"
                                  ? Container()
                                  : Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 10),
                                      decoration: BoxDecoration(
                                          color: AppColors.whiteColor,
                                          border: Border.all(
                                              color: AppColors.blackColor
                                                  .withValues(alpha: 0.2))),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Alamat Pengiriman',
                                                style: TextStyle(
                                                    color: AppColors.blackColor,
                                                    fontSize: fontSizeDefault,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              state.detailOrder?.status !=
                                                          "ON_PROCESS" &&
                                                      state.detailOrder
                                                              ?.status !=
                                                          "CANCEL_SYSTEM" &&
                                                      state.detailOrder
                                                              ?.status !=
                                                          "CANCEL" &&
                                                      state.detailOrder
                                                              ?.status !=
                                                          null
                                                  ? InkWell(
                                                      onTap: () {
                                                        state.detailOrder?.data
                                                          ?.shipping?['version'] == "3.0" ? 
                                                          TrackingBitshipRoute(noTracking: state
                                                              .detailOrder
                                                              ?.data
                                                              ?.noTracking ??
                                                          "", store: state
                                                              .detailOrder
                                                              ?.store
                                                              ?.name ??
                                                          "", initIndex: state
                                                          .initIndex, idOrder: state
                                                          .idOrder).go(context) :
                                                          TrackingRoute(
                                                            noTracking: state
                                                                    .detailOrder
                                                                    ?.data
                                                                    ?.noTracking ??
                                                                "",
                                                            store: state
                                                                    .detailOrder
                                                                    ?.store
                                                                    ?.name ??
                                                                "",
                                                            initIndex: state
                                                                .initIndex,
                                                            idOrder: state
                                                                .idOrder)
                                                        .go(context);
                                                      },
                                                      child: const Text(
                                                        'Lacak Pengiriman',
                                                        style: TextStyle(
                                                            color: AppColors
                                                                .blueColor,
                                                            fontSize:
                                                                fontSizeDefault,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    )
                                                  : Container(),
                                            ],
                                          ),
                                          const Divider(
                                            thickness: .3,
                                            color: AppColors.blackColor,
                                          ),
                                          state.detailOrder?.status !=
                                                      "ON_PROCESS" &&
                                                  state.detailOrder?.status !=
                                                      "CANCEL_SYSTEM" &&
                                                  state.detailOrder?.status !=
                                                      "CANCEL" &&
                                                  state.detailOrder?.status !=
                                                      null
                                              ? Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 5),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                        "Kurir",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: AppColors
                                                              .blackColor,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        state.detailOrder?.data
                                                          ?.shipping?['courier_name'] != null ? '${state.detailOrder?.data
                                                          ?.shipping?['courier_name']
                                                          ?.toUpperCase()} - ${state.detailOrder?.data
                                                          ?.shipping?['courier_service_name']
                                                          ?.toUpperCase()}' : '${state.detailOrder?.data
                                                          ?.shipping?['code']?.toUpperCase()} ${state.detailOrder?.data
                                                          ?.shipping?['service']?.toUpperCase()}',
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            color: AppColors
                                                                .blackColor),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : Container(),
                                          state.detailOrder?.status !=
                                                      "ON_PROCESS" &&
                                                  state.detailOrder?.status !=
                                                      "CANCEL_SYSTEM" &&
                                                  state.detailOrder?.status !=
                                                      "CANCEL" &&
                                                  state.detailOrder?.status !=
                                                      null
                                              ? Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 5),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                        "No Resi",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: AppColors
                                                              .blackColor,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            state
                                                                    .detailOrder
                                                                    ?.data
                                                                    ?.noTracking ??
                                                                "",
                                                            style: const TextStyle(
                                                                fontSize: 14,
                                                                color: AppColors
                                                                    .blackColor),
                                                          ),
                                                          const SizedBox(
                                                            width: 6,
                                                          ),
                                                          InkWell(
                                                            onTap: () async {
                                                              try {
                                                                await Clipboard.setData(ClipboardData(
                                                                    text: state
                                                                            .detailOrder
                                                                            ?.data
                                                                            ?.noTracking ??
                                                                        ""));
                                                                if (context
                                                                    .mounted) {
                                                                  ShowSnackbar.snackbar(
                                                                      context,
                                                                      "Berhasil menyalin nomor resi",
                                                                      isSuccess:
                                                                          true);
                                                                }
                                                              } catch (e) {
                                                                ///
                                                              }
                                                            },
                                                            child: const Icon(
                                                              Icons.copy,
                                                              size: 15,
                                                              color: AppColors
                                                                  .blueColor,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : Container(),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    "Alamat Penerima",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          AppColors.blackColor,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        '${shippingAddress?.name} | ${shippingAddress?.label}',
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Text(
                                                        '${shippingAddress?.address?.detailAddress}',
                                                        textAlign:
                                                            TextAlign.end,
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Text(
                                                        '${shippingAddress?.address?.province} ${shippingAddress?.address?.city} ${shippingAddress?.address?.district} ${shippingAddress?.address?.postalCode}',
                                                        textAlign:
                                                            TextAlign.end,
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )),
                              Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  decoration: BoxDecoration(
                                      color: AppColors.whiteColor,
                                      border: Border.all(
                                          color: AppColors.blackColor
                                              .withValues(alpha: 0.2))),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Rincian Pembayaran",
                                        style: TextStyle(
                                            color: AppColors.blackColor,
                                            fontSize: fontSizeDefault,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Divider(
                                        thickness: .3,
                                        color: AppColors.blackColor,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Metode Pembayaran",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.blackColor,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              state.detailOrder?.payment
                                                      ?.name ??
                                                  "",
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Harga Produk",
                                              style: TextStyle(
                                                fontSize: fontSizeDefault,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.blackColor,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              Price.currency(state
                                                      .detailOrder?.price
                                                      ?.toDouble() ??
                                                  0.0),
                                              style: const TextStyle(
                                                fontSize: fontSizeDefault,
                                                color: AppColors.blackColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      state.detailOrder?.type == "TOPUP"
                                          ? Container()
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    "Biaya Ongkir",
                                                    style: TextStyle(
                                                      fontSize: fontSizeDefault,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          AppColors.blackColor,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    Price.currency(state
                                                            .detailOrder
                                                            ?.otherPrice
                                                            ?.toDouble() ??
                                                        0),
                                                    style: const TextStyle(
                                                      fontSize: fontSizeDefault,
                                                      color:
                                                          AppColors.blackColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Biaya Admin",
                                              style: TextStyle(
                                                fontSize: fontSizeDefault,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.blackColor,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '${(state.detailOrder?.payment?.fee?.toDouble() ?? 0.0) == 0 ? "Gratis" : Price.currency((state.detailOrder?.payment?.fee?.toDouble() ?? 0.0))}',
                                              style: const TextStyle(
                                                fontSize: fontSizeDefault,
                                                color: AppColors.blackColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Divider(
                                        thickness: .5,
                                        color: AppColors.blackColor,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Total Bayar",
                                              style: TextStyle(
                                                fontSize: fontSizeDefault,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.blackColor,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              Price.currency((state.detailOrder
                                                          ?.totalPrice
                                                          ?.toDouble() ??
                                                      0.0) +
                                                  (state.detailOrder?.payment
                                                          ?.fee
                                                          ?.toDouble() ??
                                                      0.0)),
                                              style: const TextStyle(
                                                fontSize: fontSizeDefault,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.blackColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                              state.detailOrder?.status == "DELIVERED"
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20),
                                      child: CustomButton(
                                          onPressed: () {
                                            GeneralModal.showConfirmModal(
                                                msg: "Apakah anda yakin ?",
                                                context: context,
                                                onPressed: () {
                                                  context
                                                      .read<DetailOrderCubit>()
                                                      .fetchEndOrder(state
                                                          .idOrder
                                                          .toString());
                                                  Navigator.pop(context);
                                                },
                                                showCancelButton: false,
                                                locationImage:
                                                    "assets/icons/dialog.png");
                                          },
                                          backgroundColour:
                                              AppColors.secondaryColor,
                                          textColour: AppColors.whiteColor,
                                          text: "Selesaikan Pesanan"),
                                    )
                                  : state.detailOrder?.needReview == true
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 20),
                                          child: CustomButton(
                                              onPressed: () {
                                                NeedRiviewRoute().go(context);
                                              },
                                              backgroundColour:
                                                  AppColors.secondaryColor,
                                              textColour: AppColors.whiteColor,
                                              text: "Beri Penilaian"),
                                        )
                                      : Container()
                            ])),
                          )
              ],
            ),
          ),
        );
      },
    );
  }
}
