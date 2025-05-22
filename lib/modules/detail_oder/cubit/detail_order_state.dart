part of 'detail_order_cubit.dart';

class DetailOrderState extends Equatable {
  final DetailOrderModel? detailOrder;
  final Map<String, List<File>> pickedFile;
  final String feedType;
  final bool loading;
  final int initIndex;
  final int idOrder;
  final int rating;
  final String message;

  const DetailOrderState({
    this.detailOrder,
    this.pickedFile = const {},
    this.feedType = "",
    this.loading = false,
    this.initIndex = 0,
    this.idOrder = 0,
    this.rating = 0,
    this.message = "",
  });


  @override
  List<dynamic> get props => [
    detailOrder,
    pickedFile,
    feedType,
    loading,
    initIndex,
    idOrder,
    rating,
    message,
  ];

  DetailOrderState copyWith({
    DetailOrderModel? detailOrder,
    Map<String, List<File>>? pickedFile,
    String? feedType,
    bool? loading,
    int? initIndex,
    int? idOrder,
    int? rating,
    String? message,
  }) {
    return DetailOrderState(
      detailOrder: detailOrder ?? this.detailOrder,
      pickedFile: pickedFile ?? this.pickedFile,
      feedType: feedType ?? this.feedType,
      loading: loading ?? this.loading,
      initIndex: initIndex ?? this.initIndex,
      idOrder: idOrder ?? this.idOrder,
      rating: rating ?? this.rating,
      message: message ?? this.message,
    );
  }
}
