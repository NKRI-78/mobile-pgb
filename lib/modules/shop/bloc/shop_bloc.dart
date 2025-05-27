import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../misc/pagination.dart';
import '../../../repositories/shop_repository/models/category_model.dart';
import '../../../repositories/shop_repository/models/product_model.dart';
import '../../../repositories/shop_repository/shop_repository.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

part 'shop_event.dart';
part 'shop_state.dart';
part 'shop_bloc.g.dart';

class ShopBloc extends HydratedBloc<ShopEvent, ShopState> {
  ShopBloc() : super(const ShopState()) {
    on<ShopInitialData>(_onShopInitaialData);
    on<GetCategory>(_onGetCategory);
    on<GetProduct>(_onGetProduct);
    on<LoadMoreProduct>(_onLoadMoreProduct);
    on<RefreshProduct>(_onRefreshProduct);
    on<ChangeProduct>(_onChangeProduct);
    on<ToggleSelection>(_onToggleSelection);
    on<CopyState>(_onCopyState);
    on<SearchProduct>(_onSearchProduct);
  }

  ShopRepository repo = ShopRepository();

  static RefreshController refreshCtrl = RefreshController();

  @override
  ShopState? fromJson(Map<String, dynamic> json) {
    return _$ShopStateFromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(ShopState state) {
    return _$ShopStateToJson(state);
  }

  FutureOr<void> _onShopInitaialData(
      ShopInitialData event, Emitter<ShopState> emit) async {
    add(GetCategory());
    add(GetProduct());
  }

  FutureOr<void> _onGetCategory(
      GetCategory event, Emitter<ShopState> emit) async {
    try {
      emit(state.copyWith(loading: true));
      final category = await repo.getCategory();
      emit(state.copyWith(category: category, loading: false));
    } catch (e) {
      rethrow;
    }
  }

  FutureOr<void> _onGetProduct(
      GetProduct event, Emitter<ShopState> emit) async {
    try {
      emit(state.copyWith(loading: true));
      final data = await repo.getProductOfficial(idCategory: event.idCategory);

      List<ProductModel> filteredProducts = data.list;

      if (event.searchQuery != null && event.searchQuery!.isNotEmpty) {
        final queryLower = event.searchQuery!.toLowerCase();
        filteredProducts = data.list.where((product) {
          return product.name?.toLowerCase().contains(queryLower) ?? false;
        }).toList();
      }

      emit(state.copyWith(
        product: filteredProducts,
        nexPageProduct: data.pagination.currentPage,
        pagination: data.pagination,
        loading: false,
        searchQuery: event.searchQuery ?? '',
      ));
    } catch (e) {
      rethrow;
    } finally {
      emit(state.copyWith(loading: false));
    }
  }

  FutureOr<void> _onLoadMoreProduct(
      LoadMoreProduct event, Emitter<ShopState> emit) async {
    try {
      PaginationModel<ProductModel> data = await repo.getProductOfficial(
          page: state.nexPageProduct == 1
              ? state.nexPageProduct + 1
              : state.nexPageProduct,
          idCategory: state.idCategory);
      print("Hit Product load");

      if (data.list.isEmpty) {
        refreshCtrl.loadNoData(); // Menandakan tidak ada data lagi
        return;
      }
      emit(state.copyWith(
        nexPageProduct: data.pagination.currentPage < data.pagination.totalPages
            ? data.pagination.currentPage + 1
            : data.pagination.currentPage,
        product: [...state.product, ...data.list],
        pagination: data.pagination,
      ));
      refreshCtrl.loadComplete();
    } catch (e) {
      debugPrint("error $e");
    } finally {
      refreshCtrl.loadComplete();
    }
  }

  FutureOr<void> _onRefreshProduct(
      RefreshProduct event, Emitter<ShopState> emit) async {
    try {
      emit(state.copyWith(loading: true));

      print("Refresh kategori id: ${event.idCategory}");
      await Future.delayed(const Duration(seconds: 1));

      PaginationModel<ProductModel> data =
          await repo.getProductOfficial(idCategory: event.idCategory);

      emit(state.copyWith(
        idCategory: null,
        product: data.list,
        nexPageProduct: data.pagination.currentPage,
        pagination: data.pagination,
        loading: false,
      ));

      refreshCtrl.refreshCompleted();
    } catch (e) {
      rethrow;
    } finally {
      emit(state.copyWith(loading: false));
    }
  }

  FutureOr<void> _onChangeProduct(
      ChangeProduct event, Emitter<ShopState> emit) async {
    try {
      emit(state.copyWith(loading: true, searchQuery: '')); // reset searchQuery

      var value = await repo.getProductOfficial(idCategory: event.idCategory);

      emit(state.copyWith(
        idCategory: event.idCategory,
        product: value.list,
        pagination: value.pagination,
        loading: false,
        searchQuery: '',
      ));
    } catch (e) {
      rethrow;
    }
  }

  FutureOr<void> _onToggleSelection(
      ToggleSelection event, Emitter<ShopState> emit) async {
    final updatedCategories = List<int>.from(state.category);

    if (updatedCategories.contains(event.id)) {
      updatedCategories.remove(event.id);
    } else {
      updatedCategories.add(event.id);
    }

    int? newIdCategory = state.idCategory == event.id ? null : event.id;

    var value = await repo.getProductOfficial(idCategory: event.id);
    var list = value.list;
    var pagination = value.pagination;

    emit(state.copyWith(
        idCategory: newIdCategory,
        product: list,
        loading: false,
        pagination: pagination));
  }

  FutureOr<void> _onCopyState(CopyState event, Emitter<ShopState> emit) {
    emit(event.newState);
  }

  FutureOr<void> _onSearchProduct(
      SearchProduct event, Emitter<ShopState> emit) async {
    final query = event.query.toLowerCase();

    // Kalau query kosong, tampilkan produk original (atau reset)
    if (query.isEmpty) {
      // Ambil produk original dari API (atau pakai produk di state)
      try {
        emit(state.copyWith(loading: true, searchQuery: ''));
        final data =
            await repo.getProductOfficial(idCategory: state.idCategory);
        emit(state.copyWith(
          product: data.list,
          pagination: data.pagination,
          nexPageProduct: data.pagination.currentPage,
          loading: false,
          searchQuery: '',
        ));
      } catch (_) {
        emit(state.copyWith(loading: false));
      }
    } else {
      // Filter produk di local state.product (yang sudah di-fetch)
      final filtered = state.product.where((product) {
        return product.name?.toLowerCase().contains(query) ?? false;
      }).toList();

      emit(state.copyWith(
        product: filtered,
        searchQuery: query,
      ));
    }
  }
}
