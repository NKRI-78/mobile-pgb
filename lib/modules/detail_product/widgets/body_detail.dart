import 'dart:math';

import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../misc/colors.dart';
import '../../../misc/date_helper.dart';
import '../../../misc/helper.dart';
import '../../../misc/price_currency.dart';
import '../../../misc/theme.dart';
import '../cubit/detail_product_cubit.dart';
import '../../../repositories/shop_repository/models/detail_product_model.dart';
import '../../../router/builder.dart';
import '../../../widgets/detect_text/detect_text.dart';
import '../../../widgets/image/image_avatar.dart';
import '../../../widgets/image/image_card.dart';
import '../../../widgets/pages/page_full_screen_gallery.dart';

class BodyDetail extends StatelessWidget {
  const BodyDetail({super.key, this.data});

  final DetailProductData? data;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 1.0,
        minChildSize: 0.6,
        builder: (context, scrollController) {
          final ratingList =
              data?.reviews?.where((r) => r.rating != null).toList() ?? [];
          final reviewFilter = data?.reviews
                  ?.where((r) =>
                      r.rating != null && r.message != null && r.message != "")
                  .toList() ??
              [];

          final totalRating = ratingList.fold(0.0, (sum, r) => sum + r.rating!);
          final averageRating =
              ratingList.isNotEmpty ? totalRating / ratingList.length : 0.0;
          final totalReview = double.parse(averageRating.toStringAsFixed(1));
          return BlocBuilder<DetailProductCubit, DetailProductState>(
            builder: (context, state) {
              return Scaffold(
                backgroundColor: AppColors.primaryColor,
                body: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  clipBehavior: Clip.hardEdge,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.zero,
                    controller: scrollController,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  '${Price.currency(data?.price?.toDouble() ?? 0)}',
                                  style: const TextStyle(
                                      color: AppColors.blackColor,
                                      fontSize: fontSizeOverLarge,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  data?.stock == 0
                                      ? ""
                                      : 'Stock : ${data?.stock}',
                                  style: TextStyle(
                                      color: data?.stock == 0
                                          ? AppColors.redColor
                                          : AppColors.blackColor,
                                      fontSize: fontSizeLarge,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          Text(
                            data?.name ?? "-",
                            style: const TextStyle(
                                color: AppColors.blackColor,
                                fontSize: fontSizeExtraLarge,
                                fontWeight: FontWeight.w500),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Divider(
                              thickness: 1,
                              color: AppColors.greyColor,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ImageAvatar(
                                    image: data?.store?.linkPhoto ?? "-",
                                    radius: 20,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data?.store?.name ?? "-",
                                        style: const TextStyle(
                                            color: AppColors.blackColor,
                                            fontSize: fontSizeLarge,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        data?.store?.address?.city ?? "-",
                                        style: const TextStyle(
                                            color: AppColors.blackColor,
                                            fontSize: fontSizeDefault,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  )
                                ],
                              ))
                            ],
                          ),
                          const Divider(
                            thickness: 1,
                            color: AppColors.greyColor,
                          ),
                          const Text(
                            "Informasi Produk",
                            style: TextStyle(
                                color: AppColors.blackColor,
                                fontSize: fontSizeExtraLarge,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Expanded(
                                flex: 2,
                                child: Text(
                                  "Berat",
                                  style: TextStyle(
                                      color: AppColors.blackColor,
                                      fontSize: fontSizeDefault,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Text(
                                  ": ${Helper.convertGramsToKg(state.detail?.data?.weight?.toDouble() ?? 0.0).toStringAsFixed(2)} Kg",
                                  style: const TextStyle(
                                      color: AppColors.blackColor,
                                      fontSize: fontSizeDefault,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const Divider(
                            thickness: .5,
                            color: AppColors.greyColor,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Expanded(
                                flex: 2,
                                child: Text(
                                  "Kondisi ",
                                  style: TextStyle(
                                      color: AppColors.blackColor,
                                      fontSize: fontSizeDefault,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Text(
                                  ": ${state.detail?.data?.itemCondition == "NEW" ? "Baru" : "Bekas"}",
                                  style: const TextStyle(
                                      color: AppColors.blackColor,
                                      fontSize: fontSizeDefault,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const Divider(
                            thickness: .5,
                            color: AppColors.greyColor,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Deskripsi Produk",
                            style: TextStyle(
                                color: AppColors.blackColor,
                                fontSize: fontSizeExtraLarge,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          DetectText(text: data?.description ?? "-"),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Ulasan Pembeli",
                                style: TextStyle(
                                    color: AppColors.blackColor,
                                    fontSize: fontSizeExtraLarge,
                                    fontWeight: FontWeight.w500),
                              ),
                              data!.reviews!.isEmpty
                                  ? Container()
                                  : InkWell(
                                      onTap: () {
                                        ShowMoreTestimoniRoute(
                                                idProduct:
                                                    data?.id.toString() ?? "",
                                                $extra: data?.reviews ?? [])
                                            .go(context);
                                      },
                                      child: const Text(
                                        "Lihat Semua",
                                        style: TextStyle(
                                            color: AppColors.blackColor,
                                            fontSize: fontSizeDefault,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                            ],
                          ),
                          data!.reviews!.isEmpty
                              ? Container()
                              : Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        size: 30,
                                        color: AppColors.yellowColor,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: '$totalReview ',
                                              style: const TextStyle(
                                                color: AppColors.blackColor,
                                                fontSize: fontSizeLarge,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextSpan(
                                              text:
                                                  '(${ratingList.length} rating • ${reviewFilter.length} ulasan)',
                                              style: const TextStyle(
                                                color: AppColors.blackColor,
                                                fontSize: fontSizeDefault,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          data!.reviews!.isEmpty
                              ? const Text(
                                  "Belum ada ulasan",
                                  style: TextStyle(
                                    color: AppColors.blackColor,
                                    fontSize: fontSizeDefault,
                                  ),
                                )
                              : ListView.builder(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  shrinkWrap: true,
                                  itemCount: min(2, data?.reviews?.length ?? 0),
                                  itemBuilder: (context, index) {
                                    final riview = data?.reviews?[index];
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      decoration: BoxDecoration(
                                          color: AppColors.whiteColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: AppColors.blackColor
                                                  .withValues(alpha: 0.2))),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              ImageAvatar(
                                                image: riview?.userProfile
                                                        ?.profile?.linkAvatar ??
                                                    "",
                                                radius: 15,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              // Column(
                                              //   mainAxisAlignment: MainAxisAlignment.start,
                                              //   crossAxisAlignment: CrossAxisAlignment.start,
                                              //   children: [
                                              //     Text(
                                              //       riview?.userProfile?.profile?.fullname ?? "",
                                              //       style: const TextStyle(
                                              //         color: AppColors.blackColor,
                                              //         fontSize: fontSizeLarge,
                                              //         fontWeight: FontWeight.bold
                                              //       ),
                                              //     ),
                                              //     Text(
                                              //       DateHelper.formatDate(DateTime.parse(riview?.updatedAt ?? "")),
                                              //       style: const TextStyle(
                                              //         color: AppColors.blackColor,
                                              //         fontSize: fontSizeSmall,
                                              //         fontWeight: FontWeight.bold
                                              //       ),
                                              //     ),
                                              //   ],
                                              // ),
                                              Text(
                                                riview?.userProfile?.profile
                                                        ?.fullname ??
                                                    "",
                                                style: const TextStyle(
                                                    color: AppColors.blackColor,
                                                    fontSize: fontSizeLarge,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: RatingBar.readOnly(
                                              alignment: Alignment.centerLeft,
                                              size: 20,
                                              filledIcon: Icons.star,
                                              emptyIcon: Icons.star_border,
                                              initialRating:
                                                  riview?.rating?.toDouble() ??
                                                      0.0,
                                              maxRating: 5,
                                            ),
                                          ),
                                          riview?.message == null ||
                                                  riview?.message == ""
                                              ? SizedBox.shrink()
                                              : Text(
                                                  riview?.message ?? "",
                                                  style: const TextStyle(
                                                      color:
                                                          AppColors.blackColor),
                                                ),
                                          riview?.images?.isEmpty ?? false
                                              ? const SizedBox.shrink()
                                              : const SizedBox(
                                                  height: 10,
                                                ),
                                          riview?.images?.isEmpty ?? false
                                              ? const SizedBox.shrink()
                                              : SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Row(
                                                    children: List.generate(
                                                        riview?.images
                                                                ?.length ??
                                                            0, (index) {
                                                      return Container(
                                                        width: 100,
                                                        height: 100,
                                                        decoration: const BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            20))),
                                                        margin: const EdgeInsets
                                                            .only(right: 12),
                                                        child: InkWell(
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (_) =>
                                                                      FullscreenGallery(
                                                                    images: riview
                                                                            ?.images
                                                                            ?.map((media) =>
                                                                                media.link)
                                                                            .whereType<String>()
                                                                            .toList() ??
                                                                        [],
                                                                    initialIndex:
                                                                        index,
                                                                  ),
                                                                ));
                                                          },
                                                          child: ImageCard(
                                                              image: riview
                                                                      ?.images?[
                                                                          index]
                                                                      .link ??
                                                                  "",
                                                              height: 50,
                                                              radius: 8,
                                                              width: 50,
                                                              imageError:
                                                                  imageDefaultData),
                                                        ),
                                                      );
                                                    }),
                                                  ),
                                                ),
                                        ],
                                      ),
                                    );
                                  },
                                )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        });
  }
}
