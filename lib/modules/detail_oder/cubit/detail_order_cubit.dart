import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_pgb/misc/snackbar.dart';
import 'package:mobile_pgb/repositories/create_forum_repository/create_forum_repository.dart';
import 'package:mobile_pgb/repositories/detail_order_repository/detail_order_repository.dart';
import 'package:mobile_pgb/repositories/detail_order_repository/models/detail_order_model.dart';
import 'package:multi_image_picker_plus/multi_image_picker_plus.dart';
import 'package:photo_manager/photo_manager.dart';

part 'detail_order_state.dart';

class DetailOrderCubit extends Cubit<DetailOrderState> {
  DetailOrderCubit() : super(const DetailOrderState());

  DetailOrderRepository repo = DetailOrderRepository();
  CreateForumRepository repoForum = CreateForumRepository();

  List<String> feedType = [];

  bool? isImage;

  List<File> pickedFile = [];
  List<Asset> resultList = [];
  List<Asset> images = [];

  void copyState({required DetailOrderState newState}) {
    emit(newState);
  }

  Future<void> fetchDetailOrder(String productId, int initIndex) async {
    try {
      emit(state.copyWith(loading: true));
      final detailOrder = await repo.getDetailOrder(productId);
      emit(state.copyWith(detailOrder: detailOrder, initIndex: initIndex, idOrder: int.parse(productId)));
    } on SocketException {
      throw "Terjadi kesalahan jaringan";
    } finally {
      emit(state.copyWith(loading: false));
    }
  }

  Future<void> fetchEndOrder(String idOrder) async {
    try {
      emit(state.copyWith(loading: true));
      await repo.getEndOrder(idOrder);

      final detailOrder = await repo.getDetailOrder(idOrder);
      emit(state.copyWith(detailOrder: detailOrder, loading: false));
    } on SocketException {
      throw "Terjadi kesalahan jaringan";
    } catch (e) {
      rethrow;
    } finally {
      emit(state.copyWith(loading: false));
    }
  }

  Future<void> uploadImg(BuildContext context, String produkId) async {
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

  final updatedMap = Map<String, List<File>>.from(state.pickedFile);

  if (imageSource == ImageSource.camera) {
      final XFile? xf = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      if (xf != null) {
        final file = File(xf.path);
        updatedMap[produkId] = [...(updatedMap[produkId] ?? []), file];
        emit(state.copyWith(pickedFile: updatedMap, feedType: "image"));
        print("Test Update Map : $updatedMap");
      }
    }

    if (imageSource == ImageSource.gallery) {
      // Minta izin akses
      final permission = await PhotoManager.requestPermissionExtend();
      if (!permission.isAuth) {
        PhotoManager.openSetting();
        return;
      }

      // Ambil semua foto
      List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        onlyAll: true,
      );

      List<AssetEntity> photos = await albums.first.getAssetListPaged(page: 0, size: 100);

      // Tampilkan dialog untuk memilih beberapa gambar
      final selectedAssets = await showDialog<List<AssetEntity>>(
        context: context,
        builder: (ctx) => SimpleDialog(
          title: const Text("Pilih Gambar (max 8)"),
          children: photos.take(8).map((asset) {
            return SimpleDialogOption(
              onPressed: () => Navigator.pop(ctx, [asset]),
              child: FutureBuilder<Uint8List?>(
                future: asset.thumbnailDataWithSize(const ThumbnailSize(100, 100)),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Image.memory(snapshot.data!, height: 80, fit: BoxFit.cover);
                  } else {
                    return const SizedBox(height: 80, child: Center(child: CircularProgressIndicator()));
                  }
                },
              ),
            );
          }).toList(),
        ),
      );

      if (selectedAssets == null || selectedAssets.isEmpty) return;

      List<File> files = [];
      for (final asset in selectedAssets) {
        final file = await asset.file;
        if (file != null) {
          files.add(file);
        }
      }

      updatedMap[produkId] = [...(updatedMap[produkId] ?? []), ...files];
      emit(state.copyWith(pickedFile: updatedMap, feedType: "image"));
      print("Test Update Map : $updatedMap");
    }
  }

  Future<void> userRating(String idOrder,  BuildContext context) async {
    try {
 
      print("Id Order : $idOrder");
      final imageFiles = state.pickedFile[idOrder] ?? [];
      print("File Image : $imageFiles");
      final linkImage = await repoForum.postMedia(folder: "images", media: imageFiles);
      print("Link Image : $linkImage");
      final remaplink = linkImage.map((link) => link.toString()).toList();

      print("Remap Image : $remaplink");

      await repo.userRating(
        idOrder: idOrder,
        images: remaplink,
        message: state.message,
        rating: state.rating,
      );
      
      if(context.mounted){
        // Navigator.pop(context);
        ShowSnackbar.snackbar(context, "Berhasil memberikan rating", isSuccess: true);
      }

      emit(state.copyWith(loading: true));
      final detailOrder = await repo.getDetailOrder(idOrder);
      emit(state.copyWith(detailOrder: detailOrder, loading: false));
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
    if (updatedMap[produkId] != null && updatedMap[produkId]!.length > index) {
      updatedMap[produkId]!.removeAt(index);
      emit(state.copyWith(pickedFile: updatedMap));
    }
  }
}
