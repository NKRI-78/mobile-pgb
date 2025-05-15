import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../misc/http_client.dart';
import '../../../misc/injections.dart';
import '../../../repositories/auth_repository/models/user_model.dart';
import '../../../repositories/home_repository/home_repository.dart';
import '../../home/bloc/home_bloc.dart';

part 'app_bloc.g.dart';
part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends HydratedBloc<AppEvent, AppState> {
  AppBloc() : super(AppInitial()) {
    on<InitialAppData>(_onInitialAppData);
    on<SetUserLogout>(_onSetUserLogout);
    on<SetUserData>(_onSetUserData);
    // on<AppEvent>((event, emit) {});
  }

  HomeRepository repoHome = HomeRepository();

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
    //
  }

  FutureOr<void> _onSetUserData(SetUserData event, Emitter<AppState> emit) {
    getIt<BaseNetworkClient>().addTokenToHeader(event.token);
    emit(state.copyWith(token: event.token, user: event.user));
    // getIt<ProfileCubit>().getProfile();
    getIt<HomeBloc>().add(HomeInit());
    // state.copyWith();
  }

  Future<void> _onSetUserLogout(
      SetUserLogout event, Emitter<AppState> emit) async {
    try {
      // repoHome.setFcm('');
      emit(state.logout());
      // getIt<ProfileCubit>().emit(ProfileState());
      getIt<HomeBloc>().add(HomeNavigate(0));
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
