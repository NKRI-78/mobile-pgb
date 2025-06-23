import 'package:flutter/material.dart';

import '../../../misc/colors.dart';
import '../../../misc/theme.dart';
import '../../../repositories/checkout_repository/models/main_shipping_model.dart';

class CardAddress extends StatelessWidget {
  const CardAddress({super.key, this.data});

  final Data? data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      child: InkWell(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: AppColors.blackColor.withValues(alpha: 0.2))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 5,
                    ),
                    child: Icon(
                      Icons.location_on_outlined,
                      color: AppColors.blackColor,
                      size: 20,
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Row(
                          children: [
                            IntrinsicWidth(
                              child: Text(
                                data?.label ?? "",
                                style: const TextStyle(
                                    color: AppColors.blackColor,
                                    fontSize: fontSizeLarge,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            IntrinsicWidth(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 8),
                                decoration: BoxDecoration(
                                  color: AppColors
                                      .secondaryColor, // Background color
                                  borderRadius: BorderRadius.circular(
                                      5), // Rounded corners
                                ),
                                child: const Text(
                                  "UTAMA",
                                  style: TextStyle(
                                      color: AppColors.whiteColor,
                                      fontSize: fontSizeSmall,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        data?.name ?? "",
                        style: const TextStyle(
                            color: AppColors.blackColor,
                            fontSize: fontSizeSmall,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        data?.phoneNumber ?? "",
                        style: const TextStyle(
                            color: AppColors.blackColor,
                            fontSize: fontSizeSmall,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${data?.address?.province} ${data?.address?.city} ${data?.address?.district} ${data?.address?.postalCode}',
                        style: const TextStyle(
                            color: AppColors.blackColor,
                            fontSize: fontSizeSmall,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '( ${data?.address?.detailAddress} )',
                        style: const TextStyle(
                            color: AppColors.blackColor,
                            fontSize: fontSizeSmall,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
