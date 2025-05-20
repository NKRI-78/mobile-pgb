import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../modules/wallet/view/wallet_page.dart';

import '../modules/event/view/event_page.dart';
import '../modules/event_detail/view/event_detail_page.dart';
import '../modules/home/view/home_page.dart';
import '../modules/login/view/login_page.dart';
import '../modules/news_all/view/news_all_page.dart';
import '../modules/news_detail/view/news_detail_page.dart';
import '../modules/notification/view/detail/notification_detail_page.dart';
import '../modules/notification/view/detail/notification_ppob_detail_page.dart';
import '../modules/notification/view/notification_page.dart';
import '../modules/ppob/view/ppob_page.dart';
import '../modules/ppob/view/ppob_waiting_payment_page.dart';
import '../modules/profile/view/profile_page.dart';
import '../modules/register/view/register_page.dart';
import '../modules/register_akun/model/extrack_ktp_model.dart';
import '../modules/register_akun/view/register_akun_page.dart';
import '../modules/register_ktp/view/register_ktp_page.dart';
import '../modules/register_otp/view/register_otp_page.dart';
import '../modules/settings/view/settings_page.dart';
import '../modules/sos/view/sos_detail_page.dart';
import '../modules/sos/view/sos_page.dart';
import '../modules/webview/webview.dart';
import '../widgets/pages/about/about_us_page.dart';
import '../widgets/pages/media/view/media_page.dart';

part 'builder.g.dart';

@TypedGoRoute<HomeRoute>(path: '/home', routes: [
  TypedGoRoute<MediaRoute>(path: 'media'),
  TypedGoRoute<AboutRoute>(path: 'about'),
  TypedGoRoute<NewsDetailRoute>(path: 'news-detail'),
  TypedGoRoute<NewsAllRoute>(path: 'news-all'),
  TypedGoRoute<WebViewRoute>(path: 'webview'),
  TypedGoRoute<ProfileRoute>(path: 'profile'),
  TypedGoRoute<SettingsRoute>(path: 'settings'),
  TypedGoRoute<PpobPaymentRoute>(path: 'ppob-payment'),
  TypedGoRoute<PpobRoute>(path: 'ppob', routes: [
    TypedGoRoute<WalletRoute>(path: 'wallet'),
  ]),
  TypedGoRoute<NotificationRoute>(path: 'notification', routes: [
    TypedGoRoute<NotificationDetailRoute>(path: 'notification-detail'),
    TypedGoRoute<NotificationPpobRoute>(path: 'notification-ppob'),
  ]),
  TypedGoRoute<EventRoute>(path: 'event', routes: [
    TypedGoRoute<EventDetailRoute>(path: 'event-detail'),
  ]),
  TypedGoRoute<SosRoute>(path: 'sos', routes: [
    TypedGoRoute<SosDetailRoute>(path: 'sos-detail'),
  ]),
  TypedGoRoute<RegisterRoute>(path: 'register', routes: [
    TypedGoRoute<LoginRoute>(path: 'login'),
    TypedGoRoute<RegisterKtpRoute>(path: 'register-ktp', routes: [
      TypedGoRoute<RegisterAkunRoute>(path: 'register-akun', routes: [
        TypedGoRoute<RegisterOtpRoute>(path: 'register-otp'),
      ]),
    ]),
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

class NewsAllRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return NewsAllPage();
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

class ProfileRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ProfilePage();
  }
}

class SettingsRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return SettingsPage();
  }
}

class PpobPaymentRoute extends GoRouteData {
  final String paymentAccess;
  final double totalPayment;
  final String paymentCode;
  final String nameProduct;
  final String logoChannel;
  final DateTime paymentExpire;

  PpobPaymentRoute({
    required this.paymentAccess,
    required this.totalPayment,
    required this.paymentCode,
    required this.nameProduct,
    required this.logoChannel,
    required this.paymentExpire,
  });

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return PpobWaitingPaymentPage(
      paymentAccess: paymentAccess,
      totalPayment: totalPayment,
      paymentCode: paymentCode,
      nameProduct: nameProduct,
      logoChannel: logoChannel,
      paymentExpire: paymentExpire,
    );
  }
}

class PpobRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return PpobPage();
  }
}

class WalletRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return WalletPage();
  }
}

class NotificationRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const NotificationPage();
  }
}

class NotificationDetailRoute extends GoRouteData {
  final int idNotif;

  NotificationDetailRoute({required this.idNotif});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return NotificationDetailPage(
      idNotif: idNotif,
    );
  }
}

class NotificationPpobRoute extends GoRouteData {
  final int idNotif;

  NotificationPpobRoute({required this.idNotif});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return NotificationPpobDetailPage(
      idNotif: idNotif,
    );
  }
}

class RegisterRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const RegisterPage();
  }
}

class EventRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const EventPage();
  }
}

class EventDetailRoute extends GoRouteData {
  final int idEvent;

  EventDetailRoute({required this.idEvent});
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return EventDetailPage(
      idEvent: idEvent,
    );
  }
}

class SosRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SosPage();
  }
}

class SosDetailRoute extends GoRouteData {
  // final bool isLoggedIn;
  final String sosType;
  final String message;

  SosDetailRoute({
    // required this.isLoggedIn,
    required this.sosType,
    required this.message,
  });
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return SosDetailPage(
      message: message,
      sosType: sosType,
      // isLoggedIn: isLoggedIn,
    );
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

class RegisterAkunRoute extends GoRouteData {
  final ExtrackKtpModel $extra;

  RegisterAkunRoute({required this.$extra});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return RegisterAkunPage(
      extrackKtp: $extra,
    );
  }
}

class RegisterOtpRoute extends GoRouteData {
  final String email;
  final bool isLogin;
  final ExtrackKtpModel $extra;

  RegisterOtpRoute({
    required this.$extra,
    required this.email,
    required this.isLogin,
  });
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return RegisterOtpPage(
      isLogin: isLogin,
      email: email,
      extrackKtp: $extra,
    );
  }
}
