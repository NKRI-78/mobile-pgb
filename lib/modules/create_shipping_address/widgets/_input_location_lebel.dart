part of '../view/create_address_page.dart';

class _InputLocationLabel extends StatelessWidget {
  const _InputLocationLabel();

  @override
  Widget build(BuildContext context) {
    // GoogleMapController mapController;
    return Container(
      margin: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Wrap(
            spacing: 10.0,
            children: [
              Text("Lokasi",
                  style: TextStyle(
                    fontSize: fontSizeDefault,
                  )),
            ],
          ),
          const Expanded(child: SizedBox.shrink()),
          GestureDetector(
              onTap: () async {
                final add = await CustomSelectMapLocationWidget.go(context);
                if (add != null) {
                  debugPrint("Addres current ${add.address}");
                  debugPrint("Lat result : ${add.latLng.latitude}");
                  if (context.mounted) {
                    var cubit = context.read<CreateShippingAddressCubit>();
                    cubit.copyState(
                        newState: cubit.state.copyWith(
                            latitude: add.latLng.latitude,
                            longitude: add.latLng.longitude));
                    cubit.updateCurrentPositionCheckIn(
                        context, add.latLng.latitude, add.latLng.longitude);
                  }
                }
                // Navigator.of(context).push(MaterialPageRoute(
                //   builder: (context) {
                //     return PlacePicker(
                //       usePinPointingSearch: true,
                //       apiKey: "AIzaSyBvdQKriOVtxZaWeJulj2y8AA6yG2dQgs4",
                //       onPlacePicked: (LocationResult result) {
                //         debugPrint("Place picked: ${result.formattedAddress}");
                //         Navigator.of(context).pop();
                //       },
                //       enableNearbyPlaces: false,
                //       showSearchInput: true,
                //       initialLocation: const LatLng(29.378586, 47.990341),
                //       myLocationEnabled: true,
                //       myLocationButtonEnabled: true,
                //       onMapCreated: (controller) {
                //         mapController = controller;
                //       },
                //       searchInputConfig: const SearchInputConfig(
                //         padding:
                //             EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                //         autofocus: false,
                //       ),
                //       searchInputDecorationConfig:
                //           const SearchInputDecorationConfig(
                //         hintText: "Search for a building, street or ...",
                //       ),
                //       selectedPlaceConfig: SelectedPlaceConfig(
                //         actionButtonText: "Tetapkan Lokasi",
                //         contentPadding: EdgeInsets.all(20),
                //       ),
                //       // HAPUS INI:
                //       // selectedPlaceWidgetBuilder: (ctx, state, result) {
                //       //   return const SizedBox.shrink(); // <<< Jangan gunakan
                //       // },
                //       autocompletePlacesSearchRadius: 150,
                //     );
                //   },
                // ));
              },
              child: const Text("Tetapkan Lokasi",
                  style: TextStyle(
                      fontSize: fontSizeSmall,
                      color: AppColors.buttonBlueColor))),
        ],
      ),
    );
  }
}
