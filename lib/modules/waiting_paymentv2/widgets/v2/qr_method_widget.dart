import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import '../../../../misc/colors.dart';
import '../../../../repositories/payment_repository/models/payment_model.dart';
import '../../../../widgets/image/image_card.dart';

GlobalKey QrDownload = GlobalKey();

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
          RepaintBoundary(
            key: QrDownload,
            child: ImageCard(
              image: payment.data?["actions"][0]["url"] ?? "-",
              radius: 10,
              width: double.infinity,
              height: 300,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Expanded(
              //   child: Container(
              //     width: double.infinity,
              //     margin: const EdgeInsets.symmetric(vertical: 10),
              //     child: CustomBotton(
              //       radius: 8,
              //       colorBtn: secondaryColor,
              //       icon: Icons.file_download,
              //       onPressed: () {
              //         DownloadHelper.downloadWidget(QrDownload, "${DateFormat('yyyyddMM').format(DateTime.now())}.png", context);
              //       },
              //       showIcon: true,
              //       isOutline: false,
              //       textButton: "Download QR"
              //     ),
              //   ),
              // ),
              const SizedBox(
                width: 5,
              ),
              // Expanded(
              //   child: Container(
              //     width: double.infinity,
              //     margin: const EdgeInsets.symmetric(vertical: 10),
              //     child: CustomBotton(
              //       radius: 8,
              //       colorBtn: secondaryColor,
              //       icon: Icons.downloading_sharp,
              //       onPressed: () {
              //         Helper.openLink(url: payment.data?["actions"][1]["url"], context: context);
              //       },
              //       isOutline: false,
              //       textButton: "Bayar Langsung"
              //     ),
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
