// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'builder.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $homeRoute,
    ];

RouteBase get $homeRoute => GoRouteData.$route(
      path: '/home',
      factory: $HomeRouteExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: 'forum',
          factory: $ForumRouteExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: 'forum-detail',
              factory: $ForumDetailRouteExtension._fromState,
            ),
            GoRouteData.$route(
              path: 'forum-create',
              factory: $ForumCreateRouteExtension._fromState,
            ),
            GoRouteData.$route(
              path: 'clipped-photo',
              factory: $ClippedPhotoRouteExtension._fromState,
            ),
            GoRouteData.$route(
              path: 'detail-video',
              factory: $DetailVideoPlayerRouteExtension._fromState,
            ),
          ],
        ),
        GoRouteData.$route(
          path: 'media',
          factory: $MediaRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'about',
          factory: $AboutRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'news-detail',
          factory: $NewsDetailRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'news-all',
          factory: $NewsAllRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'webview',
          factory: $WebViewRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'profile',
          factory: $ProfileRouteExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: 'profile-update',
              factory: $ProfileUpdateRouteExtension._fromState,
            ),
          ],
        ),
        GoRouteData.$route(
          path: 'settings',
          factory: $SettingsRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'ppob-payment',
          factory: $PpobPaymentRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'waiting-payment',
          factory: $WaitingPaymentRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'ppob',
          factory: $PpobRouteExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: 'wallet',
              factory: $WalletRouteExtension._fromState,
            ),
          ],
        ),
        GoRouteData.$route(
          path: 'notification',
          factory: $NotificationRouteExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: 'notification-detail',
              factory: $NotificationDetailRouteExtension._fromState,
            ),
            GoRouteData.$route(
              path: 'notification-ppob',
              factory: $NotificationPpobRouteExtension._fromState,
            ),
          ],
        ),
        GoRouteData.$route(
          path: 'event',
          factory: $EventRouteExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: 'event-detail',
              factory: $EventDetailRouteExtension._fromState,
            ),
          ],
        ),
        GoRouteData.$route(
          path: 'checkout',
          factory: $CheckoutRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'sos',
          factory: $SosRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'waiting-method',
          factory: $WaitingPaymentV2RouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'shop',
          factory: $ShopRouteExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: 'detail-prod',
              factory: $DetailProductRouteExtension._fromState,
              routes: [
                GoRouteData.$route(
                  path: 'show-more-testimoni',
                  factory: $ShowMoreTestimoniRouteExtension._fromState,
                ),
              ],
            ),
          ],
        ),
        GoRouteData.$route(
          path: 'address',
          factory: $AddressRouteExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: 'create-address',
              factory: $CreateAddressRouteExtension._fromState,
            ),
            GoRouteData.$route(
              path: 'update-address',
              factory: $UpdateAddressRouteExtension._fromState,
            ),
          ],
        ),
        GoRouteData.$route(
          path: 'cart',
          factory: $CartRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'sos',
          factory: $SosRouteExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: 'sos-detail',
              factory: $SosDetailRouteExtension._fromState,
            ),
          ],
        ),
        GoRouteData.$route(
          path: 'register',
          factory: $RegisterRouteExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: 'login',
              factory: $LoginRouteExtension._fromState,
              routes: [
                GoRouteData.$route(
                  path: 'lupa-password',
                  factory: $LupaPasswordRouteExtension._fromState,
                  routes: [
                    GoRouteData.$route(
                      path: 'lupa-password-otp',
                      factory: $LupaPasswordOtpRouteExtension._fromState,
                      routes: [
                        GoRouteData.$route(
                          path: 'lupa-password-change',
                          factory: $LupaPasswordChangeRouteExtension._fromState,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            GoRouteData.$route(
              path: 'register-ktp',
              factory: $RegisterKtpRouteExtension._fromState,
              routes: [
                GoRouteData.$route(
                  path: 'register-akun',
                  factory: $RegisterAkunRouteExtension._fromState,
                  routes: [
                    GoRouteData.$route(
                      path: 'register-otp',
                      factory: $RegisterOtpRouteExtension._fromState,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        GoRouteData.$route(
          path: 'my-order',
          factory: $OrderRouteExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: 'order-detail',
              factory: $DetailOrderRouteExtension._fromState,
              routes: [
                GoRouteData.$route(
                  path: 'tracking',
                  factory: $TrackingRouteExtension._fromState,
                  routes: [
                    GoRouteData.$route(
                      path: 'detail-proff',
                      factory:
                          $PageDetailProofShippingRouteExtension._fromState,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        GoRouteData.$route(
          path: 'need-riview',
          factory: $NeedRiviewRouteExtension._fromState,
        ),
      ],
    );

extension $HomeRouteExtension on HomeRoute {
  static HomeRoute _fromState(GoRouterState state) => HomeRoute();

  String get location => GoRouteData.$location(
        '/home',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ForumRouteExtension on ForumRoute {
  static ForumRoute _fromState(GoRouterState state) => ForumRoute();

  String get location => GoRouteData.$location(
        '/home/forum',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ForumDetailRouteExtension on ForumDetailRoute {
  static ForumDetailRoute _fromState(GoRouterState state) => ForumDetailRoute(
        idForum: state.uri.queryParameters['id-forum']!,
      );

  String get location => GoRouteData.$location(
        '/home/forum/forum-detail',
        queryParams: {
          'id-forum': idForum,
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ForumCreateRouteExtension on ForumCreateRoute {
  static ForumCreateRoute _fromState(GoRouterState state) => ForumCreateRoute();

  String get location => GoRouteData.$location(
        '/home/forum/forum-create',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ClippedPhotoRouteExtension on ClippedPhotoRoute {
  static ClippedPhotoRoute _fromState(GoRouterState state) => ClippedPhotoRoute(
        idForum: int.parse(state.uri.queryParameters['id-forum']!)!,
        indexPhoto: _$convertMapValue(
            'index-photo', state.uri.queryParameters, int.tryParse),
      );

  String get location => GoRouteData.$location(
        '/home/forum/clipped-photo',
        queryParams: {
          'id-forum': idForum.toString(),
          if (indexPhoto != null) 'index-photo': indexPhoto!.toString(),
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $DetailVideoPlayerRouteExtension on DetailVideoPlayerRoute {
  static DetailVideoPlayerRoute _fromState(GoRouterState state) =>
      DetailVideoPlayerRoute(
        urlVideo: state.uri.queryParameters['url-video']!,
      );

  String get location => GoRouteData.$location(
        '/home/forum/detail-video',
        queryParams: {
          'url-video': urlVideo,
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $MediaRouteExtension on MediaRoute {
  static MediaRoute _fromState(GoRouterState state) => MediaRoute();

  String get location => GoRouteData.$location(
        '/home/media',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $AboutRouteExtension on AboutRoute {
  static AboutRoute _fromState(GoRouterState state) => AboutRoute();

  String get location => GoRouteData.$location(
        '/home/about',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $NewsDetailRouteExtension on NewsDetailRoute {
  static NewsDetailRoute _fromState(GoRouterState state) => NewsDetailRoute(
        newsId: int.parse(state.uri.queryParameters['news-id']!)!,
      );

  String get location => GoRouteData.$location(
        '/home/news-detail',
        queryParams: {
          'news-id': newsId.toString(),
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $NewsAllRouteExtension on NewsAllRoute {
  static NewsAllRoute _fromState(GoRouterState state) => NewsAllRoute();

  String get location => GoRouteData.$location(
        '/home/news-all',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $WebViewRouteExtension on WebViewRoute {
  static WebViewRoute _fromState(GoRouterState state) => WebViewRoute(
        url: state.uri.queryParameters['url']!,
        title: state.uri.queryParameters['title']!,
      );

  String get location => GoRouteData.$location(
        '/home/webview',
        queryParams: {
          'url': url,
          'title': title,
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ProfileRouteExtension on ProfileRoute {
  static ProfileRoute _fromState(GoRouterState state) => ProfileRoute();

  String get location => GoRouteData.$location(
        '/home/profile',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ProfileUpdateRouteExtension on ProfileUpdateRoute {
  static ProfileUpdateRoute _fromState(GoRouterState state) =>
      ProfileUpdateRoute();

  String get location => GoRouteData.$location(
        '/home/profile/profile-update',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $SettingsRouteExtension on SettingsRoute {
  static SettingsRoute _fromState(GoRouterState state) => SettingsRoute();

  String get location => GoRouteData.$location(
        '/home/settings',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $PpobPaymentRouteExtension on PpobPaymentRoute {
  static PpobPaymentRoute _fromState(GoRouterState state) => PpobPaymentRoute(
        paymentAccess: state.uri.queryParameters['payment-access']!,
        totalPayment:
            double.parse(state.uri.queryParameters['total-payment']!)!,
        paymentCode: state.uri.queryParameters['payment-code']!,
        nameProduct: state.uri.queryParameters['name-product']!,
        logoChannel: state.uri.queryParameters['logo-channel']!,
        paymentExpire:
            DateTime.parse(state.uri.queryParameters['payment-expire']!)!,
      );

  String get location => GoRouteData.$location(
        '/home/ppob-payment',
        queryParams: {
          'payment-access': paymentAccess,
          'total-payment': totalPayment.toString(),
          'payment-code': paymentCode,
          'name-product': nameProduct,
          'logo-channel': logoChannel,
          'payment-expire': paymentExpire.toString(),
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $WaitingPaymentRouteExtension on WaitingPaymentRoute {
  static WaitingPaymentRoute _fromState(GoRouterState state) =>
      WaitingPaymentRoute(
        id: state.uri.queryParameters['id']!,
      );

  String get location => GoRouteData.$location(
        '/home/waiting-payment',
        queryParams: {
          'id': id,
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $PpobRouteExtension on PpobRoute {
  static PpobRoute _fromState(GoRouterState state) => PpobRoute();

  String get location => GoRouteData.$location(
        '/home/ppob',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $WalletRouteExtension on WalletRoute {
  static WalletRoute _fromState(GoRouterState state) => WalletRoute();

  String get location => GoRouteData.$location(
        '/home/ppob/wallet',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $NotificationRouteExtension on NotificationRoute {
  static NotificationRoute _fromState(GoRouterState state) =>
      NotificationRoute();

  String get location => GoRouteData.$location(
        '/home/notification',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $NotificationDetailRouteExtension on NotificationDetailRoute {
  static NotificationDetailRoute _fromState(GoRouterState state) =>
      NotificationDetailRoute(
        idNotif: int.parse(state.uri.queryParameters['id-notif']!)!,
      );

  String get location => GoRouteData.$location(
        '/home/notification/notification-detail',
        queryParams: {
          'id-notif': idNotif.toString(),
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $NotificationPpobRouteExtension on NotificationPpobRoute {
  static NotificationPpobRoute _fromState(GoRouterState state) =>
      NotificationPpobRoute(
        idNotif: int.parse(state.uri.queryParameters['id-notif']!)!,
      );

  String get location => GoRouteData.$location(
        '/home/notification/notification-ppob',
        queryParams: {
          'id-notif': idNotif.toString(),
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $EventRouteExtension on EventRoute {
  static EventRoute _fromState(GoRouterState state) => EventRoute();

  String get location => GoRouteData.$location(
        '/home/event',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $EventDetailRouteExtension on EventDetailRoute {
  static EventDetailRoute _fromState(GoRouterState state) => EventDetailRoute(
        idEvent: int.parse(state.uri.queryParameters['id-event']!)!,
      );

  String get location => GoRouteData.$location(
        '/home/event/event-detail',
        queryParams: {
          'id-event': idEvent.toString(),
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $CheckoutRouteExtension on CheckoutRoute {
  static CheckoutRoute _fromState(GoRouterState state) => CheckoutRoute(
        from: state.uri.queryParameters['from'] ?? "",
        qty: state.uri.queryParameters['qty'],
        productId: state.uri.queryParameters['product-id'],
      );

  String get location => GoRouteData.$location(
        '/home/checkout',
        queryParams: {
          if (from != "") 'from': from,
          if (qty != null) 'qty': qty,
          if (productId != null) 'product-id': productId,
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $SosRouteExtension on SosRoute {
  static SosRoute _fromState(GoRouterState state) => SosRoute();

  String get location => GoRouteData.$location(
        '/home/sos',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $WaitingPaymentV2RouteExtension on WaitingPaymentV2Route {
  static WaitingPaymentV2Route _fromState(GoRouterState state) =>
      WaitingPaymentV2Route(
        id: state.uri.queryParameters['id']!,
        tabIndex: _$convertMapValue(
            'tab-index', state.uri.queryParameters, int.tryParse),
      );

  String get location => GoRouteData.$location(
        '/home/waiting-method',
        queryParams: {
          'id': id,
          if (tabIndex != null) 'tab-index': tabIndex!.toString(),
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ShopRouteExtension on ShopRoute {
  static ShopRoute _fromState(GoRouterState state) => ShopRoute();

  String get location => GoRouteData.$location(
        '/home/shop',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $DetailProductRouteExtension on DetailProductRoute {
  static DetailProductRoute _fromState(GoRouterState state) =>
      DetailProductRoute(
        idProduct: state.uri.queryParameters['id-product']!,
      );

  String get location => GoRouteData.$location(
        '/home/shop/detail-prod',
        queryParams: {
          'id-product': idProduct,
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ShowMoreTestimoniRouteExtension on ShowMoreTestimoniRoute {
  static ShowMoreTestimoniRoute _fromState(GoRouterState state) =>
      ShowMoreTestimoniRoute(
        idProduct: state.uri.queryParameters['id-product']!,
        $extra: state.extra as List<Reviews>,
      );

  String get location => GoRouteData.$location(
        '/home/shop/detail-prod/show-more-testimoni',
        queryParams: {
          'id-product': idProduct,
        },
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

extension $AddressRouteExtension on AddressRoute {
  static AddressRoute _fromState(GoRouterState state) => AddressRoute();

  String get location => GoRouteData.$location(
        '/home/address',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $CreateAddressRouteExtension on CreateAddressRoute {
  static CreateAddressRoute _fromState(GoRouterState state) =>
      CreateAddressRoute();

  String get location => GoRouteData.$location(
        '/home/address/create-address',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $UpdateAddressRouteExtension on UpdateAddressRoute {
  static UpdateAddressRoute _fromState(GoRouterState state) =>
      UpdateAddressRoute(
        idAddress: state.uri.queryParameters['id-address']!,
      );

  String get location => GoRouteData.$location(
        '/home/address/update-address',
        queryParams: {
          'id-address': idAddress,
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $CartRouteExtension on CartRoute {
  static CartRoute _fromState(GoRouterState state) => CartRoute();

  String get location => GoRouteData.$location(
        '/home/cart',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $SosDetailRouteExtension on SosDetailRoute {
  static SosDetailRoute _fromState(GoRouterState state) => SosDetailRoute(
        sosType: state.uri.queryParameters['sos-type']!,
        message: state.uri.queryParameters['message']!,
      );

  String get location => GoRouteData.$location(
        '/home/sos/sos-detail',
        queryParams: {
          'sos-type': sosType,
          'message': message,
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $RegisterRouteExtension on RegisterRoute {
  static RegisterRoute _fromState(GoRouterState state) => RegisterRoute();

  String get location => GoRouteData.$location(
        '/home/register',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $LoginRouteExtension on LoginRoute {
  static LoginRoute _fromState(GoRouterState state) => LoginRoute();

  String get location => GoRouteData.$location(
        '/home/register/login',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $LupaPasswordRouteExtension on LupaPasswordRoute {
  static LupaPasswordRoute _fromState(GoRouterState state) =>
      LupaPasswordRoute();

  String get location => GoRouteData.$location(
        '/home/register/login/lupa-password',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $LupaPasswordOtpRouteExtension on LupaPasswordOtpRoute {
  static LupaPasswordOtpRoute _fromState(GoRouterState state) =>
      LupaPasswordOtpRoute(
        email: state.uri.queryParameters['email']!,
      );

  String get location => GoRouteData.$location(
        '/home/register/login/lupa-password/lupa-password-otp',
        queryParams: {
          'email': email,
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $LupaPasswordChangeRouteExtension on LupaPasswordChangeRoute {
  static LupaPasswordChangeRoute _fromState(GoRouterState state) =>
      LupaPasswordChangeRoute(
        email: state.uri.queryParameters['email']!,
        otp: state.uri.queryParameters['otp']!,
      );

  String get location => GoRouteData.$location(
        '/home/register/login/lupa-password/lupa-password-otp/lupa-password-change',
        queryParams: {
          'email': email,
          'otp': otp,
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $RegisterKtpRouteExtension on RegisterKtpRoute {
  static RegisterKtpRoute _fromState(GoRouterState state) => RegisterKtpRoute();

  String get location => GoRouteData.$location(
        '/home/register/register-ktp',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $RegisterAkunRouteExtension on RegisterAkunRoute {
  static RegisterAkunRoute _fromState(GoRouterState state) => RegisterAkunRoute(
        $extra: state.extra as ExtrackKtpModel,
      );

  String get location => GoRouteData.$location(
        '/home/register/register-ktp/register-akun',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

extension $RegisterOtpRouteExtension on RegisterOtpRoute {
  static RegisterOtpRoute _fromState(GoRouterState state) => RegisterOtpRoute(
        email: state.uri.queryParameters['email']!,
        isLogin: _$boolConverter(state.uri.queryParameters['is-login']!)!,
        $extra: state.extra as ExtrackKtpModel,
      );

  String get location => GoRouteData.$location(
        '/home/register/register-ktp/register-akun/register-otp',
        queryParams: {
          'email': email,
          'is-login': isLogin.toString(),
        },
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

extension $OrderRouteExtension on OrderRoute {
  static OrderRoute _fromState(GoRouterState state) => OrderRoute(
        initIndex: int.parse(state.uri.queryParameters['init-index']!)!,
      );

  String get location => GoRouteData.$location(
        '/home/my-order',
        queryParams: {
          'init-index': initIndex.toString(),
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $DetailOrderRouteExtension on DetailOrderRoute {
  static DetailOrderRoute _fromState(GoRouterState state) => DetailOrderRoute(
        idOrder: int.parse(state.uri.queryParameters['id-order']!)!,
        initIndex: int.parse(state.uri.queryParameters['init-index']!)!,
      );

  String get location => GoRouteData.$location(
        '/home/my-order/order-detail',
        queryParams: {
          'id-order': idOrder.toString(),
          'init-index': initIndex.toString(),
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $TrackingRouteExtension on TrackingRoute {
  static TrackingRoute _fromState(GoRouterState state) => TrackingRoute(
        noTracking: state.uri.queryParameters['no-tracking']!,
        store: state.uri.queryParameters['store']!,
        initIndex: int.parse(state.uri.queryParameters['init-index']!)!,
        idOrder: int.parse(state.uri.queryParameters['id-order']!)!,
      );

  String get location => GoRouteData.$location(
        '/home/my-order/order-detail/tracking',
        queryParams: {
          'no-tracking': noTracking,
          'store': store,
          'init-index': initIndex.toString(),
          'id-order': idOrder.toString(),
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $PageDetailProofShippingRouteExtension
    on PageDetailProofShippingRoute {
  static PageDetailProofShippingRoute _fromState(GoRouterState state) =>
      PageDetailProofShippingRoute(
        initIndex: int.parse(state.uri.queryParameters['init-index']!)!,
        idOrder: int.parse(state.uri.queryParameters['id-order']!)!,
        noTracking: state.uri.queryParameters['no-tracking']!,
        store: state.uri.queryParameters['store']!,
        $extra: state.extra as TrackingModel,
      );

  String get location => GoRouteData.$location(
        '/home/my-order/order-detail/tracking/detail-proff',
        queryParams: {
          'init-index': initIndex.toString(),
          'id-order': idOrder.toString(),
          'no-tracking': noTracking,
          'store': store,
        },
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

extension $NeedRiviewRouteExtension on NeedRiviewRoute {
  static NeedRiviewRoute _fromState(GoRouterState state) => NeedRiviewRoute();

  String get location => GoRouteData.$location(
        '/home/need-riview',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

T? _$convertMapValue<T>(
  String key,
  Map<String, String> map,
  T? Function(String) converter,
) {
  final value = map[key];
  return value == null ? null : converter(value);
}

bool _$boolConverter(String value) {
  switch (value) {
    case 'true':
      return true;
    case 'false':
      return false;
    default:
      throw UnsupportedError('Cannot convert "$value" into a bool.');
  }
}
