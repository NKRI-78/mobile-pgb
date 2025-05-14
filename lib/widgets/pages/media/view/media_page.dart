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
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 60.0),
        child: Center(
          child: Column(
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
              const SizedBox(height: 40),
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
            ],
          ),
        ),
      ),
    );
  }
}
