import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_pgb/misc/colors.dart';
import 'package:mobile_pgb/misc/price_currency.dart';
import 'package:mobile_pgb/misc/theme.dart';
import 'package:mobile_pgb/modules/waiting_paymentv2/cubit/waiting_payment_cubit.dart';

class SuccessStatus extends StatelessWidget {
  const SuccessStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WaitingPaymentCubit, WaitingPaymentState>(
        builder: (context, state) {
          double totalProduct = state.payment?.orders?.fold(0.0, (sum, order) {
            return sum! + ((order.price ?? 0));
          }) ?? 0;
          double totalShipping = state.payment?.orders?.fold(0.0, (sum, order) {
            return sum! + ((order.otherPrice ?? 0));
          }) ?? 0;
        return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 5),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.blackColor)),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Pembayaran Berhasil",
                      style: TextStyle(
                        color: AppColors.secondaryColor,
                        fontSize: fontSizeDefault,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 5),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.blackColor)),
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/icons/thumbs-up.png",
                      height: 150,
                    ),
                    const Text("Pembayaran Anda berhasil! Terima kasih telah Berbelanja di ATJ-Mobile",
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.visible,
                    style: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: fontSizeLarge,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'SF Pro')),
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
            ],
          );
      },
    );
  }
}
