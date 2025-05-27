part of '../view/membernear_page.dart';

class _Maps extends StatefulWidget {
  const _Maps(
      {required this.latitude, required this.longitude, required this.markers});

  final double latitude;
  final double longitude;
  final List<Marker> markers;

  @override
  State<_Maps> createState() => _MapsState();
}

class _MapsState extends State<_Maps> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  Widget build(BuildContext context) {
    CameraPosition kGooglePlex = CameraPosition(
      target: LatLng(widget.latitude, widget.longitude),
      zoom: 15.0,
    );

    // List<Marker> markers = [];

    // markers.add(Marker(
    //   markerId: const MarkerId("currentPosition"),
    //   position: LatLng(widget.latitude, widget.longitude),
    //   icon: BitmapDescriptor.defaultMarker,
    // ));
    return BlocBuilder<MemberNearBloc, MemberNearState>(
      builder: (context, st) {
        return st.loading
            ? const CustomLoadingPage()
            : GoogleMap(
                mapType: MapType.normal,
                gestureRecognizers: {}..add(Factory<EagerGestureRecognizer>(
                    () => EagerGestureRecognizer())),
                myLocationEnabled: true,
                zoomControlsEnabled: false,
                buildingsEnabled: false,
                mapToolbarEnabled: false,
                initialCameraPosition: kGooglePlex,
                markers: Set.from(widget.markers),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);

                  context.read<MemberNearBloc>().add(MemberNearSetArea(
                      context: context, mapController: controller));
                },
              );
      },
    );
  }
}
