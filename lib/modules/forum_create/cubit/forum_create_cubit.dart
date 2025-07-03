import 'dart:io';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import '../../../misc/text_style.dart';
import '../../../misc/snackbar.dart';
import '../../../repositories/forum_repository/forum_repository.dart';
import 'package:multi_image_picker_plus/multi_image_picker_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:filesize/filesize.dart';
import 'package:video_compress_v2/video_compress_v2.dart';

import '../../../misc/injections.dart';

part 'forum_create_state.dart';

class ForumCreateCubit extends Cubit<ForumCreateState> {
  ForumCreateCubit() : super(ForumCreateState());

  bool? isImage;

  List<File> pickedFile = [];
  List<Asset> resultList = [];
  List<Asset> images = [];

  File? docFile;
  Uint8List? videoFileThumbnail;
  String? videoSize;

  ForumRepository repo = getIt<ForumRepository>();

  void copyState({required ForumCreateState newState}) {
    emit(newState);
  }

  void removeAllPickedFile() {
    emit(state.copyWith(pickedFile: []));
  }

  void removeFileAt(int index) {
    var newImage = List.from(state.pickedFile)..removeAt(index);
    emit(state.copyWith(pickedFile: [...newImage]));
  }

  Future<void> createForum(BuildContext context) async {
    emit(state.copyWith(loading: true));

    try {
      if (state.description.trim().isEmpty) {
        ShowSnackbar.snackbar(
          context,
          "Keterangan tidak boleh kosong",
          isSuccess: false,
        );
        emit(state.copyWith(loading: false));
        return;
      }

      List<Map<String, dynamic>> remaplink = [];

      // Cek apakah ada file yang dipilih sebelum mengunggah media
      if (state.pickedFile.isNotEmpty) {
        final linkImage = await repo.postMedia(
          folder: "images",
          media: state.pickedFile,
        );

        remaplink = linkImage
            .map((e) => {'link': e['url'], 'type': state.feedType})
            .toList();
      }

      debugPrint('Media yang diunggah: $remaplink');

      await repo.createForum(
        description: state.description,
        medias: remaplink,
      );

      // Jika berhasil, munculkan snackbar sukses
      if (context.mounted) {
        ShowSnackbar.snackbar(
          context,
          "Berhasil membuat Forum",
          isSuccess: true,
        );
      }
    } catch (e) {
      debugPrint("Error: $e");

      if (context.mounted) {
        ShowSnackbar.snackbar(
          context,
          e.toString(),
          isSuccess: true,
        );
      }
    } finally {
      emit(state.copyWith(loading: false));
    }
  }

  Future<File> compressImage(String filePath) async {
    final file = File(filePath);
    final extension = file.path.split('.').last.toLowerCase();

    if (extension == 'png') {
      throw Exception("File PNG tidak diperbolehkan.");
    }

    final directory = await getTemporaryDirectory();
    final targetPath =
        '${directory.path}/compressed_${file.uri.pathSegments.last}';

    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 80,
    );

