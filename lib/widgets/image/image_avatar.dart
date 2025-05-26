import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../misc/theme.dart';

class ImageAvatar extends StatelessWidget {
  final String image;
  final double radius;
  const ImageAvatar({super.key, required this.image, required this.radius});

  @override
  Widget build(BuildContext context) {
    if (image.isEmpty || image == 'null') {
      // jika URL kosong atau "null" (string literal), tampilkan gambar default
      return CircleAvatar(
        radius: radius,
        backgroundImage: const AssetImage(imageDefaultUser),
      );
    }

    return CachedNetworkImage(
      imageUrl: image,
      imageBuilder: (context, imageProvider) => CircleAvatar(
        radius: radius,
        backgroundImage: imageProvider,
      ),
      placeholder: (context, url) => CircleAvatar(
        radius: radius,
        backgroundColor: const Color(0xFF637687),
      ),
      errorWidget: (context, url, error) => CircleAvatar(
        radius: radius,
        backgroundImage: const AssetImage(imageDefaultUser),
      ),
    );
  }
}
