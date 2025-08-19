import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../misc/colors.dart';
import '../../../misc/text_style.dart';
import '../../../misc/theme.dart';

class CustomNews extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String content;
  final VoidCallback onTap;

  const CustomNews({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.content,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.only(right: 18, left: 18, bottom: 10, top: 10),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: SizedBox(
          width: double.infinity,
          height: 110,
          child: Row(
            children: [
              _NewsImage(imageUrl: imageUrl),
              const SizedBox(width: 5),
              _NewsContent(title: title, content: content),
            ],
          ),
        ),
      ),
    );
  }
}

class _NewsImage extends StatelessWidget {
  final String imageUrl;

  const _NewsImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: 170,
        height: 110,
        fit: BoxFit.cover,
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: 170,
            height: 110,
            color: Colors.grey[300],
          ),
        ),
        errorWidget: (context, url, error) {
          return Image.asset(
            imageDefaultBanner,
            width: 170,
            height: 110,
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}

class _NewsContent extends StatelessWidget {
  final String title;
  final String content;

  const _NewsContent({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              title,
              style: AppTextStyles.textStyleBold.copyWith(
                fontSize: 12,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              content.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ""),
              maxLines: 3,
              style: AppTextStyles.textStyleNormal.copyWith(
                fontSize: 10,
                color: AppColors.greyColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
