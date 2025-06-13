import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import '../../../misc/injections.dart';
import '../../app/bloc/app_bloc.dart';
import '../../../misc/colors.dart';
import '../../../misc/marker_icon.dart';
import '../../../misc/modal.dart';
import '../../../repositories/membernear_repository/membernear_repository.dart';
import '../../../repositories/membernear_repository/models/membernear_model.dart';

part 'membernear_event.dart';
part 'membernear_state.dart';

class MemberNearBloc extends Bloc<MemberNearEvent, MemberNearState> {
  MemberNearBloc()
      : super(
          const MemberNearState(),
        ) {
    on<MemberNearSetArea>(_onMemberNearSetArea);
  }

  MemberNearRepository repo = MemberNearRepository();

  FutureOr<void> _onMemberNearSetArea(
      MemberNearSetArea event, Emitter<MemberNearState> emit) async {
    emit(state.copyWith(loading: true));
    List<Marker> newMarkers = [];

    final app = getIt<AppBloc>();
    final profile = app.state.profile;

    emit(state.copyWith(
        latitude: profile?.latitude ?? 0.0,
        longitude: profile?.longitude ?? 0.0));

    event.mapController.moveCamera(CameraUpdate.newLatLng(
        LatLng(profile?.latitude ?? 0.0, profile?.longitude ?? 0.0)));

    MemberNearModel? data = await repo.getMemberNear(
        latitude: profile?.latitude.toString() ?? "0",
        longitude: profile?.longitude.toString() ?? "0");

    final result =
        data?.data?.where((r) => r.id != app.state.profile?.id).toList() ?? [];

    print("Data Result ${result.length}");
    print("Data Result ${app.state.profile?.id}");

    List<MemberNearData>? nd = result;
    for (MemberNearData membernear in nd) {
      newMarkers.add(Marker(
          markerId: MarkerId(membernear.phone ?? ""),
          onTap: () {
            GeneralModal.showModalMemberNearDetail(event.context, membernear);
          },
          icon: await MarkerIcon.downloadResizePictureCircle(
            (membernear.profile?.avatarLink?.isEmpty ?? true)
                ? "https://i.ibb.co.com/vxkjJQD/Png-Item-1503945.png"
                : membernear.profile?.avatarLink ?? "",
            size: 100,
            addBorder: true,
            borderColor: AppColors.secondaryColor,
            borderSize: 15.0,
          ),
          infoWindow: InfoWindow(
            title: membernear.profile?.fullname ?? "",
          ),
          position:
              LatLng(membernear.latitude ?? 0.0, membernear.longitude ?? 0.0)));
    }
    emit(state.copyWith(
        markers: newMarkers, memberNearData: nd, loading: false));
  }
}
