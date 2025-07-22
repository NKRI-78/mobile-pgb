import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../repositories/app_repository/app_repository.dart';
// import '../../../repositories/app_repository/model/setting_model.dart';
import '../models/user_google_model.dart';
import '../../../repositories/cart_repository/cart_repository.dart';
import '../../../repositories/cart_repository/models/cart_count_model.dart';
import '../../../misc/http_client.dart';
import '../../../misc/injections.dart';
import '../../../repositories/auth_repository/models/user_model.dart';
import '../../../repositories/home_repository/home_repository.dart';
import '../../../repositories/notification/models/notification_count_model.dart';
import '../../../repositories/notification/notification_repository.dart';
import '../../../repositories/profile_repository/models/profile_model.dart';
import '../../../repositories/profile_repository/profile_repository.dart';
import '../../home/bloc/home_bloc.dart';
import '../../profile/cubit/profile_cubit.dart';

part 'app_bloc.g.dart';
part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends HydratedBloc<AppEvent, AppState> {
  AppBloc() : super(AppInitial()) {
    on<InitialAppData>(_onInitialAppData);
    on<FinishOnboarding>(_onFinishOnboarding);
    on<SetUserLogout>(_onSetUserLogout);
    on<SetUserData>(_onSetUserData);
    on<GetBadgeNotif>(_onGetBadgeNotif);
    on<GetBadgeCart>(_onGetBadgeCart);
    // on<IsRealese>(_onIsRealese);

    on<GetProfileData>(_onGetProfile);
    on<AppEvent>((event, emit) {});
    // on<AppEvent>((event, emit) {});
  }

  HomeRepository repoHome = HomeRepository();
  ProfileRepository repoProfile = ProfileRepository();
  NotificationRepository repoNotif = NotificationRepository();
  CartRepository repoCart = CartRepository();
  AppRepository repoApp = AppRepository();

  @override
  AppState? fromJson(Map<String, dynamic> json) {
    return _$AppStateFromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(AppState state) {
    return _$AppStateToJson(state);
  }

  FutureOr<void> _onInitialAppData(
      InitialAppData event, Emitter<AppState> emit) {
    add(GetBadgeCart());
    add(GetBadgeNotif());
    add(GetProfileData());
    add(IsRealese());
    //
  }

  FutureOr<void> _onFinishOnboarding(
      FinishOnboarding event, Emitter<AppState> emit) {
    emit(state.copyWith(alreadyOnboarding: true));
  }

  FutureOr<void> _onSetUserData(SetUserData event, Emitter<AppState> emit) {
    getIt<BaseNetworkClient>().addTokenToHeader(event.token);
    emit(state.copyWith(token: event.token, user: event.user));
    getIt<ProfileCubit>().getProfile();
    getIt<HomeBloc>().add(HomeInit());
    state.copyWith();
  }

  // FutureOr<void> _onIsRealese(IsRealese event, Emitter<AppState> emit) async {
  //   SettingModel? data = await repoApp.isRealese();
  //   emit(state.copyWith(isRelease: data.data.isReview));
  //   debugPrint("data release ${data.data.isReview}");
  // }

  Future<void> _onSetUserLogout(
    SetUserLogout event,
    Emitter<AppState> emit,
  ) async {
    try {
      repoHome.setFcm('');
      emit(state.logout());
      getIt<ProfileCubit>().emit(ProfileState());
      getIt<HomeBloc>().add(HomeNavigate(0));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  FutureOr<void> _onGetBadgeNotif(
      GetBadgeNotif event, Emitter<AppState> emit) async {
    try {
      emit(state.copyWith(loadingNotif: true));
      NotificationCountModel badges = await repoNotif.getBadgesNotif();
      emit(state.copyWith(badges: badges, loadingNotif: false));
    } catch (e) {
      debugPrint("Error : $e");
    } finally {
      emit(state.copyWith(loadingNotif: false));
    }
  }

  FutureOr<void> _onGetBadgeCart(
      GetBadgeCart event, Emitter<AppState> emit) async {
    if (state.token.isEmpty) return;

    var cart = await repoCart.getCartCount();
    emit(state.copyWith(badgeCart: cart));
  }

  FutureOr<void> _onGetProfile(
      GetProfileData event, Emitter<AppState> emit) async {
    try {
      final profile = await repoProfile.getProfile();
      emit(state.copyWith(profile: profile));
    } catch (e) {
      debugPrint("Error : $e");
    }
  }
}
