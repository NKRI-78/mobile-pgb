import 'package:flutter/material.dart';
import '../../../../widgets/button/custom_button.dart';
import '../../../../misc/colors.dart';
import '../../../../misc/download_manager.dart';
import '../../../../misc/helper.dart';
import '../../../../repositories/payment_repository/models/payment_model.dart';
import '../../../../widgets/image/image_card.dart';

class QrMethodWidgetV2 extends StatelessWidget {
  const QrMethodWidgetV2({super.key, required this.payment});

  final PaymentModel payment;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(10),
          border:
              Border.all(color: AppColors.blackColor.withValues(alpha: 0.10))),
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
                    fontSize: 16,
                    color: AppColors.blackColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                ImageCard(
                  image: payment.logoUrl ?? "-",
                  radius: 20,
                  width: 45,
                  height: 45,
                ),
              ],
            ),
          ),
          Divider(
            color: AppColors.blackColor.withValues(alpha: 0.10),
            thickness: 2,
            height: 5,
          ),
          ImageCard(
            image: payment.data?["actions"][0]["url"] ?? "-",
            radius: 10,
            width: double.infinity,
            height: 300,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: CustomButton(
                    backgroundColour: AppColors.secondaryColor,
                    text: "Download QR",
                    textColour: AppColors.whiteColor,
                    icon: Icons.file_download,
                    onPressed: () {
                      final qrUrl = payment.data?["actions"][0]["url"];
                      if (qrUrl != null) {
                        DownloadHelper.downloadQrFromUrl(
                            context: context, url: qrUrl);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: CustomButton(
                    backgroundColour: AppColors.secondaryColor,
                    text: "Bayar Sekarang",
                    textColour: AppColors.whiteColor,
                    radius: 8,
                    icon: Icons.downloading_sharp,
                    onPressed: () {
                      Helper.openLink(
                          url: payment.data?["actions"][1]["url"],
                          context: context);
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
