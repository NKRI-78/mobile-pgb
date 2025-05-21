import 'package:get_it/get_it.dart';
import '../modules/wallet/cubit/wallet_cubit.dart';
import '../repositories/wallet_repository/wallet_repository.dart';
import '../modules/ppob/cubit/ppob_cubit.dart';
import '../repositories/ppob_repository/ppob_repository.dart';
import '../modules/notification/cubit/notification_cubit.dart';
import '../modules/profile/cubit/profile_cubit.dart';
import '../modules/sos/cubit/sos_page_cubit.dart';
import '../repositories/notification/notification_repository.dart';
import '../repositories/sos_repository/sos_repository.dart';

import '../modules/app/bloc/app_bloc.dart';
import '../modules/event/cubit/event_cubit.dart';
import '../modules/home/bloc/home_bloc.dart';
import '../modules/login/cubit/login_cubit.dart';
import '../modules/news_all/cubit/news_all_cubit.dart';
import '../modules/news_detail/cubit/news_detail_cubit.dart';
import '../repositories/auth_repository/auth_repository.dart';
import '../repositories/event_repository/event_repository.dart';
import '../repositories/home_repository/home_repository.dart';
import '../repositories/news_repository/news_repository.dart';
import '../repositories/profile_repository/profile_repository.dart';
import 'http_client.dart';

final getIt = GetIt.instance;

class MyInjection {
  static setup() {
    // BASE
    getIt.registerLazySingleton<BaseNetworkClient>(() => BaseNetworkClient());

    // BLOC
    getIt.registerLazySingleton<AppBloc>(() => AppBloc());
    getIt.registerLazySingleton<HomeBloc>(() => HomeBloc());

    // CUBIT
    getIt.registerCachedFactory<LoginCubit>(() => LoginCubit());
    getIt.registerCachedFactory<NewsDetailCubit>(() => NewsDetailCubit());
    getIt.registerCachedFactory<NewsAllCubit>(() => NewsAllCubit());
    getIt.registerCachedFactory<EventCubit>(() => EventCubit());
    getIt.registerCachedFactory<SosCubit>(() => SosCubit());
    getIt.registerCachedFactory<NotificationCubit>(() => NotificationCubit());
    getIt.registerCachedFactory<PpobCubit>(() => PpobCubit());
    getIt.registerCachedFactory<ProfileCubit>(() => ProfileCubit());
    getIt.registerCachedFactory<WalletCubit>(() => WalletCubit());

    // REPO
    getIt.registerLazySingleton<AuthRepository>(() => AuthRepository());
    getIt.registerLazySingleton<HomeRepository>(() => HomeRepository());
    getIt.registerLazySingleton<NewsRepository>(() => NewsRepository());
    getIt.registerLazySingleton<ProfileRepository>(() => ProfileRepository());
    getIt.registerLazySingleton<EventRepository>(() => EventRepository());
    getIt.registerLazySingleton<SosRepository>(() => SosRepository());
    getIt.registerLazySingleton<NotificationRepository>(
        () => NotificationRepository());
    getIt.registerLazySingleton<PpobRepository>(() => PpobRepository());
    getIt.registerLazySingleton<WalletRepository>(() => WalletRepository());
  }
}
