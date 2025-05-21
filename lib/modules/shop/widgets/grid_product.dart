import 'package:flutter/material.dart';
import 'package:mobile_pgb/misc/colors.dart';
import 'package:mobile_pgb/misc/price_currency.dart';
import 'package:mobile_pgb/misc/text_style.dart';
import 'package:mobile_pgb/repositories/shop_repository/models/product_model.dart';
import 'package:mobile_pgb/router/builder.dart';
import 'package:mobile_pgb/widgets/image/image_card.dart';

class GridProduct extends StatelessWidget {
  const GridProduct({super.key, required this.data});

  final ProductModel data;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColors.whiteColor
      ),
      child: Column(
        children: [
          InkWell(
          onTap: () {
            DetailProductRoute(idProduct: data.id.toString()).go(context);
          },
          child: ImageCard(
            image: (data.pictures?.isEmpty ?? false)
              ? ""
              : data.pictures?.first.link ?? "",
            radius: 15, 
            height: 148, 
            width: double.infinity,
          )),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  data.name ?? "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.textStyleNormal,
                ),
                Text(
                  data.category?.name ?? "",
                  maxLines: 1,
                  style: AppTextStyles.textStyleNormal.copyWith(
                    color: AppColors.greyColor
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${Price.currency(data.price!.toDouble()) ?? 0}',
                        maxLines: 1,
                        style: AppTextStyles.textStyleNormal,
                      ),
                      // const Icon(
                      //   Icons.favorite_border,
                      //   size: 14,
                      //   color: whiteColor,
                      // )
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