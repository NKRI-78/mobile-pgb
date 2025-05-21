import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../misc/text_style.dart';
import '../widget/custom_card_media.dart';

class MediaPage extends StatelessWidget {
  const MediaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Media',
          style: AppTextStyles.textStyleBold,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          physics: NeverScrollableScrollPhysics(),
          clipBehavior: Clip.hardEdge,
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: 1,
          children: [
            CustomCardMedia(
              label: 'Facebook',
              iconAssetPath: 'assets/icons/facebook.png',
              onTap: () async {
                final Uri url =
                    Uri.parse('https://www.facebook.com/partaigemabangsa');
                try {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                } catch (e) {
                  debugPrint('Error launching URL: $e');
                }
              },
            ),
            CustomCardMedia(
              label: 'Instagram',
              iconAssetPath: 'assets/icons/instagram.png',
              onTap: () async {
                final Uri url =
                    Uri.parse('https://www.instagram.com/partaigemabangsa');
                try {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                } catch (e) {
                  debugPrint('Error launching URL: $e');
                }
              },
            ),
            CustomCardMedia(
              label: 'Tiktok',
              iconAssetPath: 'assets/icons/tiktok.png',
              onTap: () async {
                final Uri url = Uri.parse('https://www.tiktok.com/@gemabangsa');
                try {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                } catch (e) {
                  debugPrint('Error launching URL: $e');
                }
              },
            ),
            CustomCardMedia(
              label: 'Youtube',
              iconAssetPath: 'assets/icons/yt.png',
              onTap: () async {
                final Uri url = Uri.parse(
                    'https://www.youtube.com/@PartaiGemaBangsaOfficial');
                try {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                } catch (e) {
                  debugPrint('Error launching URL: $e');
                }
              },
            ),
            CustomCardMedia(
              label: 'X',
              iconAssetPath: 'assets/icons/x.png',
              onTap: () async {
                final Uri url = Uri.parse('https://x.com/p_gemabangsa?s=11');
                try {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                } catch (e) {
                  debugPrint('Error launching URL: $e');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
