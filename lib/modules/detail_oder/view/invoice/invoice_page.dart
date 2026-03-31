import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:mobile_pgb/misc/date_helper.dart';
import 'package:mobile_pgb/misc/theme.dart';

import '../../../../misc/colors.dart';
import '../../../../misc/text_style.dart';
import '../../../../repositories/detail_order_repository/models/detail_order_model.dart';

class InvoicePage extends StatelessWidget {
  final DetailOrderModel? data;

  const InvoicePage({super.key, this.data});

  String getCourierLogo(String? code) {
    switch (code?.toLowerCase()) {
      case "jne":
        return "assets/images/jne.png";
      case "gojek":
        return "assets/images/gojek.png";
      default:
        return imageDefaultBanner;
    }
  }

  @override
  Widget build(BuildContext context) {
    final shipping = data?.data?.shipping;
    final sender = data?.data?.storeAddress;
    final receiver = data?.data?.shippingAddress;

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          'Invoice',
          style: AppTextStyles.textStyleBold,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "RESI / STRUK PENGIRIMAN",
                        style:
                            AppTextStyles.textStyleBold.copyWith(fontSize: 16),
                      ),
                      Text(
                        "Partai Gema Bangsa",
                        style:
                            AppTextStyles.textStyleBold.copyWith(fontSize: 14),
                      ),
                    ],
                  ),
                  Image.asset(
                    getCourierLogo(shipping?['courier_code']),
                    width: 70,
                  )
                ],
              ),
              const SizedBox(height: 10),
              Text(
                "Invoice : ${data?.orderNumber}",
                style: AppTextStyles.textStyleNormal,
              ),
              Text(
                "Tanggal : ${DateHelper.formatFullDate(data?.createdAt)}",
                style: AppTextStyles.textStyleNormal,
              ),
              const SizedBox(height: 20),
              Center(
                child: BarcodeWidget(
                  barcode: Barcode.code128(),
                  data: data?.data?.noTracking ?? "",
                  width: 250,
                  height: 80,
                  drawText: true,
                ),
              ),
              const SizedBox(height: 10),
              const Divider(),
              Text(
                "PENGIRIM",
                style: AppTextStyles.textStyleBold.copyWith(fontSize: 14),
              ),
              Text(
                "Nama : ${data?.store?.name}",
                style: AppTextStyles.textStyleNormal,
              ),
              Text(
                "Telp : ${data?.store?.phoneNumber}",
                style: AppTextStyles.textStyleNormal,
              ),
              Text(
                "Alamat : ${sender?.detailAddress}",
                style: AppTextStyles.textStyleNormal,
              ),
              const SizedBox(height: 20),
              Text(
                "PENERIMA",
                style: AppTextStyles.textStyleBold.copyWith(fontSize: 14),
              ),
              Text(
                "Nama : ${receiver?.name}",
                style: AppTextStyles.textStyleNormal,
              ),
              Text(
                "Telp : ${receiver?.phoneNumber}",
                style: AppTextStyles.textStyleNormal,
              ),
              Text(
                "Alamat : ${receiver?.address?.detailAddress}",
                style: AppTextStyles.textStyleNormal,
              ),
              const Divider(),
              Text(
                "DETAIL PENGIRIMAN",
                style: AppTextStyles.textStyleBold.copyWith(fontSize: 14),
              ),
              Text(
                "Ekspedisi : ${shipping?['courier_code']}",
                style: AppTextStyles.textStyleNormal,
              ),
              Text(
                "Service : ${(shipping?['service'] ?? shipping?['courier_code'] ?? '-').toString()}",
                style: AppTextStyles.textStyleNormal,
              ),
              Text(
                "Qty : ${data?.items?.length} pcs",
                style: AppTextStyles.textStyleNormal,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
