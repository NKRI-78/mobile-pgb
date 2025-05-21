part of '../view/create_address_page.dart';

class _InputLocation extends StatelessWidget {
  const _InputLocation();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateShippingAddressCubit, CreateShippingAddressState>(
      buildWhen: (previous, current) => 
      previous.latitude != current.latitude 
      || previous.longitude != current.longitude || 
      previous.location != current.location,
      builder: (context, st) {
        Completer<GoogleMapController> mapsController = Completer();
        List<Marker> markers = [];
        markers.add(Marker(
          markerId: const MarkerId("currentPosition"),
          position: LatLng(st.latitude, st.longitude),
          icon: BitmapDescriptor.defaultMarker,
        ));
        debugPrint("Lat Checkin ${st.latitude}");
        debugPrint("Long Checkin ${st.longitude}");
        return Container(  
          width: double.infinity,
          height: 200.0,
          margin: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: GoogleMap(
            mapType: MapType.normal,
            gestureRecognizers: {}..add(Factory<EagerGestureRecognizer>(() => EagerGestureRecognizer())),
            myLocationEnabled: false,
            initialCameraPosition: CameraPosition(
              target: LatLng(st.latitude, st.longitude),
              zoom: 15.0,
            ),
            markers: Set.from(markers),
            onMapCreated: (GoogleMapController controller) {
              mapsController.complete(controller);
              context.read<CreateShippingAddressCubit>().setAreaCurrent(controller);
              CreateShippingAddressCubit.googleMapCheckIn = controller;
            },
          ),
        );
      }
    );
  }
}