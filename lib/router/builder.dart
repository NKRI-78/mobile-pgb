import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_pgb/modules/login/view/login_page.dart';
import '../modules/register/view/register_page.dart';
import '../widgets/pages/about/about_us_page.dart';

import '../modules/home/view/home_page.dart';
import '../widgets/pages/media/view/media_page.dart';

part 'builder.g.dart';

@TypedGoRoute<HomeRoute>(path: '/home', routes: [
  TypedGoRoute<MediaRoute>(path: 'media'),
  TypedGoRoute<AboutRoute>(path: 'about'),
  TypedGoRoute<RegisterRoute>(path: 'register', routes: [
    TypedGoRoute<LoginRoute>(path: 'login'),
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
