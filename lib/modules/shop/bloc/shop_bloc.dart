import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobile_pgb/misc/pagination.dart';
import 'package:mobile_pgb/repositories/shop_repository/models/category_model.dart';
import 'package:mobile_pgb/repositories/shop_repository/models/product_model.dart';
import 'package:mobile_pgb/repositories/shop_repository/shop_repository.dart';
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
      PaginationModel<ProductModel> data = await repo.getProductOfficial();
      print("Hit Product");
      emit(state.copyWith(
          product: data.list,
          nexPageProduct: data.pagination.currentPage,
          loading: false,
          pagination: data.pagination,
        )
      );
      print("State Paging : ${data.pagination.currentPage}");
    } catch (e) {
      rethrow;
    } finally {
      emit(state.copyWith(loading: false));
    }
  }

  FutureOr<void> _onLoadMoreProduct(
      LoadMoreProduct event, Emitter<ShopState> emit) async {
    try {
      PaginationModel<ProductModel> data = await repo.getProductOfficial(page: state.nexPageProduct == 1 ?  state.nexPageProduct + 1 : state.nexPageProduct, idCategory: state.idCategory);
      print("Hit Product load");

      if (data.list.isEmpty) {
        refreshCtrl.loadNoData();  // Menandakan tidak ada data lagi
        return;
      }
      emit(state.copyWith(
          nexPageProduct: data.pagination.currentPage < data.pagination.totalPages
          ? data.pagination.currentPage + 1
          : data.pagination.currentPage,
          product: [...state.product, ...data.list],
          pagination: data.pagination,
        )
      );
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

      PaginationModel<ProductModel> data = await repo.getProductOfficial(idCategory: event.idCategory);
      
      emit(state.copyWith(
          idCategory: null,
          product: data.list,
          nexPageProduct: data.pagination.currentPage,
          pagination: data.pagination,
          loading: false,
        )
      );

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
    emit(state.copyWith(loading: true));

    print("Refresh kategori id: ${event.idCategory}");

    var value = await repo.getProductOfficial(idCategory: event.idCategory);

    emit(state.copyWith(
      idCategory: event.idCategory,
      product: value.list,
      loading: false,
      pagination: value.pagination,
    ));

    print("==== After Emit - State.idCategory: ${state.idCategory} ====");
    print("======== [END DEBUGGING] ========");
  } catch (e) {
    print("Error: $e");
    rethrow;
  }
}








  FutureOr<void> _onToggleSelection(ToggleSelection event, Emitter<ShopState> emit) async {
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
}
