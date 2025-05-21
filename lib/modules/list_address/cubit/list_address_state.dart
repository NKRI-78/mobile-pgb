part of 'list_address_cubit.dart';

class ListAddressState extends Equatable {
  final List<AddressListModel> address;
  final bool loading;
  
  const ListAddressState({
    this.address = const [],
    this.loading = false,
  });

  @override
  List<Object> get props => [
    address,
    loading,
  ];

  ListAddressState copyWith({
    List<AddressListModel>? address,
    bool? loading,
  }) {
    return ListAddressState(
      address: address ?? this.address,
      loading: loading ?? this.loading,
    );
  }
}
