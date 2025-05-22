part of 'tracking_cubit.dart';

class TrackingState extends Equatable {
  final TrackingModel? tracking;
  final bool loading;
  final int initIndex;
  final int idOrder;

  const TrackingState({
    this.tracking,
    this.loading = false,
    this.initIndex = 0,
    this.idOrder = 0,
  });

  @override
  List<Object?> get props => [
    tracking,
    loading,
    initIndex,
    idOrder,
  ];

  TrackingState copyWith({
    TrackingModel? tracking,
    bool? loading,
    int? initIndex,
    int? idOrder,
  }) {
    return TrackingState(
      tracking: tracking ?? this.tracking,
      loading: loading ?? this.loading,
      initIndex: initIndex ?? this.initIndex,
      idOrder: idOrder ?? this.idOrder,
    );
  }
}
