import 'package:detectable_text_field/detectable_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_pgb/misc/colors.dart';
import 'package:mobile_pgb/misc/snackbar.dart';
import 'package:mobile_pgb/misc/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class DetectText extends StatelessWidget {
  final String text;
  final String? userid;
  final int? trimLength;
  const DetectText({super.key, required this.text, this.userid, this.trimLength});

  @override
  Widget build(BuildContext context) {
    
    return DetectableText(
        text: text,
        trimLines: 3,
        trimLength: trimLength ?? 300,
        trimExpandedText: ' Tampilkan Lebih Sedikit',
        trimCollapsedText: 'Baca selengkapnya',
        detectionRegExp: RegExp(r'[(http(s)?):\/\/(www\.)?a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)|@[a-zA-Z0-9_.]+?(?![a-zA-Z0-9_.]|[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$)'),
        detectedStyle:  TextStyle(
          color: AppColors.buttonBlueColor,
          fontSize: fontSizeDefault,
          fontFamily: 'SF Pro'
        ),
        basicStyle: const TextStyle(
          color: AppColors.whiteColor,
          fontSize: fontSizeDefault,
          fontWeight: FontWeight.w400,
          fontFamily: 'SF Pro'
        ),
        moreStyle: const TextStyle(
          color: AppColors.blueColor,
          fontSize: fontSizeDefault,
          fontFamily: 'SF Pro'
        ),
        lessStyle: const TextStyle(
          color: AppColors.blueColor,
          fontSize: fontSizeDefault,
          fontFamily: 'SF Pro'
        ),
        onTap: (tappedText){
          final email =  tappedText.contains(RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$'));
          final mention =  tappedText.contains(RegExp(r'^@[a-zA-Z0-9_.]+?(?![a-zA-Z0-9_.])'));
          debugPrint(tappedText);

          if (email) {
            launchEmailSubmission(tappedText, context);
          }else if(mention){
            return null;
          }  
          else{
            // WebViewScreenRoute(title: "ATJ-Mobile", url: tappedText.toLowerCase()).go(context);
          }
        },
    );
  }

  void launchEmailSubmission(String email, BuildContext context) async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(params)) {
      await launchUrl(params);
    } else {
      await Clipboard.setData(ClipboardData(text: email));
      // ignore: use_build_context_synchronously
      ShowSnackbar.snackbar(context, "Content copied to clipboard", isSuccess: false);
      debugPrint('Could not launch $params');
    }
  }
}