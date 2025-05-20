import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../misc/colors.dart';
import '../../../misc/price_currency.dart';
import '../../../misc/text_style.dart';
import '../../../misc/theme.dart';
import 'package:slide_countdown/slide_countdown.dart';
import '../../../misc/snackbar.dart';
import '../../../widgets/image/image_card.dart';

class PpobWaitingPaymentPage extends StatefulWidget {
  final String paymentAccess;
  final double totalPayment;
  final String paymentCode;
  final String nameProduct;
  final String logoChannel;
  final DateTime paymentExpire;

  const PpobWaitingPaymentPage({
    super.key,
    required this.paymentAccess,
    required this.totalPayment,
    required this.paymentCode,
    required this.nameProduct,
    required this.logoChannel,
    required this.paymentExpire,
  });

  @override
  _PpobWaitingPaymentPageState createState() => _PpobWaitingPaymentPageState();
}

class _PpobWaitingPaymentPageState extends State<PpobWaitingPaymentPage> {
  late Timer _timer;
  late Duration _remainingTime;
  late DateTime _customExpire;

  @override
  void initState() {
    super.initState();

    final isQRPayment = widget.paymentCode.toLowerCase().contains("gopay") ||
        widget.paymentCode.toLowerCase().contains("qris");

    _customExpire = isQRPayment
        ? DateTime.now().add(const Duration(minutes: 15))
        : widget.paymentExpire;

    _remainingTime = _customExpire.difference(DateTime.now());
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime.inSeconds > 0) {
          _remainingTime = _remainingTime - const Duration(seconds: 1);
        } else {
          _timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text("Pembayaran", style: AppTextStyles.textStyleBold),
        centerTitle: true,
        toolbarHeight: 80,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 24,
          ),
          onPressed: () {
            GoRouter.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildTimerBox(),
              _buildPaymentBox(context),
              _buildDetailPayment(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimerBox() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.blackColor.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Batas Akhir Pembayaran",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              Text(
                DateFormat('dd MMM yyyy HH:mm').format(widget.paymentExpire),
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SlideCountdownSeparated(
            duration: widget.paymentExpire.difference(DateTime.now()),
            decoration: BoxDecoration(
              color: AppColors.secondaryColor,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentBox(BuildContext context) {
    final isQRPayment = widget.paymentCode.toLowerCase().contains("gopay") ||
        widget.paymentCode.toLowerCase().contains("qris");

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.blackColor.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.paymentCode.toUpperCase(),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              ImageCard(
                image: widget.logoChannel,
                radius: 0,
                width: 45,
                height: 45,
                imageError: imageDefaultBanner,
              ),
            ],
          ),
          Divider(color: AppColors.blackColor, thickness: 1.5, height: 20),
          const SizedBox(height: 10),
          if (isQRPayment) ...[
            const Text("Silakan scan QR berikut untuk membayar:",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                widget.paymentAccess,
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Text('Gagal memuat QR Code');
                },
              ),
            ),
            const SizedBox(height: 20),
            // SizedBox(
            //   width: double.infinity,
            //   child: CustomButton(
            //     text: "Bayar Langsung",
            //     onPressed: () {
            //       Helper.openLink(
            //         url: widget.paymentAccess,
            //         context: context,
            //       );
            //     },
            //   ),
            // ),
          ] else ...[
            // Tetap pakai tampilan default untuk non-QR
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Nomor Virtual Account',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                    Text(widget.paymentAccess,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                  ],
                ),
                InkWell(
                  onTap: () async {
                    await Clipboard.setData(
                        ClipboardData(text: widget.paymentAccess));
                    ShowSnackbar.snackbar(
                      context,
                      "Berhasil menyalin nomor VA",
                      isSuccess: true,
                    );
                  },
                  child: const Row(
                    children: [
                      Text('Salin',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.secondaryColor)),
                      SizedBox(width: 6),
                      Icon(Icons.copy, color: AppColors.secondaryColor),
                    ],
                  ),
                )
              ],
            )
          ]
        ],
      ),
    );
  }

  Widget _buildDetailPayment(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.blackColor.withOpacity(0.2))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Rincian Pembayaran",
            style: TextStyle(
                color: AppColors.blackColor,
                fontSize: 14,
                fontWeight: FontWeight.bold),
          ),
          const Divider(
            thickness: .3,
            color: AppColors.blackColor,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Nama Produk",
                style: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                widget.nameProduct,
                style: TextStyle(
                  color: AppColors.blackColor,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Total Pembayaran",
                style: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                Price.currency(widget.totalPayment),
                style: TextStyle(
                  color: AppColors.blackColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
