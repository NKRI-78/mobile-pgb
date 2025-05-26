import 'package:flutter/material.dart';
import '../../misc/colors.dart';
import '../../repositories/oder_repository/models/tracking_model.dart';
import 'package:photo_view/photo_view.dart';

class PageDetailProofShipping extends StatelessWidget {
  const PageDetailProofShipping({super.key, required this.tracking});

  final TrackingModel tracking;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
                child: PhotoView(
              imageProvider: Image.network(tracking.cnote?.photo ?? "").image,
            )),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                height: 130,
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                decoration: BoxDecoration(
                  color: AppColors.blackColor.withValues(alpha: 0.5)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_back,
                            color: AppColors.whiteColor,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          "Bukti Pengiriman",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17.0,
                            decoration: null,
                          ),
                        ),
                      ],
                    ),
                    RichText(
                        text: TextSpan(children: [
                      const TextSpan(
                        text: "No Resi : ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17.0,
                        ),
                      ),
                      TextSpan(
                        text: tracking.cnote?.cnoteNo,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17.0,
                        ),
                      )
                    ])),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
