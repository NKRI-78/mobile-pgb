import 'package:go_router/go_router.dart';

import '../misc/navigation.dart';
import '../modules/app/bloc/app_bloc.dart';
import 'builder.dart';

class MyRouter {
  static GoRouter init(AppBloc app) {
    return GoRouter(
      navigatorKey: myNavigatorKey,
      routes: $appRoutes,
      initialLocation: app.state.alreadyOnboarding
          ? HomeRoute().location
          : OnboardingRoute().location,
    );
  }
}
