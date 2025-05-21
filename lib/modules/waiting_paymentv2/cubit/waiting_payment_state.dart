// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'waiting_payment_cubit.dart';

class WaitingPaymentState extends Equatable {
  final PaymentModel? payment;
  final bool loading;
  final int tabIndex;

  const WaitingPaymentState({
    this.payment,
    this.loading = true,
    this.tabIndex = 0,
  });

  @override
  List<Object?> get props => [payment, loading];

  WaitingPaymentState copyWith({
    PaymentModel? payment,
    bool? loading,
    int? tabIndex,
  }) {
    return WaitingPaymentState(
      payment: payment ?? this.payment,
      loading: loading ?? this.loading,
      tabIndex: tabIndex ?? this.tabIndex,
    );
  }
}
