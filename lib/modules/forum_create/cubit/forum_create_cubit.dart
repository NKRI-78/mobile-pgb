import 'dart:io';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
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
        title: const Text("Choose Image"),
        actions: [
          MaterialButton(
            child: const Text("Camera"),
            onPressed: () => Navigator.pop(context, ImageSource.camera),
          ),
          MaterialButton(
            child: const Text("Gallery"),
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
          ),
        ],
      ),
    );

    List<File> newCamera = [];

    if (imageSource == ImageSource.camera) {
      XFile? xf = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 80);
      if (xf != null) {
        newCamera.add(File(xf.path));
        copyState(newState: state.copyWith(pickedFile: pickedFile));
        isImage = true;
      }
      emit(state.copyWith(pickedFile: newCamera, feedType: "image"));
    }

    List<File> newImages = [];
    double totalSize = 0;
    if (imageSource == ImageSource.gallery) {
      resultList = await MultiImagePicker.pickImages(
        androidOptions: const AndroidOptions(maxImages: 8),
        iosOptions: const IOSOptions(
            settings: CupertinoSettings(list: ListSetting(cellsPerRow: 8))),
        selectedAssets: images,
      );

      for (var imageAsset in resultList) {
        ByteData byteData = await imageAsset.getByteData();
        Uint8List uint8List = byteData.buffer.asUint8List();

        final directory = await getTemporaryDirectory();
        File tempFile = File('${directory.path}/${imageAsset.name}');
        await tempFile.writeAsBytes(uint8List);

        final extension = imageAsset.name.split('.').last.toLowerCase();
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
        File compressedFile = await compressImage(tempFile.path);
        newImages.add(compressedFile);
        int sizeInBytes = compressedFile.lengthSync();
        totalSize += sizeInBytes / (1024 * 1024);
        isImage = true;
      }
      emit(state.copyWith(
        pickedFile: newImages,
        feedType: "image",
        fileSize: totalSize.toStringAsFixed(2),
      ));
    }
  }

  // Future<void> uploadVid(BuildContext context) async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //       type: FileType.custom,
  //       allowedExtensions: [
  //         'mp4',
  //         'avi',
  //         'mkv',
  //         'mov',
  //         '3gp',
  //         'wmv',
  //         'flv',
  //         'mpeg',
  //         'mpg',
  //         'webm'
  //       ],
  //       allowMultiple: false,
  //       withData: false,
  //       withReadStream: true,
  //       onFileLoading: (FilePickerStatus filePickerStatus) {});
  //   List<File> newVideo = [];
  //   if (result != null) {
  //     File vf = File(result.files.single.path!);
  //     int sizeInBytes = vf.lengthSync();
  //     double sizeInMb = sizeInBytes / (1024 * 1024);
  //     debugPrint('Ukuran ${sizeInMb.toString()}');
  //     if (sizeInMb > 200) {
  //       Future.delayed(Duration.zero, () {
  //         ShowSnackbar.snackbar(
  //           context,
  //           "Video Maksimal 200 MB",
  //           isSuccess: false,
  //         );
  //       });
  //       return;
  //     }
  //     newVideo.add(File(vf.path));
  //     // emit(state.copyWith(pickedFile: pickedFile));
  //     videoFileThumbnail = await VideoCompressV2.getByteThumbnail(vf.path);
  //     videoSize = filesize(sizeInBytes, 0);
  //     emit(state.copyWith(
  //         pickedFile: newVideo,
  //         feedType: "video",
  //         videoFileThumbnail: videoFileThumbnail,
  //         fileSize: videoSize));
  //   }
  // }
  Future<void> uploadVid(BuildContext context) async {
    ImageSource? videoSource = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Pilih Video"),
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
