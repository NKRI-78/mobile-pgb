import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mobile_pgb/misc/colors.dart';
import 'package:mobile_pgb/misc/marker_icon.dart';
import 'package:mobile_pgb/misc/modal.dart';
import 'package:mobile_pgb/repositories/membernear_repository/membernear_repository.dart';
import 'package:mobile_pgb/repositories/membernear_repository/models/membernear_model.dart';


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

  Future<void> setLocation(Emitter<MemberNearState> emit) async {
    emit(state.copyWith(loading: true));
     Geolocator.requestPermission();
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);
      debugPrint("Lat init ${position.latitude}");
      debugPrint("Long init ${position.longitude}");
      emit(state.copyWith(latitude: position.latitude, longitude: position.longitude, loading: false));
  }

  Future<void> fetchMemberNear(Emitter<MemberNearState> emit) async {
    try {
      emit(state.copyWith(loading: true));
      MemberNearModel? data = await repo.getMemberNear(latitude: state.latitude.toString(), longitude: state.longitude.toString());

      emit(state.copyWith(memberNearModel: data, loading: false));
    } catch (e) {
      debugPrint("Member near : ${e.toString()}");
    } finally {
      emit(state.copyWith(loading: false));
    }
  }

  FutureOr<void> _onMemberNearSetArea(MemberNearSetArea event, Emitter<MemberNearState> emit) async {
    emit(state.copyWith(loading: true));
    List<Marker> newMarkers = [];

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    emit(state.copyWith(latitude: position.latitude, longitude: position.longitude));

    event.mapController.moveCamera(CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)));
    
    MemberNearModel? data = await repo.getMemberNear(latitude: position.latitude.toString(), longitude: position.longitude.toString());
    debugPrint("Lat init ${position.latitude.toString()}");
    debugPrint("Long init ${position.longitude.toString()}");

    print("Data Member : ${data!.data}");
    
    List<MemberNearData>? nd = data!.data;
    for (MemberNearData membernear in nd!) {
      newMarkers.add(
        Marker(
          markerId: MarkerId(membernear.phone ?? ""),
          onTap: () {
            GeneralModal.showModalMemberNearDetail(event.context, membernear);
          },
          icon: await MarkerIcon.downloadResizePictureCircle(
            (membernear.linkAvatar?.isEmpty ?? true)
                ? "https://i.ibb.co.com/vxkjJQD/Png-Item-1503945.png"
                : membernear.linkAvatar!,
            size: 100,
            addBorder: true,
            borderColor: AppColors.secondaryColor,
            borderSize: 15.0,
          ),
          infoWindow: InfoWindow(
            title: membernear.fullname,
          ),
          position: LatLng(membernear.lastLat ?? 0.0, membernear.lastLng ?? 0.0)
        )
      );
    }
    emit(state.copyWith(markers: newMarkers, memberNearModel: data, loading: false));
  }
  
}