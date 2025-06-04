import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../misc/text_style.dart';
import '../../../misc/colors.dart';
import '../../../misc/price_currency.dart';
import '../../../misc/theme.dart';
import '../cubit/checkout_cubit.dart';
import '../../../widgets/image/image_card.dart';

class SelectPaymentChannel extends StatelessWidget {
  const SelectPaymentChannel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckoutCubit, CheckoutState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            color: AppColors.primaryColor,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_outlined,
                      color: AppColors.blackColor,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Text(
                      "Pilih Metode Pembayaran",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.textStyleBold.copyWith(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 25),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),

              // List Metode Pembayaran dalam bentuk Card
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: state.channels
                      .map((e) => Card(
                            color: e.user?.balance == 0
                                ? AppColors.redColor.withValues(alpha: 0.7)
                                : AppColors.whiteColor,
                            margin: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              title: Text(
                                e.name == "Saldo" ? "PGB Wallet" : e.name ?? "",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              onTap: e.user?.balance == 0
                                  ? null
                                  : () {
                                      context
                                          .read<CheckoutCubit>()
                                          .setPaymentChannel(e);
                                      Navigator.pop(context);
                                      context
                                          .read<CheckoutCubit>()
                                          .updateCheckout(
                                              checkout: state.checkout, e: e);
                                    },
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: ImageCard(
                                  image: e.logo ?? "",
                                  height: 60,
                                  width: 60,
                                  radius: 10,
                                  imageError: imageDefaultData,
                                ),
                              ),
                              subtitle: Text(
                                e.paymentType == "APP"
                                    ? 'Saldo: ${Price.currency(e.user?.balance?.toDouble() ?? 0.0)}'
                                    : e.paymentType
                                            ?.replaceAll("_", " ")
                                            .replaceAll("GOPAY", "QRIS") ??
                                        "",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: e.user?.balance == 0
                                        ? AppColors.whiteColor
                                        : Colors.grey),
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios,
                                  size: 18, color: AppColors.blueColor),
                            ),
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
