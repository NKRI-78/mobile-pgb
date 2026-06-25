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
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    final kGooglePlex = CameraPosition(
      target: LatLng(widget.latitude, widget.longitude),
      zoom: 15,
    );

    return GoogleMap(
      mapType: MapType.normal,
      gestureRecognizers: {
        Factory<EagerGestureRecognizer>(
          () => EagerGestureRecognizer(),
        ),
      },
      myLocationEnabled: true,
      zoomControlsEnabled: false,
      buildingsEnabled: false,
      mapToolbarEnabled: false,
      initialCameraPosition: kGooglePlex,
      markers: Set.from(widget.markers),
      onMapCreated: (controller) {
        if (_initialized) return;

        _initialized = true;

        context.read<MemberNearBloc>().add(
              MemberNearSetArea(
                context: context,
                mapController: controller,
              ),
            );
      },
    );
  }
}
