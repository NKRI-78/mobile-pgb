part of 'need_riview_cubit.dart';

class NeedRiviewState extends Equatable {
  final List<NeedRiviewModel> needRiviewModel;
  final Map<String, Map<String, List<File>>> pickedFile;
  final Map<String, int> productRatings;
  final Map<String, String> productMessages;
  final bool loading;
  final bool loadingSubmit;
  final int rating;
  final String message;
  final String feedType;

  const NeedRiviewState({
    this.needRiviewModel = const [], 
    this.pickedFile = const {},
    this.productRatings = const {},
    this.productMessages = const {},
    this.loading = false,
    this.loadingSubmit = false,
    this.rating = 0,
    this.message = "",
    this.feedType = "",
  });

  @override
  List<Object?> get props => [
    needRiviewModel,
    pickedFile,
    productRatings,
    productMessages,
    loading,
    loadingSubmit,
    rating,
    message,
    feedType,
  ];

  NeedRiviewState copyWith({
    List<NeedRiviewModel>? needRiviewModel,
    Map<String, Map<String, List<File>>>? pickedFile,
    Map<String, int>? productRatings,
    Map<String, String>? productMessages,
    bool? loading,
    bool? loadingSubmit,
    int? rating,
    String? message,
    String? feedType
  }) {
    return NeedRiviewState(
      needRiviewModel: needRiviewModel ?? this.needRiviewModel,
      pickedFile: pickedFile ?? this.pickedFile,
      productRatings: productRatings ?? this.productRatings,
      productMessages: productMessages ?? this.productMessages,
      loading: loading ?? this.loading,
      loadingSubmit: loadingSubmit ?? this.loadingSubmit,
      rating: rating ?? this.rating,
      message: message ?? this.message,
      feedType: feedType ?? this.feedType,
    );
  }
}
