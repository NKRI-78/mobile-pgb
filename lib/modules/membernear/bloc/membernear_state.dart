part of 'membernear_bloc.dart';

final class MemberNearState {
  final double latitude;
  final double longitude;
  final MemberNearModel? memberNearModel;
  final List<MemberNearData>? memberNearData;
  final List<Marker>? markers;
  final bool loading;

  const MemberNearState({
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.memberNearModel,
    this.markers,
    this.memberNearData,
    this.loading = false,
  });

  List<Object?> get props => [
    latitude,
    longitude,
    memberNearModel,
    markers,
    memberNearData,
    loading
  ];

  MemberNearState copyWith({
    double? latitude,
    double? longitude,
    MemberNearModel? memberNearModel,
    List<Marker>? markers,
    List<MemberNearData>? memberNearData,
    bool? loading,
  }) {
    return MemberNearState(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      memberNearModel: memberNearModel ?? this.memberNearModel,
      markers: markers ?? this.markers,
      memberNearData: memberNearData ?? this.memberNearData,
      loading: loading ?? this.loading,
    );
  }
}