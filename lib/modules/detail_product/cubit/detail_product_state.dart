part of 'detail_product_cubit.dart';

class DetailProductState {
  final String idProduct;
  final bool loading;
  final DetailProductModel? detail;


  const DetailProductState({
    this.idProduct = "", 
    this.loading = false, 
    this.detail
  });

  DetailProductState copyWith({
    String? idProduct,
    DetailProductModel? detail,
    bool? loading,
  }) {
    return DetailProductState(
      idProduct: idProduct ?? this.idProduct,
      detail: detail ?? this.detail,
      loading: loading ?? this.loading,
    );
  }
}
