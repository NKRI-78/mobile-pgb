import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../misc/snackbar.dart';
import '../../../repositories/create_forum_repository/create_forum_repository.dart';
import '../../../repositories/oder_repository/models/need_riview_model.dart';
import '../../../repositories/oder_repository/order_repository.dart';
import 'package:multi_image_picker_plus/multi_image_picker_plus.dart';

part 'need_riview_state.dart';

class NeedRiviewCubit extends Cubit<NeedRiviewState> {
  NeedRiviewCubit() : super(const NeedRiviewState());

  OrderRepository repo = OrderRepository();
  CreateForumRepository repoForum = CreateForumRepository();
  final ImagePicker _picker = ImagePicker();

  void copyState({required NeedRiviewState newState}) {
    emit(newState);
  }

  Future<void> getNeedRiview() async {
    try {
      emit(const NeedRiviewState());
      emit(state.copyWith(loading: true));
      final needRiviewModel = await repo.getNeedRiview();
      emit(state.copyWith(needRiviewModel: needRiviewModel, loading: false));
    } on SocketException {
      throw "Terjadi kesalahan jaringan";
    } finally {
      emit(state.copyWith(loading: false));
    }
  }

  Future<void> uploadImg(BuildContext context, String produkId, String aspect,
      {int max = 3}) async {
    ImageSource? imageSource = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Choose Image"),
        actions: [
          TextButton(
            child: const Text("Camera"),
            onPressed: () => Navigator.pop(context, ImageSource.camera),
          ),
          TextButton(
            child: const Text("Gallery"),
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
          ),
        ],
      ),
    );

    if (imageSource == null) return;

    final updatedMap =
        Map<String, Map<String, List<File>>>.from(state.pickedFile);

    final productImages =
        Map<String, List<File>>.from(updatedMap[produkId] ?? {});
    final currentList = List<File>.from(productImages[aspect] ?? []);

    if (currentList.length >= max) return;

    XFile? xf;
    if (imageSource == ImageSource.camera) {
      xf = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 80);
    } else {
      xf = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 80);
    }

    if (xf != null) {
      final file = File(xf.path);
      currentList.add(file);

      productImages[aspect] = currentList;
      updatedMap[produkId] = productImages;

      emit(state.copyWith(pickedFile: updatedMap));
    }
  }

  Future<void> userRating(String idOrder, BuildContext context) async {
    try {
      emit(state.copyWith(loadingSubmit: true));
      print("Id Order : $idOrder");
      print("Rating : ${state.productRatings[idOrder].toString()}");
      final imagesForProduct = state.pickedFile[idOrder];

      final imageFiles = imagesForProduct?['gallery'] ?? [];

      print("File Image : $imageFiles");
      final linkImage =
          await repoForum.postMedia(folder: "images", media: imageFiles);
      print("Link Image : $linkImage");
      final remaplink = linkImage.map((link) => link.toString()).toList();

      print("Remap Image : $remaplink");

      final message = state.productMessages[idOrder] ?? "";

      await repo.userRating(
        idOrder: idOrder,
        images: remaplink,
        message: message,
        rating: int.parse(state.productRatings[idOrder].toString()),
      );

      if (context.mounted) {
        // Navigator.pop(context);
        ShowSnackbar.snackbar(context, "Berhasil memberikan penilaian",
            isSuccess: true);
        emit(state.copyWith(loadingSubmit: false));
      }

      emit(state.copyWith(loading: true));
      final needRiview = await repo.getNeedRiview();
      emit(state.copyWith(needRiviewModel: needRiview, loading: false));
    } on SocketException {
      throw "Terjadi kesalahan jaringan";
    } catch (e) {
      rethrow;
    } finally {
      emit(state.copyWith(loading: false));
    }
  }

  // void removeAllPickedFile() {
  //   emit(state.copyWith(pickedFile: []));
  // }

  void removeFileAt(String produkId, int index) {
    final updatedMap = Map<String, List<File>>.from(state.pickedFile);

    if (updatedMap.containsKey(produkId)) {
      final updatedList = List<File>.from(updatedMap[produkId]!);

      if (index >= 0 && index < updatedList.length) {
        updatedList.removeAt(index);
        updatedMap[produkId] = updatedList; // Set list baru

        // emit(state.copyWith(pickedFile: updatedMap));
      }
    }
  }

  void removeImage(String produkId, String aspect, int index) {
    final updatedMap =
        Map<String, Map<String, List<File>>>.from(state.pickedFile);

    final productImages =
        Map<String, List<File>>.from(updatedMap[produkId] ?? {});
    final currentList = List<File>.from(productImages[aspect] ?? []);

    if (index < 0 || index >= currentList.length) return;

    currentList.removeAt(index);
    productImages[aspect] = currentList;
    updatedMap[produkId] = productImages;

    emit(state.copyWith(pickedFile: updatedMap));
  }

  void updateRating(String productId, int rating) {
    final updated = Map<String, int>.from(state.productRatings);
    updated[productId] = rating;
    emit(state.copyWith(productRatings: updated));
  }

  void setMessage(String productId, String message) {
    final updated = Map<String, String>.from(state.productMessages)
      ..[productId] = message;
    emit(state.copyWith(productMessages: updated));
  }
}
