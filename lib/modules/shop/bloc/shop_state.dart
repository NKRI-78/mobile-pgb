part of 'shop_bloc.dart';

@JsonSerializable()
class ShopState extends Equatable {
  final List<CategoryModel> category;
  final List<ProductModel> product;
  final Pagination? pagination;
  final int nexPageProduct;
  final int? idCategory;
  final bool loading;
  final Set<int> selectedIds;
  final double scrollP;
  final int tabIndex;

  const ShopState({
    this.category = const [],
    this.product = const [],
    this.pagination,
    this.nexPageProduct = 0,
    this.idCategory = 0,
    this.loading = false,
    this.selectedIds = const {},
    this.scrollP = 0,
    this.tabIndex = 0,
  });

  @override
  List<Object?> get props => [
    category, 
    product, 
    pagination, 
    nexPageProduct,
    idCategory, 
    loading,
    selectedIds,
    scrollP,
    tabIndex,
  ];

  ShopState copyWith({
    List<CategoryModel>? category,
    List<ProductModel>? product,
    Pagination? pagination,
    bool? loading,
    int? nexPageProduct,
    int? idCategory,
    Set<int>? selectedIds,
    double? scrollP,
    int? tabIndex,
  }) {
    return ShopState(
      category: category ?? this.category,
      product: product ?? this.product,
      pagination: pagination ?? this.pagination,
      loading: loading ?? this.loading,
      nexPageProduct: nexPageProduct ?? this.nexPageProduct,
      idCategory: idCategory ?? this.idCategory, 
      selectedIds: selectedIds ?? this.selectedIds,
      scrollP: scrollP ?? this.scrollP,
      tabIndex: tabIndex ?? this.tabIndex,
    );
  }
}
