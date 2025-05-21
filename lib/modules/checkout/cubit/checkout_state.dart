part of 'checkout_cubit.dart';

class CheckoutState extends Equatable {
  final SelectedAdministration? selectedAdministration;
  final List<CheckoutDetailModel> checkout;
  final List<CostItemModelV2> cost;
  final List<PaymentChannelModel> channels;
  final PaymentChannelModel? channel;
  final CheckoutDetailNowModel? checkoutNow;
  final MainShippingModel? shipping;
  final String weight;
  final String from;
  final String qty;
  final String productId;
  final double totalWeight;
  final double totalPrice;
  final double totalCost;
  final double totalPriceProduct;
  final double adminFee;
  final String storeId;
  final bool loading;
  final bool loadingCost; 
  final bool loadingCurir; 
  final bool loadingChannel; 
  final Set<String> loadingItems;
  final Map<String, dynamic>? shippings;


  const CheckoutState({
    this.shippings,
    this.selectedAdministration,
    this.checkout = const [], 
    this.cost = const [],
    this.channels = const [], 
    this.channel, 
    this.shipping,
    this.weight = "",
    this.from = "",
    this.qty = "",
    this.productId = "",
    this.totalWeight = 0.0,
    this.totalPrice = 0.0,
    this.totalPriceProduct = 0.0,
    this.totalCost = 0.0,
    this.adminFee = 0.0,
    this.storeId = "",
    this.loading = false,
    this.loadingCost = false,
    this.loadingCurir = false,
    this.loadingChannel = false,
    this.loadingItems = const {},
    this.checkoutNow, 
  });

  @override
  List<Object?> get props => [
    channels, 
    channel,
    shippings,
    selectedAdministration, 
    cost, 
    checkout, 
    shipping, 
    loading, 
    weight, 
    from, 
    qty, 
    productId, 
    totalWeight, 
    totalPrice, 
    totalPriceProduct, 
    totalCost, 
    adminFee, 
    storeId,
    loadingCost,
    loadingCurir,
    loadingChannel,
    checkoutNow,
  ];

  CheckoutState copyWith({
    SelectedAdministration? selectedAdministration,
    List<CheckoutDetailModel>? checkout,
    List<CostItemModelV2>? cost,
    List<PaymentChannelModel>? channels,
    PaymentChannelModel? channel,
    CheckoutDetailNowModel? checkoutNow,
    MainShippingModel? shipping,
    String? weight,
    String? from,
    String? qty,
    String? productId,
    String? storeId,
    double? totalWeight,
    double? totalPrice,
    double? totalPriceProduct,
    double? totalCost,
    double? adminFee,
    bool? loading,
    bool? loadingCost,
    bool? loadingCurir,
    bool? loadingChannel,
    Set<String>? loadingItems,
    Map<String, dynamic>? shippings
  }) {
    return CheckoutState(
      selectedAdministration: selectedAdministration ?? this.selectedAdministration,
      checkout: checkout ?? this.checkout,
      cost: cost ?? this.cost,
      channels: channels ?? this.channels,
      channel: channel ?? this.channel,
      shipping: shipping ?? this.shipping,
      weight: weight ?? this.weight,
      from: from ?? this.from,
      qty: qty ?? this.qty,
      productId: productId ?? this.productId,
      storeId: storeId ?? this.storeId,
      totalWeight: totalWeight ?? this.totalWeight,
      totalPrice: totalPrice ?? this.totalPrice,
      totalPriceProduct: totalPriceProduct ?? this.totalPriceProduct,
      totalCost: totalCost ?? this.totalCost,
      adminFee: adminFee ?? this.adminFee,
      loading: loading ?? this.loading,
      loadingCost: loadingCost ?? this.loadingCost,
      loadingCurir: loadingCurir ?? this.loadingCurir,
      loadingChannel: loadingChannel ?? this.loadingChannel,
      loadingItems: loadingItems ?? this.loadingItems,
      shippings: shippings ?? this.shippings,
      checkoutNow: checkoutNow ?? this.checkoutNow,
    );
  }
}
