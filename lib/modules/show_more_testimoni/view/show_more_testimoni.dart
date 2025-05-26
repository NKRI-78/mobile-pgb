import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:flutter/material.dart';
import '../../../misc/colors.dart';
import '../../../misc/theme.dart';
import '../../../repositories/shop_repository/models/detail_product_model.dart';
import '../../../widgets/header/header_section.dart';
import '../../../widgets/image/image_avatar.dart';
import '../../../widgets/image/image_card.dart';

class ShowMoreTesttimoniPage extends StatelessWidget {
  const ShowMoreTesttimoniPage({
    super.key,
    required this.idProduct,
    this.reviews,
  });

  final String idProduct;
  final List<Reviews>? reviews;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: CustomScrollView(
        slivers: [
          const HeaderSection(titleHeader: "Ulasan Pembeli"),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                if (reviews == null || reviews!.isEmpty)
                  const Text(
                    "Belum ada ulasan",
                    style: TextStyle(
                      color: AppColors.blackColor,
                      fontSize: fontSizeDefault,
                    ),
                  )
                else
                  Column(
                    children: [
                      _buildReviewSummary(reviews!),
                      const SizedBox(height: 10),
                      ...reviews!.map((riview) {
                        final message = riview.message;
                        final rating = riview.rating?.toDouble() ?? 0.0;
                        final fullname =
                            riview.userProfile?.profile?.fullname ?? "";
                        final avatar =
                            riview.userProfile?.profile?.linkAvatar ?? "";
                        final images = riview.images ?? [];

                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: AppColors.blackColor
                                      .withValues(alpha: 0.2))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  ImageAvatar(image: avatar, radius: 15),
                                  const SizedBox(width: 10),
                                  Text(
                                    fullname,
                                    style: const TextStyle(
                                      color: AppColors.blackColor,
                                      fontSize: fontSizeLarge,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              RatingBar.readOnly(
                                alignment: Alignment.centerLeft,
                                size: 20,
                                filledIcon: Icons.star,
                                emptyIcon: Icons.star_border,
                                initialRating: rating,
                                maxRating: 5,
                              ),
                              const SizedBox(height: 8),
                              message == null || message == ""
                                  ? SizedBox.shrink()
                                  : Text(
                                      message,
                                      style: const TextStyle(
                                          color: AppColors.blackColor),
                                    ),
                              riview.images?.isEmpty ?? false
                                  ? const SizedBox.shrink()
                                  : const SizedBox(height: 10),
                              if (images.isNotEmpty)
                                riview.images?.isEmpty ?? false
                                    ? const SizedBox.shrink()
                                    : SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: List.generate(images.length,
                                              (imgIndex) {
                                            final img = images[imgIndex];
                                            return Container(
                                              width: 100,
                                              height: 100,
                                              margin: const EdgeInsets.only(
                                                  right: 12),
                                              child: InkWell(
                                                onTap: () {
                                                  // Navigator.push(context, MaterialPageRoute(
                                                  //   builder: (_) => FullscreenGallery(
                                                  //     images: riview.images?.map((media) => media.link)
                                                  //     .whereType<String>()
                                                  //     .toList() ?? [],
                                                  //     initialIndex: imgIndex,
                                                  //   ),
                                                  // ));
                                                },
                                                child: ImageCard(
                                                  image: img.link ?? "",
                                                  height: 50,
                                                  radius: 8,
                                                  width: 50,
                                                ),
                                              ),
                                            );
                                          }),
                                        ),
                                      ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewSummary(List<Reviews> reviews) {
    // List untuk rating valid (rating saja, boleh tanpa pesan)
    final ratingList = reviews.where((r) => r.rating != null).toList();

    // List untuk ulasan lengkap (rating + pesan)
    final reviewList = reviews
        .where((r) => r.rating != null && r.message != null && r.message != "")
        .toList();

    // Hitung total dan rata-rata rating
    final totalRating = ratingList.fold(0.0, (sum, r) => sum + r.rating!);
    final averageRating =
        ratingList.isNotEmpty ? (totalRating / ratingList.length) : 0;
    final displayRating =
        double.parse(averageRating.toStringAsFixed(1)); // Misal: 4.27 => 4.3

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        children: [
          const Icon(Icons.star, size: 30, color: AppColors.yellowColor),
          const SizedBox(width: 10),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$displayRating ',
                  style: const TextStyle(
                    color: AppColors.blackColor,
                    fontSize: fontSizeLarge,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text:
                      '(${ratingList.length} rating • ${reviewList.length} ulasan)',
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
    );
  }
}
