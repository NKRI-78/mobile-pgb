// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShopState _$ShopStateFromJson(Map<String, dynamic> json) => ShopState(
      category: (json['category'] as List<dynamic>?)
              ?.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      product: (json['product'] as List<dynamic>?)
              ?.map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      pagination: json['pagination'] == null
          ? null
          : Pagination.fromJson(json['pagination'] as Map<String, dynamic>),
      nexPageProduct: (json['nexPageProduct'] as num?)?.toInt() ?? 0,
      idCategory: (json['idCategory'] as num?)?.toInt() ?? 0,
      loading: json['loading'] as bool? ?? false,
      selectedIds: (json['selectedIds'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toSet() ??
          const {},
      scrollP: (json['scrollP'] as num?)?.toDouble() ?? 0,
      tabIndex: (json['tabIndex'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ShopStateToJson(ShopState instance) => <String, dynamic>{
      'category': instance.category,
      'product': instance.product,
      'pagination': instance.pagination,
      'nexPageProduct': instance.nexPageProduct,
      'idCategory': instance.idCategory,
      'loading': instance.loading,
      'selectedIds': instance.selectedIds.toList(),
      'scrollP': instance.scrollP,
      'tabIndex': instance.tabIndex,
    };
