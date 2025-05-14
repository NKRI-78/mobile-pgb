import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../misc/colors.dart';

import '../../misc/text_style.dart';

class CustomFullscreenPreview extends StatelessWidget {
  final String imageUrl;
  final String title;

  const CustomFullscreenPreview({
    super.key,
    required this.imageUrl,
    this.title = "Gambar",
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(title,
            style: AppTextStyles.textStyleBold.copyWith(
              color: AppColors.whiteColor,
            )),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 3.0,
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.contain,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) =>
                const Icon(Icons.broken_image, size: 100, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
