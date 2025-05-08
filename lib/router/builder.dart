import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_pgb/modules/register/view/register_page.dart';

import '../modules/home/view/home_page.dart';

part 'builder.g.dart';

@TypedGoRoute<HomeRoute>(path: '/home', routes: [
  TypedGoRoute<RegisterRoute>(path: 'register'),
])
class HomeRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return HomePage();
  }
}

class RegisterRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const RegisterPage();
  }
}
