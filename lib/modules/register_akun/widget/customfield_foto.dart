import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/register_akun_cubit.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../../../misc/colors.dart';
import '../../../misc/text_style.dart';

class CustomfieldFoto extends StatelessWidget {
  const CustomfieldFoto({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterAkunCubit, RegisterAkunState>(
      builder: (context, state) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => _showImagePicker(context),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.whiteColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white, width: 1),
                ),
                child: state.fileImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(state.fileImage!,
                            fit: BoxFit.cover, width: 100, height: 100),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt, color: Colors.white, size: 30),
                        ],
                      ),
              ),
            ),
            SizedBox(width: 12),
            Text(
              "Foto Profile",
              style: AppTextStyles.textStyleNormal.copyWith(
                color: AppColors.whiteColor,
              ),
            ),
          ],
        );
      },
    );
  }

  void _showImagePicker(BuildContext context) {
    final foto = context.read<RegisterAkunCubit>();

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return BlocProvider.value(
          value: foto,
          child: _ImagePickerBottomSheet(),
        );
      },
    );
  }
}

class _ImagePickerBottomSheet extends StatelessWidget {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        ListTile(
          leading: Icon(Icons.image, color: AppColors.blueColor),
          title: Text("Pilih dari Galeri"),
          onTap: () => _pickImage(context, ImageSource.gallery),
        ),
        ListTile(
          leading: Icon(Icons.camera_alt, color: AppColors.secondaryColor),
          title: Text("Gunakan Kamera"),
          onTap: () => _pickImage(context, ImageSource.camera),
        ),
        if (context.read<RegisterAkunCubit>().state.fileImage != null)
          ListTile(
            leading: Icon(Icons.delete, color: AppColors.redColor),
            title: Text("Hapus Foto"),
            onTap: () {
              context.read<RegisterAkunCubit>().copyState(
                  newState: context.read<RegisterAkunCubit>().state.copyWith(
                        fileImage: () => null,
                      ));
              Navigator.pop(context);
            },
          ),
      ],
    );
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        preferredCameraDevice: CameraDevice.front,
      );

      if (pickedFile != null) {
        final croppedFile = await _cropImage(pickedFile.path);
        if (croppedFile != null) {
          context.read<RegisterAkunCubit>().copyState(
                newState: context
                    .read<RegisterAkunCubit>()
                    .state
                    .copyWith(fileImage: () => File(croppedFile.path)),
              );
        }
      }
    } catch (e) {
      debugPrint('Error picking/cropping image: $e');
    } finally {
      Navigator.pop(context);
    }
  }

  Future<CroppedFile?> _cropImage(String filePath) async {
    return await ImageCropper().cropImage(
      sourcePath: filePath,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Foto',
          toolbarColor: AppColors.secondaryColor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: 'Crop Foto',
          aspectRatioLockEnabled: true,
        ),
      ],
    );
  }
}
