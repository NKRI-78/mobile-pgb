import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../misc/date_helper.dart';
import '../../../misc/snackbar.dart';
import '../cubit/presence_cubit.dart';
import '../../../widgets/pages/loading_page.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../misc/colors.dart';
import '../../../misc/text_style.dart';

class PresencePage extends StatelessWidget {
  const PresencePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PresenceCubit(),
      child: const PresenceView(),
    );
  }
}

class PresenceView extends StatefulWidget {
  const PresenceView({super.key});

  @override
  State<PresenceView> createState() => _PresenceViewState();
}

class _PresenceViewState extends State<PresenceView> {
  bool _hasScanned = false;

  late final MobileScannerController _scannerController;

  @override
  void initState() {
    super.initState();
    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
    );
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PresenceCubit, PresenceState>(
      listener: (context, state) {
        if (state.isLoading || state.message.isEmpty) return;

        final message = state.isSuccess && state.presenceDate != null
            ? '${state.message}\n${DateHelper.formatFullDate(state.presenceDate.toString())}'
            : state.message;

        ShowSnackbar.snackbar(
          context,
          message,
          isSuccess: state.isSuccess,
        );

        if (state.isSuccess) {
          Navigator.pop(context);
        } else {
          _hasScanned = false;
          _scannerController.start();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          backgroundColor: AppColors.whiteColor,
          title: Text(
            'Scan Barcode Absensi',
            style: AppTextStyles.textStyleBold,
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Stack(
          children: [
            MobileScanner(
              controller: _scannerController,
              onDetect: (barcodeCapture) {
                if (_hasScanned) return;

                final barcode = barcodeCapture.barcodes.first;
                final code = barcode.rawValue;

                if (code == null || code.isEmpty) {
                  ShowSnackbar.snackbar(
                    context,
                    'QR Code tidak valid',
                    isSuccess: false,
                  );
                  return;
                }

                _hasScanned = true;
                _scannerController.stop();

                context.read<PresenceCubit>().createPresence(
                      tokenAttend: code,
                    );
              },
            ),
            Center(
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            BlocBuilder<PresenceCubit, PresenceState>(
              builder: (context, state) {
                if (!state.isLoading) return const SizedBox();

                return const Center(
                  child: CustomLoadingPage(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
