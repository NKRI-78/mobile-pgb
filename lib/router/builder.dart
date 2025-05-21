import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_pgb/modules/cart/view/cart_page.dart';
import 'package:mobile_pgb/modules/checkout/view/checkout_page.dart';
import 'package:mobile_pgb/modules/create_shipping_address/view/create_address_page.dart';
import 'package:mobile_pgb/modules/detail_product/view/detail_product_page.dart';
import 'package:mobile_pgb/modules/event/view/event_page.dart';
import 'package:mobile_pgb/modules/list_address/view/list_address_page.dart';
import 'package:mobile_pgb/modules/profile/view/profile_page.dart';
import 'package:mobile_pgb/modules/shop/view/shop_page.dart';
import 'package:mobile_pgb/modules/sos/view/sos_page.dart';
import 'package:mobile_pgb/modules/update_shipping_address/view/update_address_page.dart';
import 'package:mobile_pgb/modules/waiting_paymentv2/view/waiting_payment_page.dart';

import '../modules/event_detail/view/event_detail_page.dart';
import '../modules/home/view/home_page.dart';
import '../modules/login/view/login_page.dart';
import '../modules/news_all/view/news_all_page.dart';
import '../modules/news_detail/view/news_detail_page.dart';
import '../modules/register/view/register_page.dart';
import '../modules/register_akun/model/extrack_ktp_model.dart';
import '../modules/register_akun/view/register_akun_page.dart';
import '../modules/register_ktp/view/register_ktp_page.dart';
import '../modules/register_otp/view/register_otp_page.dart';
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
  TypedGoRoute<EventRoute>(path: 'event', routes: [
    TypedGoRoute<EventDetailRoute>(path: 'event-detail'),
  ]),
  TypedGoRoute<CheckoutRoute>(path: 'checkout',),
  TypedGoRoute<SosRoute>(path: 'sos'),
  TypedGoRoute<WaitingPaymentRoute>(path: 'waiting-method'),
  TypedGoRoute<ShopRoute>(path: 'shop', routes: [
    TypedGoRoute<DetailProductRoute>(path: "detail-prod" ,)
  ]),
  TypedGoRoute<AddressRoute>(path: 'address', routes: [
    TypedGoRoute<CreateAddressRoute>(path: 'create-address'),
    TypedGoRoute<UpdateAddressRoute>(path: 'update-address'),
  ]),
  TypedGoRoute<CartRoute>(path: 'cart'),
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

class ShopRoute extends GoRouteData {
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: const ShopPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: animation.drive(
            Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                .chain(CurveTween(curve: Curves.easeInOut)),
          ),
          child: child,
        );
      },
    );
  }
}

class DetailProductRoute extends GoRouteData {
  final String idProduct;

  DetailProductRoute({required this.idProduct});
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: DetailProductPage(idProduct: idProduct,),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: animation.drive(
            Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                .chain(CurveTween(curve: Curves.easeInOut)),
          ),
          child: child,
        );
      },
    );
  }
}

class CartRoute extends GoRouteData {
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: const CartPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: animation.drive(
            Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                .chain(CurveTween(curve: Curves.easeInOut)),
          ),
          child: child,
        );
      },
    );
  }
}

class CheckoutRoute extends GoRouteData {
  final String from;
  final String? qty;
  final String? productId;

  CheckoutRoute({this.from = "", this.qty, this.productId});

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: CheckoutPage(
        from: from,
        qty: qty,
        productId: productId,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: animation.drive(
            Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                .chain(CurveTween(curve: Curves.easeInOut)),
          ),
          child: child,
        );
      },
    );
  }
}

class AddressRoute extends GoRouteData {
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: const ListAddressPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: animation.drive(
            Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                .chain(CurveTween(curve: Curves.easeInOut)),
          ),
          child: child,
        );
      },
    );
  }
}

class CreateAddressRoute extends GoRouteData {
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: const CreateAddressPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: animation.drive(
            Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                .chain(CurveTween(curve: Curves.easeInOut)),
          ),
          child: child,
        );
      },
    );
  }
}

class UpdateAddressRoute extends GoRouteData {
  final String idAddress;

  UpdateAddressRoute({required this.idAddress});
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: UpdateAddressPage(idAddress: idAddress,),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: animation.drive(
            Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                .chain(CurveTween(curve: Curves.easeInOut)),
          ),
          child: child,
        );
      },
    );
  }
}

class WaitingPaymentRoute extends GoRouteData {
  final String id;
  final int? tabIndex;

  WaitingPaymentRoute({required this.id, this.tabIndex});
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: WaitingPaymentPage(id: id, tabIndex: tabIndex,),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: animation.drive(
            Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                .chain(CurveTween(curve: Curves.easeInOut)),
          ),
          child: child,
        );
      },
    );
  }
}
