import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import 'colors.dart';
import 'text_style.dart';

Future<Position> determinePosition(BuildContext context) async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

  if (!serviceEnabled) {
    await showGpsDialog(context);
    return Future.error('Layanan lokasi (GPS) tidak aktif.');
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }

  if (permission == LocationPermission.denied) {
    await showPermissionDialog(context);
    return Future.error('Izin lokasi ditolak.');
  }

  if (permission == LocationPermission.deniedForever) {
    await showPermissionDialog(context);
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
    barrierDismissible: false,
    builder: (context) => WillPopScope(
      onWillPop: () async => false, // <- Ini yang memblokir tombol back
      child: AlertDialog(
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
    ),
  );
}

/// Dialog untuk meminta user memberikan izin lokasi
Future<void> showPermissionDialog(BuildContext context) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => WillPopScope(
      onWillPop: () async => false, // <- Ini yang memblokir tombol back
      child: AlertDialog(
        title: Text(
          'Izin Lokasi Diperlukan!',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: Column(
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
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  openAppSettings(); // from permission_handler
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
    ),
  );
}
