import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../misc/injections.dart';
import '../../../misc/snackbar.dart';
import '../../../repositories/event_repository/event_repository.dart';
import '../../../repositories/event_repository/models/event_detail_model.dart';
import '../../event/cubit/event_cubit.dart';

part 'event_detail_state.dart';

class EventDetailCubit extends Cubit<EventDetailState> {
  EventDetailCubit() : super(EventDetailState());

  EventRepository repo = getIt<EventRepository>();

  void copyState({required EventDetailState newState}) {
    emit(newState);
  }

  Future<void> fetchDetailEvent(int idEvent) async {
    emit(state.copyWith(loading: true));
    try {
      final event = await repo.getEventDetail(idEvent);

      final isJoined = event.data?.isJoin ?? false;

      emit(state.copyWith(
        event: event,
        idEvent: idEvent,
        isJoined: isJoined,
      ));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    } finally {
      emit(state.copyWith(loading: false));
    }
  }

  Future<void> joinEvent(BuildContext context) async {
    // Cegah join ulang
    if (state.isJoined) return;

    try {
      await repo.jointEvent(idEvent: state.idEvent.toString());

      emit(state.copyWith(isJoined: true));

      ShowSnackbar.snackbar(
        context,
        "Berhasil bergabung dengan event",
        isSuccess: true,
      );
    } catch (e) {
      ShowSnackbar.snackbar(
        context,
        "Gagal bergabung dengan event",
        isSuccess: false,
      );
    }
  }

  // Future<void> toggleJoinStatus(BuildContext context) async {
  //   try {
  //     await repo.jointEvent(idEvent: state.idEvent.toString());

  //     final newStatus = !state.isJoined;

  //     emit(state.copyWith(isJoined: newStatus));

  //     ShowSnackbar.snackbar(
  //       context,
  //       newStatus
  //           ? "Berhasil bergabung dengan event"
  //           : "Berhasil keluar dari event",
  //       isSuccess: true,
  //     );
  //   } catch (e) {
  //     ShowSnackbar.snackbar(
  //       context,
  //       "Gagal mengubah status event",
  //       isSuccess: false,
  //     );
  //   }
  // }

  @override
  Future<void> close() {
    getIt<EventCubit>().fetchEvent();
    return super.close();
  }
}
