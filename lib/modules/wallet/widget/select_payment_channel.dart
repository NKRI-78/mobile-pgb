import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../misc/colors.dart';
import '../../../misc/price_currency.dart';
import '../../../misc/text_style.dart';
import '../../../misc/theme.dart';
import '../../../widgets/image/image_card.dart';
import '../cubit/wallet_cubit.dart';

class SelectPaymentChannel extends StatelessWidget {
  const SelectPaymentChannel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletCubit, WalletState>(
      builder: (context, state) {
        return SafeArea(
          top: false,
          child: WillPopScope(
            onWillPop: () async => false,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                color: Colors.white,
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
                          style: AppTextStyles.textStyleBold
                              .copyWith(fontSize: 16),
                        ),
                      ),
                      const SizedBox(width: 25),
                    ],
                  ),
                  const Divider(
                    height: 20,
                    thickness: 0.7,
                    indent: 10,
                    endIndent: 10,
                  ),
                  Flexible(
                    child: ListView(
                      shrinkWrap: true,
                      children: state.channels
                          .where((element) => element.id != 0)
                          .map((e) => Card(
                                color: AppColors.whiteColor,
                                margin: EdgeInsets.all(5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 2,
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  title: Text(
                                    e.name == "Saldo"
                                        ? "PGB Wallet"
                                        : e.name ?? "",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  onTap: () {
                                    context
                                        .read<WalletCubit>()
                                        .setPaymentChannel(e);
                                    context
                                        .read<WalletCubit>()
                                        .updateCheckout(e: e);
                                    Navigator.pop(context);
                                  },
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: ImageCard(
                                      image: e.logo ?? "",
                                      height: 60,
                                      width: 60,
                                      radius: 10,
                                      imageError: imageDefaultBanner,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  subtitle: Text(
                                    e.paymentType == "APP"
                                        ? 'Saldo: ${Price.currency(e.user?.balance?.toDouble() ?? 0.0)}'
                                        : e.paymentType
                                                ?.replaceAll("_", " ")
                                                .replaceAll("GOPAY", "QRIS") ??
                                            "",
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                  trailing: const Icon(Icons.arrow_forward_ios,
                                      size: 20,
                                      color: AppColors.secondaryColor),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
