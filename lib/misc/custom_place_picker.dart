import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:place_picker_google/place_picker_google.dart';

import 'colors.dart';

class CustomPlacePicker extends StatelessWidget {
  final LatLng initialLocation;
  final Function(LocationResult) onPlacePicked;

  const CustomPlacePicker({
    super.key,
    required this.initialLocation,
    required this.onPlacePicked,
  });

  @override
  Widget build(BuildContext context) {
    return PlacePicker(
      usePinPointingSearch: true,
      apiKey: "AIzaSyBvdQKriOVtxZaWeJulj2y8AA6yG2dQgs4",
      onPlacePicked: (LocationResult result) {
        onPlacePicked(result);
      },
      enableNearbyPlaces: false,
      showSearchInput: true,
      initialLocation: initialLocation,
      myLocationButtonEnabled: false,
      onMapCreated: (controller) {},
      searchInputConfig: const SearchInputConfig(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        autofocus: false,
      ),
      searchInputDecorationConfig: const SearchInputDecorationConfig(
        hintText: "Cari lokasi atau alamat...",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: AppColors.secondaryColor),
        ),
      ),
      selectedPlaceConfig: const SelectedPlaceConfig(
        actionButtonText: "Gunakan Lokasi Ini",
        contentPadding: EdgeInsets.all(20),
        actionButtonStyle: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(AppColors.secondaryColor),
          foregroundColor: WidgetStatePropertyAll(AppColors.whiteColor),
          padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
        ),
      ),
      autocompletePlacesSearchRadius: 150,
    );
  }
}
