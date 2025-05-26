import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../../../misc/snackbar.dart';
import '../../../misc/theme.dart';
import '../cubit/profile_update_cubit.dart';
import '../../../widgets/button/custom_button.dart';

import '../../../misc/colors.dart';
import '../../../misc/text_style.dart';
import '../../../widgets/photo_view/custom_fullscreen_preview.dart';

class ProfileUpdatePage extends StatelessWidget {
  const ProfileUpdatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileUpdateCubit>(
      create: (context) => ProfileUpdateCubit(),
      child: ProfileUpdateView(),
    );
  }
}

class ProfileUpdateView extends StatefulWidget {
  const ProfileUpdateView({super.key});

  @override
  State<ProfileUpdateView> createState() => _ProfileUpdateViewState();
}

class _ProfileUpdateViewState extends State<ProfileUpdateView> {
  final TextEditingController phoneC = TextEditingController();
  bool isPhoneInitialized = false;

  @override
  void dispose() {
    phoneC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileUpdateCubit, ProfileUpdateState>(
      listener: (context, st) {
        if (st.successMessage.isNotEmpty) {
          ShowSnackbar.snackbar(context, st.successMessage, isSuccess: true);
          Navigator.pop(context);
        }

        if (st.errorMessage != null) {
          ShowSnackbar.snackbar(context, st.errorMessage!, isSuccess: false);
        }
      },
      builder: (context, state) {
        final user = state.profile;

        // Set text hanya sekali ketika profile sudah ada
        if (!isPhoneInitialized && user?.phone != null) {
          phoneC.text = user!.phone!;
          isPhoneInitialized = true;
        }

        return Scaffold(
          backgroundColor: AppColors.primaryColor,
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            title: Text(
              'Profile Edit',
              style: AppTextStyles.textStyleBold,
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Center(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      GestureDetector(
                        onTap: () {
                          String imageUrl = user?.profile?.avatarLink ?? '';
                          _showFullImage(context, imageUrl);
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: state.fileImage != null
                              ? Image.file(
                                  state.fileImage!,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                )
                              : CachedNetworkImage(
                                  imageUrl: user?.profile?.avatarLink ?? '',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(
                                    color: AppColors.secondaryColor,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                    imageDefaultUser,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _showImagePicker(context),
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(color: Colors.grey, width: 1),
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.grey[800],
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.blackColor),
                            ),
                            child: TextFormField(
                              maxLength: 13,
                              controller: phoneC,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                labelText: 'Nomor Telepon',
                                labelStyle: AppTextStyles.textStyleNormal,
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 5,
                                ),
                              ),
                              style: TextStyle(
                                color: AppColors.blackColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        CustomButton(
                          onPressed: () {
                            final cubit = context.read<ProfileUpdateCubit>();
                            cubit.updateProfile(
                              context: context,
                              phone: phoneC.text,
                              avatarFile: cubit.state.fileImage,
                            );
                          },
                          text: "Edit Profile",
                          backgroundColour: AppColors.secondaryColor,
                          textColour: AppColors.whiteColor,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

void _showFullImage(BuildContext context, String imageUrl) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CustomFullscreenPreview(imageUrl: imageUrl),
    ),
  );
}

void _showImagePicker(BuildContext context) {
  final wargaCubit = context.read<ProfileUpdateCubit>();

  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return BlocProvider.value(
        value: wargaCubit,
        child: _ImagePickerBottomSheet(),
      );
    },
  );
}

class _ImagePickerBottomSheet extends StatelessWidget {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        ListTile(
          leading: Icon(Icons.image, color: AppColors.secondaryColor),
          title: Text("Pilih dari Galeri"),
          onTap: () => _pickImage(context, ImageSource.gallery),
        ),
        ListTile(
          leading: Icon(Icons.camera_alt, color: AppColors.secondaryColor),
          title: Text("Gunakan Kamera"),
          onTap: () => _pickImage(context, ImageSource.camera),
        ),
        if (context.read<ProfileUpdateCubit>().state.fileImage != null)
          ListTile(
            leading: Icon(Icons.delete, color: AppColors.redColor),
            title: Text("Hapus Foto"),
            onTap: () {
              context.read<ProfileUpdateCubit>().copyState(
                  newState: context.read<ProfileUpdateCubit>().state.copyWith(
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
          context.read<ProfileUpdateCubit>().copyState(
                newState: context
                    .read<ProfileUpdateCubit>()
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
