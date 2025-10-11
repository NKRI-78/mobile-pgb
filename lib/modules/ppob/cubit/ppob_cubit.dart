import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../misc/colors.dart';
import '../../../misc/injections.dart';
import '../../../repositories/ppob_repository/models/listrik_data_model.dart';
import '../../../repositories/ppob_repository/models/payment_channel_modelv2.dart';
import '../../../repositories/ppob_repository/models/pulsa_data_model.dart';
import '../../../repositories/ppob_repository/ppob_repository.dart';
import '../../../repositories/profile_repository/models/profile_model.dart';
import '../../../repositories/profile_repository/profile_repository.dart';
import '../widget/select_payment_channel.dart';

part 'ppob_state.dart';

class PpobCubit extends Cubit<PpobState> {
  PpobCubit() : super(const PpobState());

  PpobRepository repo = getIt<PpobRepository>();
  ProfileRepository repoProfile = getIt<ProfileRepository>();

  String? _currentType;

  void copyState({required PpobState newState}) {
    emit(newState);
  }

  void setProfile(ProfileModel profile) {
    emit(state.copyWith(profile: profile));
  }

  Future<void> fetchListrikData() async {
    emit(state.copyWith(isLoading: true, errorMessage: null, isSuccess: null));
    _currentType = "PLN";

    try {
      final data = await repo.fetchListrikData();

      emit(state.copyWith(
        listrikData: data,
        isLoading: false,
        isSuccess: true,
        errorMessage: null,
      ));
    } catch (e) {
      debugPrint("Error fetching listrik data: $e");

      emit(state.copyWith(
        errorMessage: e.toString(),
        isLoading: false,
        isSuccess: false,
      ));
    }
  }

  void setSelectedListrik(ListrikDataModel item) {
    emit(state.copyWith(selectedListrikData: item));
  }

  Future<void> getProfile() async {
    try {
      emit(state.copyWith(isLoading: true));

      final profile = await repoProfile.getProfile();

      emit(state.copyWith(
        profile: profile,
      ));
    } catch (e) {
      emit(state.copyWith(errorMessage: "Gagal memuat profil: $e"));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> fetchPulsaData(
      {required String prefix, required String type}) async {
    emit(state.copyWith(isLoading: true, errorMessage: null, isSuccess: null));
    _currentType = type;

    try {
      final data = await repo.fetchPulsaData(prefix: prefix, type: type);

      emit(state.copyWith(
        pulsaData: data,
        isLoading: false,
        isSuccess: true,
        errorMessage: null,
      ));
    } catch (e) {
      debugPrint("Error fetching pulsa data: $e");

      emit(state.copyWith(
        errorMessage: e.toString(),
        isLoading: false,
        isSuccess: false,
      ));
    }
  }

  String? get currentType => _currentType;

  Future<void> getPaymentChannel(BuildContext context) async {
    try {
      emit(state.copyWith(loadingChannel: true));
      var channels = await repo.getChannels();

      if (context.mounted) {
        showModalBottomSheet(
          context: context,
          builder: (_) => BlocProvider<PpobCubit>.value(
            value: context.read<PpobCubit>(),
            child: SelectPaymentChannel(),
          ),
        );
      }

      emit(state.copyWith(channels: channels, loadingChannel: false));
    } catch (e) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.redColor,
          content: Text(
            e.toString(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    } finally {
      emit(state.copyWith(loadingChannel: false));
    }
  }

  Future<Map<String, dynamic>?> checkoutItem(
      String userId, String type, String idPel) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));

      if (idPel.isEmpty) {
        throw ("Nomor pelanggan tidak boleh kosong.");
      }

      if (state.channel == null) {
        throw ("Silakan pilih metode pembayaran terlebih dahulu.");
      }
      if (state.selectedPulsaData == null) {
        throw ("Silakan pilih produk pulsa atau data.");
      }

      final PulsaDataModel selectedProduct = state.selectedPulsaData!;

      final Map<String, dynamic> paymentData = await repo.checkoutItem(
        idPel: idPel,
        userId: userId,
        productId: selectedProduct.code ?? "",
        paymentChannel: state.channel?.id ?? 0,
        paymentCode: state.channel?.nameCode ?? "",
        type: type,
      );

      debugPrint("Checkout Success: $paymentData");

      emit(state.copyWith(
        isLoading: false,
        isSuccess: true,
      ));

      return paymentData;
    } catch (e) {
      debugPrint("Checkout Error: $e");

      emit(state.copyWith(
        isLoading: false,
        isSuccess: false,
        errorMessage: e.toString(),
      ));

      return null;
    }
  }

  /// **Menyimpan metode pembayaran yang dipilih**
  void setPaymentChannel(PaymentChannelModelV2 channel) {
    emit(state.copyWith(
      channel: channel,
      adminFee: (channel.fee ?? 0).toDouble(),
    ));
  }

  // Fungsi untuk menghapus data saat kategori LISTRIK dipilih
  void clearPulsaData() {
    _currentType = null;
    emit(state.copyWith(pulsaData: [], isSuccess: null, errorMessage: null));
  }
}
