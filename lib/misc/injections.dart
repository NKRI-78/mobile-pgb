import 'package:get_it/get_it.dart';
import 'package:mobile_pgb/misc/socket.dart';
import 'package:mobile_pgb/modules/cart/cubit/cart_cubit.dart';
import 'package:mobile_pgb/modules/checkout/cubit/checkout_cubit.dart';
import 'package:mobile_pgb/modules/detail_product/cubit/detail_product_cubit.dart';
import 'package:mobile_pgb/modules/list_address/cubit/list_address_cubit.dart';
import 'package:mobile_pgb/repositories/shop_repository/shop_repository.dart';

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
    //
    getIt.registerLazySingleton<BaseNetworkClient>(() => BaseNetworkClient());
    //
    getIt.registerLazySingleton<AppBloc>(() => AppBloc());
    getIt.registerLazySingleton<HomeBloc>(() => HomeBloc());
    //
    getIt.registerCachedFactory<LoginCubit>(() => LoginCubit());
    getIt.registerCachedFactory<NewsDetailCubit>(() => NewsDetailCubit());
    getIt.registerCachedFactory<NewsAllCubit>(() => NewsAllCubit());
    getIt.registerCachedFactory<EventCubit>(() => EventCubit());
    getIt.registerCachedFactory<CartCubit>(() => CartCubit());
    getIt.registerCachedFactory<DetailProductCubit>(() => DetailProductCubit ());
    getIt.registerCachedFactory<CheckoutCubit>(() => CheckoutCubit());
    getIt.registerLazySingleton<ListAddressCubit>(() => ListAddressCubit()); 

    //

    //Socket IO
    getIt.registerLazySingleton<SocketServices>(
      () => SocketServices()..connect(),
    );

    //
    getIt.registerLazySingleton<AuthRepository>(() => AuthRepository());
    getIt.registerLazySingleton<HomeRepository>(() => HomeRepository());
    getIt.registerLazySingleton<NewsRepository>(() => NewsRepository());
    getIt.registerLazySingleton<ProfileRepository>(() => ProfileRepository());
    getIt.registerLazySingleton<EventRepository>(() => EventRepository());
    getIt.registerLazySingleton<ShopRepository>(() => ShopRepository());
  }
}
