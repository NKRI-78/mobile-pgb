import 'package:bloc/bloc.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:equatable/equatable.dart';

part 'register_ktp_state.dart';

class RegisterKtpCubit extends Cubit<RegisterKtpState> {
  RegisterKtpCubit() : super(const RegisterKtpState());

  void copyState({required RegisterKtpState newState}) {
    emit(newState);
  }

  Future<void> scanKtp() async {
    emit(state.copyWith(loading: true));

    try {
      // Capture the image
      final images = await CunningDocumentScanner.getPictures(
        isGalleryImportAllowed: true,
        noOfPages: 1,
      );

      if (images != null && images.isNotEmpty) {
        // // Extract text from the first image
        // final text = await _extractTextFromImage(images.first);

        // // Parse the extracted text from OCR
        // parseKtpText(text);

        // Update the state with the scanned image and parsed fields
        emit(state.copyWith(
          loading: false,
          imagePaths: images,
        ));
      } else {
        emit(state.copyWith(loading: false));
      }
    } catch (e) {
      // Handle errors and update the state
      emit(state.copyWith(loading: false));
    }
  }
}
