import 'package:flutter/material.dart';
import 'package:place_picker_google/place_picker_google.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
      onMapCreated: (controller) {
      },
      searchInputConfig: const SearchInputConfig(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        autofocus: false,
      ),
      searchInputDecorationConfig: const SearchInputDecorationConfig(
        hintText: "Cari...",
      ),
      selectedPlaceConfig: const SelectedPlaceConfig(
        actionButtonText: "Tetapkan Lokasi",
        contentPadding: EdgeInsets.all(20),
      ),
      autocompletePlacesSearchRadius: 150,
    );
  }
}
