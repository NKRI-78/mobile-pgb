import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_pgb/misc/colors.dart';
import 'package:shimmer/shimmer.dart';

import '../../../misc/text_style.dart';
import '../../../misc/theme.dart';

class CustomCardEventSection extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final bool isExpired;
  final VoidCallback? onTap;

  const CustomCardEventSection({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.isExpired,
    this.onTap,
  });

  String formatDateRange(DateTime? startDate, DateTime? endDate) {
    final dateFormat = DateFormat('dd MMM yyyy', 'id_ID');
    if (startDate == null || endDate == null) {
      return "Tanggal tidak tersedia";
    }
    final utcStart = startDate.toUtc();
    final utcEnd = endDate.toUtc();
    if (dateFormat.format(utcStart) == dateFormat.format(utcEnd)) {
      return dateFormat.format(utcStart);
    }
    return "${dateFormat.format(utcStart)} - ${dateFormat.format(utcEnd)}";
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isExpired ? 0.5 : 1,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          splashColor: Colors.grey.withAlpha(25),
          highlightColor: Colors.grey.withAlpha(15),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildImageCard(imageUrl),
                    const SizedBox(height: 8),
                    Text(
                      title.isNotEmpty ? title : "Judul Tidak Tersedia",
                      style: AppTextStyles.textStyleNormal.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      formatDateRange(startDate, endDate),
                      style: AppTextStyles.textStyleNormal.copyWith(
                        fontSize: 10,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
              if (isExpired)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFE5E5), // merah muda
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Event Berakhir",
                        style: AppTextStyles.textStyleNormal.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.redColor,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageCard(String? imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: imageUrl != null && imageUrl.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => _buildShimmerPlaceholder(),
                errorWidget: (context, url, error) => _buildErrorPlaceholder(),
              )
            : _buildErrorPlaceholder(),
      ),
    );
  }

  Widget _buildShimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[200]!,
      child: Container(
        width: double.infinity,
        color: Colors.white,
      ),
    );
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      width: double.infinity,
      color: Colors.grey[300],
      child: Image.asset(
        imageDefaultBanner,
        fit: BoxFit.cover,
      ),
    );
  }
}
