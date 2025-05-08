import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../modules/home/view/home_page.dart';

part 'builder.g.dart';

@TypedGoRoute<HomeRoute>(path: '/home')
class HomeRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return HomePage();
  }
}
