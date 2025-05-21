import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:slide_countdown/slide_countdown.dart';

import '../../../misc/colors.dart';
import '../../../misc/date_helper.dart';
import '../../../misc/price_currency.dart';
import '../../../misc/text_style.dart';
import '../../../widgets/pages/empty_page.dart';
import '../../../widgets/pages/loading_page.dart';
import '../cubit/waiting_payment_cubit.dart';
import '../widgets/status/expired_status.dart';
import '../widgets/status/success_status.dart';
import '../widgets/v2/qr_method_widget.dart';
import '../widgets/v2/virtual_account_method_widget.dart';

class WaitingPaymentPage extends StatelessWidget {
  final String id;
  const WaitingPaymentPage({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WaitingPaymentCubit>(
      create: (context) => WaitingPaymentCubit(id: id)..init(context),
      child: const WaitingPaymentView(),
    );
  }
}

class WaitingPaymentView extends StatefulWidget {
  const WaitingPaymentView({super.key});

  @override
  State<WaitingPaymentView> createState() => _WaitingPaymentViewState();
}

class _WaitingPaymentViewState extends State<WaitingPaymentView> {
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
        print("Payment Type: ${state.payment?.paymentType}");

        final targetDateTime = DateTime.parse(state.payment?.createdAt == null
                ? DateTime.now().toString()
                : state.payment!.createdAt!)
            .add(
          state.payment?.type == "VIRTUAL_ACCOUNT"
              ? const Duration(
                  days: 1,
                )
              : const Duration(
                  minutes: 15,
                ),
        );
        final duration = targetDateTime.difference(DateTime.now());

        return Scaffold(
          body: RefreshIndicator(
            color: AppColors.secondaryColor,
            onRefresh: () async {
              await context.read<WaitingPaymentCubit>().init(context);
            },
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  surfaceTintColor: Colors.transparent,
                  pinned: true,
                  elevation: 2,
                  title: Text(
                    'Pembayaran',
                    style: AppTextStyles.textStyleBold,
                  ),
                  centerTitle: true,
                  leading: IconButton(
                    onPressed: () {
                      GoRouter.of(context).pop();
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, bottom: 80, top: 10),
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
                                      delegate: SliverChildListDelegate(
                                        [
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
                                                    color: AppColors.blackColor
                                                        .withOpacity(0.2))),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                                              ? AppColors
                                                                  .redColor
                                                              : AppColors
                                                                  .blackColor,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    isExpired
                                                        ? Container()
                                                        : state.payment
                                                                    ?.status ==
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
                                                                  color: AppColors
                                                                      .blackColor,
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
                                                            color: AppColors
                                                                .secondaryColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5)),
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
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 10),
                                            decoration: BoxDecoration(
                                                color: AppColors.whiteColor,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                    color: AppColors.blackColor
                                                        .withOpacity(0.2))),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  "Rincian Pembayaran",
                                                  style: TextStyle(
                                                      color:
                                                          AppColors.blackColor,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const Divider(
                                                  thickness: .3,
                                                  color: AppColors.blackColor,
                                                ),
                                                state.payment?.paymentType !=
                                                        "TOPUP"
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 5),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [],
                                                        ),
                                                      )
                                                    : const SizedBox.shrink(),
                                                Padding(
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
                                                      Text(
                                                        state.payment
                                                                    ?.paymentType ==
                                                                "TOPUP"
                                                            ? "Harga Topup"
                                                            : "Harga Topup",
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: AppColors
                                                              .blackColor,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        Price.currency(state
                                                                .payment!.price
                                                                ?.toDouble() ??
                                                            0.0),
                                                        style: const TextStyle(
                                                          color: AppColors
                                                              .blackColor,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
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
                                                        "Biaya Admin Bank",
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
                                                        Price.currency(state
                                                                .payment?.fee
                                                                ?.toDouble() ??
                                                            0.0),
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          color: AppColors
                                                              .blackColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
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
                                                        "Total Pembayaran",
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
                                                        Price.currency(state
                                                                .payment
                                                                ?.totalPrice
                                                                ?.toDouble() ??
                                                            0.0),
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            color: AppColors
                                                                .blackColor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
