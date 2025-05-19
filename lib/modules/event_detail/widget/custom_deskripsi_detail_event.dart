part of '../view/event_detail_page.dart';

Widget _customLoadingContent() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildShimmerPlaceholder(),
      const SizedBox(height: 8),
      _buildShimmerPlaceholder(),
      const SizedBox(height: 8),
      _buildShimmerPlaceholder(),
    ],
  );
}

Widget _customDeskripsi(eventData) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eventData?.title ?? "",
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.justify,
          style: AppTextStyles.textStyleBold,
        ),
        const SizedBox(height: 10),

        // Lokasi
        Row(
          children: [
            const Icon(Icons.location_on, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                eventData?.address ?? "-",
                style: AppTextStyles.textStyleNormal.copyWith(
                  color: AppColors.greyColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),

        // Tanggal
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                "${_formatDate(eventData?.startDate)} - ${_formatDate(eventData?.endDate)}",
                style: AppTextStyles.textStyleNormal.copyWith(
                  color: AppColors.greyColor,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 5),

        // Jam
        Row(
          children: [
            const Icon(Icons.access_time, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Text(
              "${eventData?.start ?? "-"} - ${eventData?.end ?? "-"}",
              style: AppTextStyles.textStyleNormal.copyWith(
                color: AppColors.greyColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Deskripsi
        Text(
          eventData?.description ?? "",
          textAlign: TextAlign.justify,
          style: AppTextStyles.textStyleNormal,
        ),
      ],
    ),
  );
}

String _formatDate(String? dateString) {
  if (dateString == null) return "-";
  try {
    final date = DateTime.parse(dateString).toLocal();
    return DateFormat("EEEE, dd MMMM yyyy", "id").format(date);
  } catch (e) {
    return "-";
  }
}
