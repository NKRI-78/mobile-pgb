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
          path: 'register',
          factory: $RegisterRouteExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: 'login',
              factory: $LoginRouteExtension._fromState,
            ),
            GoRouteData.$route(
              path: 'register-ktp',
              factory: $RegisterKtpRouteExtension._fromState,
            ),
          ],
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
        newsId: int.parse(state.uri.queryParameters['news-id']!),
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
