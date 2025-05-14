import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
        placeholder: (context, url) =>
            const Center(child: CircularProgressIndicator()),
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
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              content.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ""),
              maxLines: 2,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