    return result != null ? File(result.path) : file;
  }

  Future<void> uploadImg(BuildContext context) async {
    ImageSource? imageSource = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Pilih Photo", style: AppTextStyles.textStyleBold),
        actions: [
          MaterialButton(
            child: Text("Camera",
                style: AppTextStyles.textStyleNormal.copyWith(fontSize: 14)),
            onPressed: () => Navigator.pop(context, ImageSource.camera),
          ),
          MaterialButton(
            child: Text("Gallery",
                style: AppTextStyles.textStyleNormal.copyWith(fontSize: 14)),
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
          ),
        ],
      ),
    );

    if (imageSource == null) return;

    final picker = ImagePicker();

    if (imageSource == ImageSource.camera) {
      final XFile? xf =
          await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
      if (xf != null) {
        final file = File(xf.path);
        emit(state.copyWith(pickedFile: [file], feedType: "image"));
      }
    }

    if (imageSource == ImageSource.gallery) {
      final xfiles = await picker.pickMultiImage(
        imageQuality: 80,
        limit: 8,
      );

      // Validasi manual tambahan
      final limitedXfiles = xfiles.take(8).toList();
      if (xfiles.length > 8) {
        if (context.mounted) {
          ShowSnackbar.snackbar(
            context,
            "Maksimal 8 gambar yang dapat dipilih.",
            isSuccess: false,
          );
        }
        return;
      }

      List<File> newImages = [];
      double totalSize = 0;

      for (final xfile in limitedXfiles) {
        final file = File(xfile.path);
        final extension = xfile.path.split('.').last.toLowerCase();

        if (extension == 'png') {
          if (context.mounted) {
            ShowSnackbar.snackbar(
              context,
              "Gambar PNG tidak diperbolehkan.",
              isSuccess: false,
            );
          }
          continue;
        }

        File compressedFile = await compressImage(file.path);
        newImages.add(compressedFile);
        int sizeInBytes = compressedFile.lengthSync();
        totalSize += sizeInBytes / (1024 * 1024);
      }

      emit(state.copyWith(
        pickedFile: newImages,
        feedType: "image",
        fileSize: totalSize.toStringAsFixed(2),
      ));
    }
  }

  Future<void> uploadVid(BuildContext context) async {
    ImageSource? videoSource = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Pilih Video",
          style: AppTextStyles.textStyleBold,
        ),
        actions: [
          TextButton(
            child: Text(
              "Camera",
              style: AppTextStyles.textStyleNormal.copyWith(fontSize: 14),
            ),
            onPressed: () => Navigator.pop(context, ImageSource.camera),
          ),
          TextButton(
            child: Text(
              "Gallery",
              style: AppTextStyles.textStyleNormal.copyWith(fontSize: 14),
            ),
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
          ),
        ],
      ),
    );

    if (videoSource == null) return;

    final XFile? pickedVideo = await ImagePicker().pickVideo(
      source: videoSource,
      maxDuration: const Duration(minutes: 10),
    );

    if (pickedVideo == null) return;

    File videoFile = File(pickedVideo.path);
    int sizeInBytes = videoFile.lengthSync();
    double sizeInMb = sizeInBytes / (1024 * 1024);

    if (sizeInMb > 200) {
      if (context.mounted) {
        ShowSnackbar.snackbar(
          context,
          "Video Maksimal 200 MB",
          isSuccess: false,
        );
      }
      return;
    }

    final Uint8List? thumbnail =
        await VideoCompressV2.getByteThumbnail(videoFile.path);
    final String videoSizeStr = filesize(sizeInBytes, 0);

    emit(state.copyWith(
      pickedFile: [videoFile],
      feedType: "video",
      videoFileThumbnail: thumbnail,
      fileSize: videoSizeStr,
    ));
  }

  Future<void> uploadDoc(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: ['pdf', 'doc', 'xlsx', 'rar', 'txt', 'zip'],
        withData: false,
        withReadStream: true,
        onFileLoading: (FilePickerStatus filePickerStatus) {});
    List<File> newfile = [];
    String docNames = "";
    // ignore: unused_local_variable
    String sizeDoc = "";
    if (result != null) {
      File vf = File(result.files.single.path!);
      int sizeInBytes = vf.lengthSync();
      double sizeInMb = sizeInBytes / (1024 * 1024);
      debugPrint('Ukuran ${sizeInMb.toString()}');
      if (sizeInMb > 5 && context.mounted) {
        // ignore: use_build_context_synchronously
        ShowSnackbar.snackbar(
          context,
          "File Maksimal 5 MB",
          isSuccess: false,
        );
        return;
      }
      docFile = vf;
      docNames = vf.path.toString().split('/').last;
      sizeDoc = filesize(sizeInBytes, 0);
      newfile.add(File(vf.path));
    }
    emit(state.copyWith(
        pickedFile: newfile,
        feedType: "file",
        docName: docNames,
        fileSize: sizeDoc));
  }
}
