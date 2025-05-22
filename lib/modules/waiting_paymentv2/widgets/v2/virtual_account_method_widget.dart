import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_pgb/misc/colors.dart';
import 'package:mobile_pgb/misc/snackbar.dart';
import 'package:mobile_pgb/misc/theme.dart';
import 'package:mobile_pgb/repositories/payment_repository/models/payment_model.dart';
import 'package:mobile_pgb/widgets/image/image_card.dart';

class VirtualAccountMethodWidgetv2 extends StatelessWidget {
  const VirtualAccountMethodWidgetv2({super.key, required this.payment});

  final PaymentModel payment;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.blackColor.withValues(alpha: 0.10))
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  payment.name ?? "-",
                  style: const TextStyle(
                    color: AppColors.blackColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                ImageCard(
                  image: payment.logoUrl ?? "-", 
                  radius: 0,
                  width: 45,
                  height: 45,
                ),
              ],
            ),
          ),
          Divider(color: AppColors.blackColor.withValues(alpha: 0.10), thickness: 2, height: 5,),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Nomor Virtual Account',
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: fontSizeDefault,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      payment.data?['vaNumber'] ?? '',
                      style: const TextStyle(
                        color: AppColors.blackColor,
                        fontSize: fontSizeDefault,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () async {
                    try {
                      await Clipboard.setData(ClipboardData(text: payment.data?['vaNumber'] ?? ''));
                      if (context.mounted) {
                        ShowSnackbar.snackbar(context, "Berhasil menyalin nomor VA", isSuccess: true);
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ShowSnackbar.snackbar(context, "Gagal menyalin $e", isSuccess: false);
                      }
                    }
                  },
                  child: const Row(
                    children: [
                      Text(
                        'Salin',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondaryColor,
                        ),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Icon(
                        Icons.copy,
                        color: AppColors.secondaryColor,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
