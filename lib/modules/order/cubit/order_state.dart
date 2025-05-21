part of 'order_cubit.dart';

class OrderState extends Equatable {
  final List<OrderModel> order;
  final BadgesOrderModel? badges;
  final List<WaitingPaymentModel> waitingPayment;
  final int nexPageOrder;
  final Pagination? pagination;
  final bool loading;
  final String status;
  final double scrollP;
  final int tabIndex;
  
  const OrderState({
    this.badges,
    this.order = const [],
    this.waitingPayment = const [],
    this.loading = false,
    this.pagination,
    this.nexPageOrder = 0,
    this.status = "",
    this.scrollP = 0.0,
    this.tabIndex = 0,
  });

  @override
  List<Object?> get props => [
    badges,
    order,
    waitingPayment,
    loading,
    pagination,
    nexPageOrder,
    status,
    scrollP,
    tabIndex,
  ];
  
  OrderState copyWith({
    List<OrderModel>? order,
    BadgesOrderModel? badges,
    List<WaitingPaymentModel>? waitingPayment,
    bool? loading,
    Pagination? pagination,
    int? nexPageOrder,
    String? status,
    double? scrollP,
    int? tabIndex,
  }) {
    return OrderState(
      order: order ?? this.order,
      badges: badges ?? this.badges,
      waitingPayment: waitingPayment ?? this.waitingPayment,
      loading: loading ?? this.loading,
      pagination: pagination ?? this.pagination,
      nexPageOrder: nexPageOrder ?? this.nexPageOrder,
      status: status ?? this.status,
      scrollP: scrollP ?? this.scrollP,
      tabIndex: tabIndex ?? this.tabIndex,
    );
  }
}
