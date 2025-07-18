import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import 'colors.dart';
import 'text_style.dart';

bool _hasShownPermissionDialog = false;

Future<Position> determinePosition(BuildContext context) async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  debugPrint("SERVICE ENABLED: $serviceEnabled");

  if (!serviceEnabled) {
    await showGpsDialog(context);
    return Future.error('Layanan lokasi (GPS) tidak aktif.');
  }

  LocationPermission permission = await Geolocator.checkPermission();
  debugPrint("PERMISSION STATUS: $permission");

  if (permission == LocationPermission.denied) {
    LocationPermission requestedPermission =
        await Geolocator.requestPermission();

    if (requestedPermission == LocationPermission.denied) {
      return Future.error('Izin lokasi ditolak.');
    }

    if (requestedPermission == LocationPermission.deniedForever) {
      if (!_hasShownPermissionDialog) {
        _hasShownPermissionDialog = true;
        await showPermissionDialog(context);
      }
      return Future.error('Izin lokasi ditolak secara permanen.');
    }

    permission = requestedPermission;
  }

  if (permission == LocationPermission.deniedForever) {
    if (!_hasShownPermissionDialog) {
      _hasShownPermissionDialog = true;
      await showPermissionDialog(context);
    }
    return Future.error('Izin lokasi ditolak secara permanen.');
  }

  return await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.bestForNavigation,
  );
}

/// Dialog untuk meminta user mengaktifkan layanan GPS
Future<void> showGpsDialog(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        'GPS Tidak Aktif',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.gps_off, size: 60, color: AppColors.secondaryColor),
          SizedBox(height: 10),
          Text(
            'Harap aktifkan layanan lokasi (GPS) untuk melanjutkan.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Center(
            child: ElevatedButton(
              onPressed: () {
                Geolocator.openLocationSettings();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryColor,
              ),
              child: Text(
                'Buka Pengaturan',
                style:
                    AppTextStyles.textStyleBold.copyWith(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

/// Dialog untuk meminta user memberikan izin lokasi
Future<void> showPermissionDialog(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      insetPadding:
          EdgeInsets.symmetric(horizontal: 20, vertical: 24), // biar ga mepet
      contentPadding: EdgeInsets.fromLTRB(24, 20, 24, 10),
      title: Center(
        child: Text(
          'Izin Lokasi Diperlukan!',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      content: SingleChildScrollView(
        // responsif!
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_on_rounded,
                size: 60, color: AppColors.secondaryColor),
            SizedBox(height: 10),
            Text(
              'Izin lokasi diperlukan agar aplikasi dapat berfungsi dengan baik. '
              'Harap aktifkan izin lokasi di pengaturan aplikasi.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.redColor,
          ),
          child: Text(
            'Batal',
            style: AppTextStyles.textStyleBold.copyWith(color: Colors.white),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            openAppSettings();
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondaryColor,
          ),
          child: Text(
            'Pengaturan',
            style: AppTextStyles.textStyleBold.copyWith(color: Colors.white),
          ),
        ),
      ],
    ),
  );
}
