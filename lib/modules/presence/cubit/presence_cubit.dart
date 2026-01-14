import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../../misc/injections.dart';
import '../../../repositories/presence_repository/presence_repository.dart';

part 'presence_state.dart';

class PresenceCubit extends Cubit<PresenceState> {
  PresenceCubit() : super(const PresenceState());

  final PresenceRepository repo = getIt<PresenceRepository>();

  Future<void> createPresence({
    required String tokenAttend,
  }) async {
    emit(const PresenceState(isLoading: true));

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      );

      final latitude = position.latitude;
      final longitude = position.longitude;
      final isFakeGps = position.isMocked;

      await Future.delayed(const Duration(milliseconds: 1700));

      final result = await repo.createPresence(
        tokenAttend: tokenAttend,
        latitude: latitude,
        longitude: longitude,
        isFakeGps: isFakeGps,
      );

      final message = result['message']?.toString() ?? '';

      final bool success = result['data'] != null;

      DateTime? presenceDate;
      if (result['data']?['date'] != null) {
        presenceDate = DateTime.parse(result['data']['date']);
      }

      emit(PresenceState(
        isLoading: false,
        isSuccess: success,
        message: message,
        presenceDate: presenceDate,
      ));
    } catch (e) {
      emit(PresenceState(
        isLoading: false,
        isSuccess: false,
        message: e.toString().replaceAll('Exception:', '').trim(),
      ));
    }
  }
}
