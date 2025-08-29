part of 'ppob_cubit.dart';

class PpobState extends Equatable {
  final ProfileModel? profile;
  final List<PulsaDataModel> pulsaData;
  final List<ListrikDataModel> listrikData;
  final String? errorMessage;
  final bool isLoading;
  final bool? isSuccess;
  final bool loadingChannel;
  final List<PaymentChannelModelV2> channels;
  final PaymentChannelModelV2? channel;
  final double adminFee;
  final PulsaDataModel? selectedPulsaData;
  final ListrikDataModel? selectedListrikData;
  final String? selectedType;
  final String? idpel;
  final String? paymentCode;

  const PpobState({
    this.profile,
    this.pulsaData = const [],
    this.listrikData = const [],
    this.errorMessage,
    this.isLoading = false,
    this.isSuccess,
    this.loadingChannel = false,
    this.channels = const [],
    this.channel,
    this.adminFee = 0.0,
    this.selectedPulsaData,
    this.selectedListrikData,
    this.selectedType,
    this.idpel,
    this.paymentCode,
  });

  @override
  List<Object?> get props => [
        profile,
        pulsaData,
        listrikData,
        errorMessage,
        isLoading,
        isSuccess,
        loadingChannel,
        channels,
        channel,
        adminFee,
        selectedPulsaData,
        selectedListrikData,
        selectedType,
        idpel,
        paymentCode,
      ];

  PpobState copyWith({
    ProfileModel? profile,
    List<PulsaDataModel>? pulsaData,
    List<ListrikDataModel>? listrikData,
    String? errorMessage,
    bool? isLoading,
    bool? isSuccess,
    bool? loadingChannel,
    List<PaymentChannelModelV2>? channels,
    PaymentChannelModelV2? channel,
    double? adminFee,
    PulsaDataModel? selectedPulsaData,
    ListrikDataModel? selectedListrikData,
    String? selectedType,
    String? idpel,
    String? paymentCode,
  }) {
    return PpobState(
      profile: profile ?? this.profile,
      pulsaData: pulsaData ?? this.pulsaData,
      listrikData: listrikData ?? this.listrikData,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      loadingChannel: loadingChannel ?? this.loadingChannel,
      channels: channels ?? this.channels,
      channel: channel ?? this.channel,
      adminFee: adminFee ?? this.adminFee,
      selectedPulsaData: selectedPulsaData ?? this.selectedPulsaData,
      selectedListrikData: selectedListrikData ?? this.selectedListrikData,
      selectedType: selectedType ?? this.selectedType,
      idpel: idpel ?? this.idpel,
      paymentCode: paymentCode ?? this.paymentCode,
    );
  }
}
