import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../misc/injections.dart';
import '../../../repositories/home_repository/home_repository.dart';
import '../../../repositories/home_repository/models/data_pagination.dart';
import '../../../repositories/home_repository/models/news_model.dart';
import '../../../repositories/profile_repository/models/profile_model.dart';
import '../../../repositories/profile_repository/profile_repository.dart';
import '../../app/bloc/app_bloc.dart';

part 'home_bloc.g.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends HydratedBloc<HomeEvent, HomeState> {
  final HomeRepository homeRepo = getIt<HomeRepository>();
  final ProfileRepository profileRepo = getIt<ProfileRepository>();

  HomeBloc() : super(const HomeState()) {
    on<HomeInit>(_onHomeInit);
    on<HomeNavigate>(_onHomeNavigate);
    on<HomeCopyState>(_onHomeCopyState);
    on<LoadProfile>(_onLoadProfile);
  }

  @override
  HomeState? fromJson(Map<String, dynamic> json) {
    return _$HomeStateFromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(HomeState state) {
    return _$HomeStateToJson(state);
  }

  void _onHomeInit(HomeInit event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoading: true));

    if (getIt<AppBloc>().state.isLoggedIn) {
      add(LoadProfile());
    }
    await _fetchNews(emit, isRefresh: true);

    emit(state.copyWith(isLoading: false));
  }

  void _onHomeNavigate(HomeNavigate event, Emitter<HomeState> emit) {
    emit(state.copyWith(selectedIndex: event.index));
  }

  void _onHomeCopyState(HomeCopyState event, Emitter<HomeState> emit) {
    emit(event.newState);
  }

  void _onLoadProfile(LoadProfile event, Emitter<HomeState> emit) async {
    try {
      final profile = await profileRepo.getProfile();
      emit(state.copyWith(profile: profile));
    } catch (e) {
      debugPrint('❌ Error loading profile: $e');
    }
  }

  Future<void> _fetchNews(Emitter<HomeState> emit,
      {bool isRefresh = false}) async {
    emit(state.copyWith(isLoading: true));

    try {
      final int nextPage = isRefresh ? 1 : state.nextPageNews;

      DataPagination<NewsModel> newsData =
          await homeRepo.getNews(page: nextPage);

      if (newsData.list.isEmpty) {
        //
      } else {
        //
      }

      emit(state.copyWith(
        news: isRefresh
            ? List.of(newsData.list)
            : [...state.news, ...newsData.list],
        nextPageNews: newsData.paginate.next ?? state.nextPageNews,
        isLoading: false,
      ));
    } catch (e) {
      debugPrint('❌ Error fetching news: $e');
    }
  }
}
