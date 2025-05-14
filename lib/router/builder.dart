import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../modules/login/view/login_page.dart';
import '../modules/news_detail/view/news_detail_page.dart';
import '../modules/register/view/register_page.dart';
import '../modules/register_ktp/view/register_ktp_page.dart';
import '../modules/webview/webview.dart';
import '../widgets/pages/about/about_us_page.dart';

import '../modules/home/view/home_page.dart';
import '../widgets/pages/media/view/media_page.dart';

part 'builder.g.dart';

@TypedGoRoute<HomeRoute>(path: '/home', routes: [
  TypedGoRoute<MediaRoute>(path: 'media'),
  TypedGoRoute<AboutRoute>(path: 'about'),
  TypedGoRoute<NewsDetailRoute>(path: 'news-detail'),
  TypedGoRoute<WebViewRoute>(path: 'webview'),
  TypedGoRoute<RegisterRoute>(path: 'register', routes: [
    TypedGoRoute<LoginRoute>(path: 'login'),
    TypedGoRoute<RegisterKtpRoute>(path: 'register-ktp'),
  ]),
])
class HomeRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return HomePage();
  }
}

class MediaRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MediaPage();
  }
}

class AboutRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AboutUsPage();
  }
}

class NewsDetailRoute extends GoRouteData {
  final int newsId;

  NewsDetailRoute({
    required this.newsId,
  });

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return NewsDetailPage(
      newsId: newsId,
    );
  }
}

class WebViewRoute extends GoRouteData {
  WebViewRoute({required this.url, required this.title});

  final String url;
  final String title;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return WebViewScreen(
      url: url,
      title: title,
    );
  }
}

class RegisterRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const RegisterPage();
  }
}

class LoginRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LoginPage();
  }
}

class RegisterKtpRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const RegisterKtpPage();
  }
}
