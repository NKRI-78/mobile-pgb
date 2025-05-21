part of 'cart_cubit.dart';

class CartState extends Equatable {
  final List<CartModel> cart;
  final bool loading;
  final int totalPrice;

  const CartState({
    this.cart = const [],
    this.loading = false,
    this.totalPrice = 0
  });

  @override
  List<Object> get props => [cart, loading, totalPrice];

  CartState copyWith({
    List<CartModel>? cart,
    bool? loading,
    int? totalPrice,
  }) {
    return CartState(
      cart: cart ?? this.cart,
      loading: loading ?? this.loading,
      totalPrice: totalPrice ?? this.totalPrice
    );
  }
}
