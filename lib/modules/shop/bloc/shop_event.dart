part of 'shop_bloc.dart';

sealed class ShopEvent {
  const ShopEvent();
}

final class SearchProduct extends ShopEvent {
  final String query;

  SearchProduct(this.query);
}

final class ShopInitialData extends ShopEvent {}

final class GetCategory extends ShopEvent {}

final class GetProduct extends ShopEvent {
  final String? searchQuery;
  final int? idCategory;

  GetProduct({this.searchQuery, this.idCategory});
}

final class CopyState extends ShopEvent {
  final ShopState newState;

  CopyState({required this.newState});
}

final class LoadMoreProduct extends ShopEvent {}

final class RefreshProduct extends ShopEvent {
  final int? idCategory;

  RefreshProduct({required this.idCategory});
}

final class ToggleSelection extends ShopEvent {
  final int id;

  ToggleSelection({required this.id});
}

final class ChangeProduct extends ShopEvent {
  final int? idCategory;

  ChangeProduct({this.idCategory});
}
