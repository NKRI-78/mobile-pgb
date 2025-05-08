import 'package:flutter/material.dart';
import '../../../misc/colors.dart';
import '../../../misc/text_style.dart';

class CustomNews extends StatelessWidget {
  const CustomNews({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      children: [
        _buildNewsSectionHeader(context),
        const SizedBox(height: 8),
        ...List.generate(5, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildNewsCard(
              imageUrl: 'assets/images/contoh_news.png',
              title:
                  'Partai Gema Bangsa Hadir sebagai Wadah Perjuangan Menuju Indonesia Mandiri',
              date: 'Pada Jumat, 17 Januari 2025',
              snippet: 'Sejumlah tokoh nasional, inisiator...',
            ),
          );
        }),
      ],
    );
  }

  Widget _buildNewsSectionHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('News', style: AppTextStyles.textStyleBold),
          InkWell(
            onTap: () {
              // todo: Implement the action for "Lihat Semuanya"
              debugPrint('Lihat semuanya ditekan');
            },
            child: Row(
              children: [
                Text(
                  'Lihat Semuanya',
                  style: AppTextStyles.textStyleNormal.copyWith(
                    color: AppColors.greyColor,
                  ),
                ),
                Icon(Icons.chevron_right, color: AppColors.greyColor, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsCard({
    required String imageUrl,
    required String title,
    required String date,
    required String snippet,
  }) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: Image.asset(
              imageUrl,
              width: 120,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$date\n$snippet',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: Colors.grey,
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
