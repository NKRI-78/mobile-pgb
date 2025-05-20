import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shimmer/shimmer.dart';

import '../../../misc/date_helper.dart';
import '../../../misc/text_style.dart';
import '../../../misc/theme.dart';
import '../../../repositories/news_repository/models/news_detail_model.dart';
import '../../../router/builder.dart';
import '../../../widgets/photo_view/custom_fullscreen_preview.dart';
import '../cubit/news_detail_cubit.dart';

class NewsDetailPage extends StatelessWidget {
  const NewsDetailPage({
    super.key,
    required this.newsId,
  });

  final int newsId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NewsDetailCubit>(
      create: (context) => NewsDetailCubit()..fetchDetailNews(newsId),
      child: NewsDetailView(newsId: newsId),
    );
  }
}

class NewsDetailView extends StatelessWidget {
  const NewsDetailView({
    super.key,
    required this.newsId,
  });

  final int newsId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsDetailCubit, NewsDetailState>(
      builder: (context, state) {
        final newsData = state.news?.data;
        final imageUrl = newsData?.linkImage?.isNotEmpty == true
            ? newsData?.linkImage
            : null;

        return Scaffold(
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            title: Text(
              'News Detail',
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
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageCard(context, imageUrl),
                const SizedBox(height: 10),
                state.loading
                    ? _buildLoadingContent()
                    : _buildContent(context, state.news),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingContent() {
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

  Widget _buildContent(BuildContext context, DetailNewsModel? newsData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          newsData?.data?.title ?? "",
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.justify,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          DateHelper.formatFullDate(newsData?.data?.createdAt),
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        Html(
          data: formatHtmlContent(newsData?.data?.content),
          style: {
            "p": Style(
              margin: Margins.only(bottom: 12),
            ),
            "a": Style(
              color: Colors.blue,
              textDecoration: TextDecoration.underline,
            ),
          },
          onLinkTap: (url, attrs, element) {
            if (url != null) {
              WebViewRoute(url: url, title: "GEMA-MOBILE").push(context);
            }
          },
        ),
      ],
    );
  }

  String formatHtmlContent(String? content) {
    if (content == null || content.isEmpty) return "";

    final sanitized = content
        .replaceAll(RegExp(r'<p><br\s*/?></p>', caseSensitive: false), '')
        .replaceAll(RegExp(r'<p>(&nbsp;|\s)*</p>', caseSensitive: false), '');

    return sanitized;
  }

  Widget _buildImageCard(BuildContext context, String? imageUrl) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: imageUrl != null
            ? GestureDetector(
                onTap: () => _showFullImage(context, imageUrl),
                child: Hero(
                  tag: imageUrl,
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => _buildShimmerPlaceholder(),
                    errorWidget: (context, url, error) =>
                        _buildErrorPlaceholder(),
                  ),
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
}
