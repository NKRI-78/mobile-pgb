import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../../router/builder.dart';
import '../cubit/about_cubit.dart';
import '../../../widgets/pages/loading_page.dart';

import '../../../misc/colors.dart';
import '../../../misc/text_style.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AboutCubit()..fetchAboutUs(),
      child: AboutUsView(),
    );
  }
}

class AboutUsView extends StatelessWidget {
  const AboutUsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AboutCubit, AboutState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            title: Text(
              'Tentang Partai',
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
          body: state.isLoading
              ? Center(
                  child: CustomLoadingPage(),
                )
              : SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          color: AppColors.buttonBlueColor,
                          child: Image.asset(
                            'assets/images/logo_transparant.png',
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 10),
                        Html(
                          data: state.about?.aboutUs ?? '',
                          style: {
                            "p": Style(
                              fontSize: FontSize(14),
                              margin: Margins.only(bottom: 12),
                            ),
                            "p[style*='margin-left: 2rem']": Style(
                              margin: Margins.only(left: 20, bottom: 12),
                            ),
                            "ul": Style(
                                margin: Margins.only(bottom: 12, left: 10),
                                padding: HtmlPaddings.all(0)),
                            "ol": Style(
                                margin: Margins.only(bottom: 12, left: 30),
                                padding: HtmlPaddings.all(0)),
                            "li": Style(
                              fontSize: FontSize(14),
                              margin: Margins.only(bottom: 6, left: 6),
                            ),
                            "a": Style(
                                color: Colors.blue,
                                textDecoration: TextDecoration.underline),
                            "strong": Style(fontWeight: FontWeight.bold),
                          },
                          onLinkTap: (url, _, __) {
                            if (url != null) {
                              WebViewRoute(url: url, title: "PGB-MOBILE")
                                  .push(context);
                            }
                          },
                        ),
                        SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}
