import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repositories/home_repository/home_repository.dart';

import '../../../misc/injections.dart';
import '../../../repositories/home_repository/models/about_model.dart';

part 'about_us_state.dart';

class AboutUsCubit extends Cubit<AboutUsState> {
  AboutUsCubit() : super(const AboutUsState());

  HomeRepository repo = getIt<HomeRepository>();

  void copyState({required AboutUsState newState}) {
    emit(newState);
  }

  Future<void> fetchAboutUs() async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await repo.getAboutUs(); // ✅ Ambil hasilnya
      emit(state.copyWith(
        about: result, // ✅ Simpan ke state
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
      debugPrint("Gagal memuat: $e");
    }
  }
}
