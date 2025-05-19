import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../misc/injections.dart';
import '../../../repositories/event_repository/event_repository.dart';

import '../../../repositories/event_repository/models/event_model.dart';

part 'event_state.dart';

class EventCubit extends Cubit<EventState> {
  EventCubit() : super(const EventState());

  EventRepository repo = getIt<EventRepository>();

  void copyState({required EventState newState}) {
    emit(newState);
  }

  Future<void> fetchEvent() async {
    emit(state.copyWith(isLoading: true));
    try {
      emit(state.copyWith(isLoading: true));
      final event = await repo.getEvents();
      emit(state.copyWith(
        events: event,
        isLoading: false,
      ));
      debugPrint("Event berhasil dimuat: $event");
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
      debugPrint("Gagal memuat event: $e");
    }
  }
}
