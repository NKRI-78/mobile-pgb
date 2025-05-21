import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_pgb/misc/colors.dart';
import 'package:mobile_pgb/misc/date_helper.dart';
import 'package:mobile_pgb/misc/price_currency.dart';
import 'package:mobile_pgb/misc/theme.dart';
import 'package:mobile_pgb/modules/waiting_paymentv2/cubit/waiting_payment_cubit.dart';
import 'package:mobile_pgb/modules/waiting_paymentv2/widgets/status/expired_status.dart';
import 'package:mobile_pgb/modules/waiting_paymentv2/widgets/status/success_status.dart';
import 'package:mobile_pgb/modules/waiting_paymentv2/widgets/v2/qr_method_widget.dart';
import 'package:mobile_pgb/modules/waiting_paymentv2/widgets/v2/virtual_account_method_widget.dart';
import 'package:mobile_pgb/widgets/header/header_section.dart';
import 'package:mobile_pgb/widgets/image/image_avatar.dart';
import 'package:mobile_pgb/widgets/pages/empty_page.dart';
import 'package:mobile_pgb/widgets/pages/loading_page.dart';
import 'package:slide_countdown/slide_countdown.dart';

class WaitingPaymentV2Page extends StatelessWidget {
  final String id;
  final int? tabIndex;
  const WaitingPaymentV2Page({
    super.key, 
    required this.id, 
    this.tabIndex,
  });

  @override
  Widget build(BuildContext context) {
    print("ID Payement : $id");
    return BlocProvider<WaitingPaymentCubit>(
      create: (context) => WaitingPaymentCubit(id: id)..init(context, tabIndex ?? 0),
      child: const WaitingPaymentV2View(),
    );
  }
}

class WaitingPaymentV2View extends StatefulWidget {
  const WaitingPaymentV2View({super.key});

  @override
  State<WaitingPaymentV2View> createState() => _WaitingPaymentViewState();
}

class _WaitingPaymentViewState extends State<WaitingPaymentV2View> {
  late bool isExpired;

