part of 'membernear_bloc.dart';

sealed class MemberNearEvent {
  const MemberNearEvent();
}

final class MemberNearInitial extends MemberNearEvent {}

final class MemberNearSetArea extends MemberNearEvent {
  final BuildContext context;
  final GoogleMapController mapController;

  MemberNearSetArea({required this.context, required  this.mapController});
}

final class HomeCopyState extends MemberNearEvent {
  final MemberNearEvent newState;

  HomeCopyState({required this.newState});
}