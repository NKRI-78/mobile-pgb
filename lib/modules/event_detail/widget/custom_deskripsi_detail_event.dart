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

Widget _customDeskripsi(BuildContext context, eventData) {
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
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                _formatDateRange(eventData?.startDate, eventData?.endDate),
                style: AppTextStyles.textStyleNormal.copyWith(
                  color: AppColors.greyColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.access_time, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                "${eventData?.start ?? "-"} - ${eventData?.end ?? "-"}",
                style: AppTextStyles.textStyleNormal.copyWith(
                  color: AppColors.greyColor,
                ),
              ),
            ),
          ],
        ),
        if ((eventData?.userJoins?.isNotEmpty ?? false)) ...[
          const SizedBox(height: 5),
          Align(
            alignment: Alignment.centerLeft,
            child: Builder(builder: (context) {
              final isLoggedIn = getIt<AppBloc>().state.user != null;

              if (!isLoggedIn) return const SizedBox.shrink();
              return TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.buttonBlueColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    builder: (_) => Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 5,
                            width: 50,
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          Text(
                            "Peserta Bergabung",
                            style: AppTextStyles.textStyleBold,
                          ),
                          const SizedBox(height: 16),
                          CustomUserJoinedList(
                            users: eventData!.userJoins!,
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: Text(
                  "Lihat Peserta",
                  style: AppTextStyles.textStyleNormal
                      .copyWith(color: AppColors.whiteColor, letterSpacing: 1),
                ),
              );
            }),
          ),
        ],
        const SizedBox(height: 10),
        Linkify(
          text: eventData?.description ?? "",
          textAlign: TextAlign.justify,
          style: AppTextStyles.textStyleNormal,
          linkStyle: const TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
          onOpen: (link) async {
            final uri = Uri.parse(link.url);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            } else {
              debugPrint("Tidak bisa membuka link: ${link.url}");
            }
          },
        )
      ],
    ),
  );
}

String _formatDateRange(String? startDate, String? endDate) {
  if (startDate == null || endDate == null) return "-";
  try {
    final start = DateTime.parse(startDate).toUtc();
    final end = DateTime.parse(endDate).toUtc();
    final formatter = DateFormat("EEEE, dd MMMM yyyy", "id");

    final formattedStart = formatter.format(start);
    final formattedEnd = formatter.format(end);

    if (formattedStart == formattedEnd) {
      return formattedStart;
    }

    return "$formattedStart - $formattedEnd";
  } catch (e) {
    return "-";
  }
}
