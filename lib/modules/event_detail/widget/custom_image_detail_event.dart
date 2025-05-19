part of '../view/event_detail_page.dart';

Widget _customDetailEvent(BuildContext context, String? imageUrl) {
  return Card(
    elevation: 4.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: imageUrl != null
          ? GestureDetector(
              onTap: () => _showFullImage(context, imageUrl),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                placeholder: (context, url) => _buildShimmerPlaceholder(),
                errorWidget: (context, url, error) => _buildErrorPlaceholder(),
              ),
            )
          : _buildErrorPlaceholder(),
    ),
  );
}

void _showFullImage(BuildContext context, String imageUrl) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CustomFullscreenPreview(imageUrl: imageUrl),
    ),
  );
}

Widget _buildShimmerPlaceholder() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[200]!,
    child: Container(
      width: double.infinity,
      height: 20,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
    ),
  );
}

Widget _buildErrorPlaceholder() {
  return Container(
    width: double.infinity,
    height: 200,
    color: Colors.grey[300],
    child: Center(
      child: Image.asset(
        imageDefaultBanner,
        width: 100,
        height: 100,
        fit: BoxFit.contain,
      ),
    ),
  );
}
