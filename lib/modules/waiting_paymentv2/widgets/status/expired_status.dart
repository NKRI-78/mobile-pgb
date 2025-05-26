import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../misc/colors.dart';
import '../../../../misc/price_currency.dart';
import '../../../../misc/theme.dart';
import '../../cubit/waiting_payment_cubit.dart';

class ExpiredStatus extends StatelessWidget {
  const ExpiredStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WaitingPaymentCubit, WaitingPaymentState>(
      builder: (context, state) {
        double totalProduct = state.payment?.orders?.fold(0.0, (sum, order) {
              return sum! + ((order.price ?? 0));
            }) ??
            0;
        double totalShipping = state.payment?.orders?.fold(0.0, (sum, order) {
              return sum! + ((order.otherPrice ?? 0));
            }) ??
            0;
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
                  border:
                      Border.all(color: AppColors.blackColor.withOpacity(0.2))),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Pembayaran Gagal",
                    style: TextStyle(
                      color: AppColors.redColor,
                      fontSize: fontSizeDefault,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.blackColor)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                            Price.currency(totalProduct),
                            style: const TextStyle(
                              color: AppColors.blackColor,
                              fontSize: fontSizeDefault,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Biaya Ongkir",
                            style: TextStyle(
                              fontSize: fontSizeDefault,
                              fontWeight: FontWeight.bold,
                              color: AppColors.blackColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            Price.currency(totalShipping),
                            style: const TextStyle(
                              color: AppColors.blackColor,
                              fontSize: fontSizeDefault,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                            Price.currency(
                                state.payment?.fee?.toDouble() ?? 0.0),
                            style: const TextStyle(
                              fontSize: fontSizeDefault,
                              color: AppColors.blackColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Total Pembayaran",
                            style: TextStyle(
                              fontSize: fontSizeDefault,
                              fontWeight: FontWeight.bold,
                              color: AppColors.blackColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            Price.currency(
                                state.payment?.totalPrice?.toDouble() ?? 0.0),
                            style: const TextStyle(
                                fontSize: fontSizeDefault,
                                color: AppColors.blackColor,
                                fontWeight: FontWeight.bold),
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
