import 'package:flutter/material.dart';
import '../../../misc/colors.dart';
import '../../../misc/price_currency.dart';
import '../../../misc/text_style.dart';
import '../../../repositories/shop_repository/models/product_model.dart';
import '../../../router/builder.dart';
import '../../../widgets/image/image_card.dart';

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
          borderRadius: BorderRadius.circular(15), color: AppColors.whiteColor),
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
                height: 160,
                width: double.infinity,
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
                  style: AppTextStyles.textStyleNormal
                      .copyWith(color: AppColors.greyColor),
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
