import 'package:flutter/material.dart';
import '../../../misc/colors.dart';
import '../../../misc/price_currency%20copy.dart';
import '../../../misc/theme.dart';

class TopUpSection extends StatelessWidget {
  const TopUpSection(
      {super.key, required this.priceTopUp, required this.feeBank});

  final double priceTopUp;
  final double feeBank;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Jenis Layanan",
                style: TextStyle(
                  fontSize: fontSizeDefault,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blackColor,
                ),
              ),
              Text(
                'Top Up Saldo ${Price.currencyNoSymbol(priceTopUp)}',
                style: const TextStyle(
                  fontSize: fontSizeDefault,
                  color: AppColors.blackColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