  @override
  void initState() {
    super.initState();
    isExpired = false;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WaitingPaymentCubit, WaitingPaymentState>(
        builder: (context, state) {
          final targetDateTime = DateTime.parse(state.payment?.createdAt == null ? DateTime.now().toString() : state.payment!.createdAt!).add(
            state.payment?.type == "VIRTUAL_ACCOUNT" ? const Duration(
              days: 1,
            ) : const Duration(
              minutes: 30,
            ),
          ); 
          final duration = targetDateTime.difference(DateTime.now());

          double totalProduct = state.payment?.orders?.fold(0.0, (sum, order) {
            return sum! + ((order.price ?? 0));
          }) ?? 0;
          double totalShipping = state.payment?.orders?.fold(0.0, (sum, order) {
            return sum! + ((order.otherPrice ?? 0));
          }) ?? 0;
        return Scaffold(
          backgroundColor: AppColors.primaryColor,
          // bottomNavigationBar: state.payment?.status != 'PAID' ? null : CustomBotton(
          //     onPressed: () {
          //       state.payment?.status == 'PAID' ? OrderRoute(initIndex: 1).push(context) : state.payment?.data?['type'] == "TOPUP" ? OrderRoute(initIndex:5).push(context) :  HomeRoute().go(context);
          //     },
          //     colorBtn: secondaryColor,
          //     radius: 0,
          //     isOutline: false,
          //     textButton: state.payment?.status == 'PAID' ? "Lihat status pesanan saya" : "Kembali"),
          body: RefreshIndicator(
            onRefresh: () async {
              await context.read<WaitingPaymentCubit>().init(context, 0);
            },
            child: CustomScrollView(
              slivers: [
                const HeaderSection(titleHeader: "Pembayaran"),
                SliverPadding(
                  padding: const EdgeInsets.only(left: 10, right: 10, bottom: 80, top: 10),
                  sliver: state.loading
                      ? const SliverFillRemaining(
                          child: Center(child: CustomLoadingPage()),
                        )
                      : state.payment?.status == 'expire'
                          ? const SliverToBoxAdapter(
                              child: ExpiredStatus(),
                            )
                          : state.payment?.status == 'PAID'
                              ? const SliverToBoxAdapter(
                                  child: SuccessStatus(),
                                )
                              : state.payment == null
                                  ? const SliverFillRemaining(
                                      child: Center(
                                          child: EmptyPage(
                                              msg: "Tidak ada pembayaran")))
                                  : SliverList(
                                      delegate: SliverChildListDelegate([
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 10),
                                        decoration: BoxDecoration(
                                            color: AppColors.whiteColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: AppColors.blackColor)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  isExpired
                                                      ? "Pembayaran Kedaluwarsa"
                                                      : "Batas Akhir Pembayaran",
                                                  style: TextStyle(
                                                      color: isExpired
                                                          ? AppColors.redColor
                                                          : AppColors.whiteColor,
                                                      fontSize: fontSizeDefault,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                isExpired
                                                    ? Container()
                                                    : state.payment?.status ==
                                                            "WAITING_FOR_PAYMENT"
                                                        ? Text(
                                                            DateHelper.parseDateExpired(
                                                                state.payment
                                                                        ?.createdAt ??
                                                                    DateTime.now()
                                                                        .toString(),
                                                                state.payment
                                                                        ?.type ??
                                                                    ""),
                                                            style:
                                                                const TextStyle(
                                                              color: AppColors.blackColor,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          )
                                                        : Container(),
                                              ],
                                            ),
                                            isExpired
                                                ? Container()
                                                : SlideCountdownSeparated(
                                                    duration: duration,
                                                    decoration: BoxDecoration(
                                                        color: AppColors.secondaryColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    onDone: () {
                                                      setState(() {
                                                        isExpired = true;
                                                      });
                                                    },
                                                  ),
                                          ],
                                        ),
                                      ),
                                      isExpired
                                          ? Container()
                                          : state.payment?.type ==
                                                  'VIRTUAL_ACCOUNT'
                                              ? VirtualAccountMethodWidgetv2(
                                                  payment: state.payment!,
                                                )
                                              : QrMethodWidgetV2(
                                                  payment: state.payment!),
                                      
                                        Container(
                                          margin: const EdgeInsets.symmetric(vertical: 5),
                                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                          decoration: BoxDecoration(
                                            color: AppColors.whiteColor,
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(color: AppColors.blackColor)
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              const Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      'Informasi Pesanan',
                                                      style: TextStyle(
                                                        color: AppColors.blackColor,
                                                        fontSize: fontSizeDefault,
                                                        fontWeight: FontWeight.bold
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const Divider(thickness: .7,  color: AppColors.blackColor,),
                                              Column(
                                                children: List.generate(state.payment?.orders?.length ?? 0, (index) {
                                                  final data =  state.payment?.orders?[index];
                                                  return Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  state.payment?.data?['type'] == "TOPUP" ? Container() : Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 5),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Expanded(
                                                          child: ImageAvatar(
                                                            image: data?.store?.linkPhoto ?? "", 
                                                            radius: 15,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 5,
                                                          child: Text(
                                                            data?.store?.name ?? "",
                                                            maxLines: 2,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: const TextStyle(
                                                                color: AppColors.blackColor,
                                                                fontSize: fontSizeDefault,
                                                                fontWeight: FontWeight.bold),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Column(
                                                children: data?.items?.map((e) => 
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        // Expanded(
                                                        //   child: ImageCard(
                                                        //     image: (e.product?.pictures?.isEmpty ?? false)
                                                        //     ? ""
                                                        //     : e.product?.pictures?.first.link ?? "", 
                                                        //     radius: 5, 
                                                        //     height: 50, 
                                                        //     width: 50,
                                                        //   ),
                                                        // ),
                                                        // const SizedBox(
                                                        //   width: 10,
                                                        // ),
                                                        const Padding(
                                                          padding: EdgeInsets.symmetric(horizontal: 10),
                                                          child: Icon(
                                                            Icons.circle_sharp,
                                                            size: 10,
                                                            color: AppColors.blackColor,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 5,
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                e.product?.name ?? "",
                                                                maxLines: 2,
                                                                overflow: TextOverflow.ellipsis,
                                                                style: const TextStyle(
                                                                  color: AppColors.blackColor,
                                                                  fontSize: fontSizeDefault,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    '( ${e.quantity} item )',
                                                                    style: const TextStyle(
                                                                      color: AppColors.blackColor,
                                                                      fontSize: fontSizeDefault,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    '${Price.currency((e.price?.toDouble() ?? 0.0) * (e.quantity?.toDouble() ?? 0.0))}',
                                                                    style: const TextStyle(
                                                                      color: AppColors.blackColor,
                                                                      fontSize: fontSizeDefault,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ).toList() ?? [],
                                              ),
                                                ],
                                              );
                                                }).toList(),
                                              ),
                                              state.payment?.data?['type'] == "TOPUP" ? Container() : const Divider(thickness: .3, color: AppColors.blackColor,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  state.payment?.data?['type'] == "TOPUP" ? Text(
                                                    state.payment?.data?['type'],
                                                    style: const TextStyle(
                                                      color: AppColors.blackColor,
                                                      fontSize: fontSizeDefault,
                                                    ),
                                                  ) : const Text(
                                                    'Total Harga',
                                                    style: TextStyle(
                                                      color: AppColors.blackColor,
                                                      fontSize: fontSizeDefault,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${Price.currency(totalProduct.toDouble())}',
                                                    style: const TextStyle(
                                                      color: AppColors.blackColor,
                                                      fontSize: fontSizeDefault,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),    
                                      Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 10),
                                          decoration: BoxDecoration(
                                              color: AppColors.whiteColor,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: AppColors.blackColor)),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Rincian Pembayaran",
                                                style: TextStyle(
                                                    color: AppColors.blackColor,
                                                    fontSize: fontSizeDefault,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const Divider(
                                                thickness: .3,
                                                color: AppColors.blackColor,
                                              ),
                                              Padding(
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
                                                      "Harga Produk",
                                                      style: TextStyle(
                                                        fontSize: fontSizeDefault,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: AppColors.blackColor,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      Price.currency(
                                                          totalProduct),
                                                      style: const TextStyle(
                                                          color: AppColors.blackColor,
                                                          fontSize: fontSizeDefault,),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              totalShipping == 0 ? Container() : Padding(
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
                                                        color: AppColors.blackColor,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      Price.currency(
                                                          totalShipping),
                                                      style: const TextStyle(
                                                          color: AppColors.blackColor,
                                                          fontSize: fontSizeDefault,),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
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
                                                      "Biaya Admin",
                                                      style: TextStyle(
                                                        fontSize: fontSizeDefault,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: AppColors.blackColor,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      Price.currency(state
                                                              .payment?.fee
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
                                              const Divider(thickness: .5, color: AppColors.blackColor,),
                                              Padding(
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
                                                      "Total Pembayaran",
                                                      style: TextStyle(
                                                        fontSize: fontSizeDefault,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: AppColors.blackColor,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      Price.currency(state
                                                              .payment
                                                              ?.totalPrice
                                                              ?.toDouble() ??
                                                          0.0),
                                                      style: const TextStyle(
                                                        fontSize: fontSizeDefault,
                                                        color: AppColors.blackColor,
                                                        fontWeight: FontWeight.bold
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )),
                                    ])),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
