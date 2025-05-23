import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_pgb/modules/cart/view/cart_page.dart';
import 'package:mobile_pgb/modules/checkout/view/checkout_page.dart';
import 'package:mobile_pgb/modules/create_shipping_address/view/create_address_page.dart';
import 'package:mobile_pgb/modules/detail_oder/view/detail_order.dart';
import 'package:mobile_pgb/modules/detail_product/view/detail_product_page.dart';
import 'package:mobile_pgb/modules/event/view/event_page.dart';
import 'package:mobile_pgb/modules/list_address/view/list_address_page.dart';
import 'package:mobile_pgb/modules/need_riview/views/need_riview_page.dart';
import 'package:mobile_pgb/modules/order/view/order_page.dart';
import 'package:mobile_pgb/modules/profile/view/profile_page.dart';
import 'package:mobile_pgb/modules/shop/view/shop_page.dart';
import 'package:mobile_pgb/modules/show_more_testimoni/view/show_more_testimoni.dart';
import 'package:mobile_pgb/modules/sos/view/sos_page.dart';
import 'package:mobile_pgb/modules/tracking/view/tracking_page.dart';
import 'package:mobile_pgb/modules/update_shipping_address/view/update_address_page.dart';
import 'package:mobile_pgb/modules/waiting_paymentv2/view/waiting_payment_page.dart';
import 'package:mobile_pgb/repositories/oder_repository/models/tracking_model.dart';
import 'package:mobile_pgb/repositories/shop_repository/models/detail_product_model.dart';
import 'package:mobile_pgb/widgets/pages/page_detail_proof_shipping.dart';

import '../modules/event_detail/view/event_detail_page.dart';
import '../modules/forum/view/forum_page.dart';
import '../modules/forum_create/view/forum_create_page.dart';
import '../modules/forum_detail/view/forum_detail_page.dart';
import '../modules/home/view/home_page.dart';
import '../modules/login/view/login_page.dart';
import '../modules/lupa_password/view/lupa_password_page.dart';
import '../modules/lupa_password_change/view/lupa_password_change.dart';
import '../modules/lupa_password_otp/view/lupa_password_otp.dart';
import '../modules/news_all/view/news_all_page.dart';
import '../modules/news_detail/view/news_detail_page.dart';
import '../modules/notification/view/detail/notification_detail_page.dart';
import '../modules/notification/view/detail/notification_ppob_detail_page.dart';
import '../modules/notification/view/notification_page.dart';
import '../modules/ppob/view/ppob_page.dart';
import '../modules/ppob/view/ppob_waiting_payment_page.dart';
import '../modules/profile_update/view/profile_update_page.dart';
import '../modules/register/view/register_page.dart';
import '../modules/register_akun/model/extrack_ktp_model.dart';
import '../modules/register_akun/view/register_akun_page.dart';
import '../modules/register_ktp/view/register_ktp_page.dart';
import '../modules/register_otp/view/register_otp_page.dart';
import '../modules/settings/view/settings_page.dart';
import '../modules/sos/view/sos_detail_page.dart';
import '../modules/waiting_payment/view/waiting_payment_page.dart';
import '../modules/wallet/view/wallet_page.dart';
import '../modules/webview/webview.dart';
import '../widgets/pages/about/about_us_page.dart';
import '../widgets/pages/media/view/media_page.dart';
import '../widgets/pages/video/detail_video_player.dart';
import '../widgets/photo_view/clipped_photo_view.dart';

part 'builder.g.dart';

@TypedGoRoute<HomeRoute>(path: '/home', routes: [
  TypedGoRoute<ForumRoute>(path: 'forum', routes: [
    TypedGoRoute<ForumDetailRoute>(path: 'forum-detail'),
    TypedGoRoute<ForumCreateRoute>(path: 'forum-create'),
    TypedGoRoute<ClippedPhotoRoute>(path: 'clipped-photo'),
    TypedGoRoute<DetailVideoPlayerRoute>(path: 'detail-video'),
  ]),
  TypedGoRoute<MediaRoute>(path: 'media'),
  TypedGoRoute<AboutRoute>(path: 'about'),
  TypedGoRoute<NewsDetailRoute>(path: 'news-detail'),
  TypedGoRoute<NewsAllRoute>(path: 'news-all'),
  TypedGoRoute<WebViewRoute>(path: 'webview'),
  TypedGoRoute<ProfileRoute>(path: 'profile', routes: [
    TypedGoRoute<ProfileUpdateRoute>(path: 'profile-update'),
  ]),
  TypedGoRoute<SettingsRoute>(path: 'settings'),
  TypedGoRoute<PpobPaymentRoute>(path: 'ppob-payment'),
  TypedGoRoute<WaitingPaymentRoute>(path: 'waiting-payment'),
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
  TypedGoRoute<CheckoutRoute>(
    path: 'checkout',
  ),
  TypedGoRoute<SosRoute>(path: 'sos'),
  TypedGoRoute<WaitingPaymentV2Route>(path: 'waiting-method'),
  TypedGoRoute<ShopRoute>(path: 'shop', routes: [
    TypedGoRoute<DetailProductRoute>(path: "detail-prod", routes: [
      TypedGoRoute<ShowMoreTestimoniRoute>(path: 'show-more-testimoni'),
    ])
  ]),
  TypedGoRoute<AddressRoute>(path: 'address', routes: [
    TypedGoRoute<CreateAddressRoute>(path: 'create-address'),
    TypedGoRoute<UpdateAddressRoute>(path: 'update-address'),
  ]),
  TypedGoRoute<CartRoute>(path: 'cart'),
  TypedGoRoute<SosRoute>(path: 'sos', routes: [
    TypedGoRoute<SosDetailRoute>(path: 'sos-detail'),
  ]),
  TypedGoRoute<RegisterRoute>(path: 'register', routes: [
    TypedGoRoute<LoginRoute>(
      path: 'login',
      routes: [
        TypedGoRoute<LupaPasswordRoute>(path: 'lupa-password', routes: [
          TypedGoRoute<LupaPasswordOtpRoute>(
              path: 'lupa-password-otp',
              routes: [
                TypedGoRoute<LupaPasswordChangeRoute>(
                    path: 'lupa-password-change'),
              ])
        ]),
      ],
    ),
    TypedGoRoute<RegisterKtpRoute>(path: 'register-ktp', routes: [
      TypedGoRoute<RegisterAkunRoute>(path: 'register-akun', routes: [
        TypedGoRoute<RegisterOtpRoute>(path: 'register-otp'),
      ]),
    ]),
  ]),
  TypedGoRoute<OrderRoute>(path: 'my-order', routes: [
    TypedGoRoute<DetailOrderRoute>(path: 'order-detail', routes: [
      TypedGoRoute<TrackingRoute>(path: 'tracking', routes: [
        TypedGoRoute<PageDetailProofShippingRoute>(path: 'detail-proff'),
      ]),
    ]),
  ]),
  TypedGoRoute<NeedRiviewRoute>(path: "need-riview"),
])
class HomeRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return HomePage();
  }
}

class ForumRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ForumPage();
  }
}

class ForumDetailRoute extends GoRouteData {
  final String idForum;

  ForumDetailRoute({required this.idForum});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ForumDetailPage(idForum: idForum);
  }
}

class ForumCreateRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ForumCreatePage();
  }
}

class ClippedPhotoRoute extends GoRouteData {
  final int idForum;
  final int? indexPhoto;

  ClippedPhotoRoute({required this.idForum, this.indexPhoto});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ClippedPhotoPage(
      idForum: idForum,
      indexPhoto: indexPhoto ?? 0,
    );
  }
}

class DetailVideoPlayerRoute extends GoRouteData {
  final String urlVideo;

  DetailVideoPlayerRoute({required this.urlVideo});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DetailVideoPlayer(urlVideo: urlVideo);
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

class ProfileUpdateRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ProfileUpdatePage();
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

class WaitingPaymentRoute extends GoRouteData {
  final String id;

  WaitingPaymentRoute({required this.id});
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return WaitingPaymentPage(
      id: id,
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

class LupaPasswordRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return LupaPasswordPage();
  }
}

class LupaPasswordOtpRoute extends GoRouteData {
  final String email;

  LupaPasswordOtpRoute({required this.email});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return LupaPasswordOtpPage(email: email);
  }
}

class LupaPasswordChangeRoute extends GoRouteData {
  final String email;
  final String otp;

  LupaPasswordChangeRoute({required this.email, required this.otp});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return LupaPasswordChangePage(email: email, otp: otp);
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
      child: DetailProductPage(
        idProduct: idProduct,
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
      child: UpdateAddressPage(
        idAddress: idAddress,
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

class WaitingPaymentV2Route extends GoRouteData {
  final String id;
  final int? tabIndex;

  WaitingPaymentV2Route({required this.id, this.tabIndex});
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: WaitingPaymentV2Page(
        id: id,
        tabIndex: tabIndex,
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

class OrderRoute extends GoRouteData {
  final int initIndex;

  OrderRoute({required this.initIndex});
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return OrderPage(
      initIndex: initIndex,
    );
  }
}

class DetailOrderRoute extends GoRouteData {
  final int idOrder;
  final int initIndex;

  DetailOrderRoute({required this.idOrder, required this.initIndex});
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DetailOrderPage(
      idOrder: idOrder,
      initIndex: initIndex,
    );
  }
}

class TrackingRoute extends GoRouteData {
  final String noTracking;
  final String store;
  final int initIndex;
  final int idOrder;

  TrackingRoute({
    required this.noTracking,
    required this.store,
    required this.initIndex,
    required this.idOrder,
  });
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return TrackingPage(
      noTracking: noTracking,
      store: store,
      idOrder: idOrder,
      initIndex: initIndex,
    );
  }
}

class PageDetailProofShippingRoute extends GoRouteData {
  final TrackingModel $extra;
  final int initIndex;
  final int idOrder;
  final String noTracking;
  final String store;

  PageDetailProofShippingRoute({
    required this.$extra,
    required this.initIndex,
    required this.idOrder,
    required this.noTracking,
    required this.store,
  });

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return PageDetailProofShipping(
      tracking: $extra,
    );
  }
}

class NeedRiviewRoute extends GoRouteData {
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: const NeedRiviewPage(),
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

class ShowMoreTestimoniRoute extends GoRouteData {
  final String idProduct;
  final List<Reviews> $extra;

  ShowMoreTestimoniRoute({required this.idProduct, required this.$extra});
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: ShowMoreTesttimoniPage(
        idProduct: idProduct,
        reviews: $extra,
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
