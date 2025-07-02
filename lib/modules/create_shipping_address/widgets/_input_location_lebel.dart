part of '../view/create_address_page.dart';

class _InputLocationLabel extends StatelessWidget {
  const _InputLocationLabel();

  @override
  Widget build(BuildContext context) {
    final app = getIt<AppBloc>();
    final position = app.state.profile;
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
                // final add = await CustomSelectMapLocationWidget.go(context);
                // if (add != null) {
                //   debugPrint("Addres current ${add.address}");
                //   debugPrint("Lat result : ${add.latLng.latitude}");
                //   if(context.mounted){
                //     var cubit = context.read<CreateShippingAddressCubit>();
                //     cubit.copyState(newState: cubit.state.copyWith(latitude: add.latLng.latitude, longitude: add.latLng.longitude));
                //     cubit.updateCurrentPositionCheckIn(context, add.latLng.latitude, add.latLng.longitude);
                //   }
                // }
                var cubit = context.read<CreateShippingAddressCubit>();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return Theme(
                      data: ThemeData(
                        appBarTheme: const AppBarTheme(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                        ),
                        scaffoldBackgroundColor: Colors.white,
                        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                      ),
                      child: BlocProvider.value(
                        value: cubit,
                        child: CustomPlacePicker(
                          onPlacePicked: (LocationResult result) {
                            debugPrint("Place picked: ${result.formattedAddress}");
                            cubit.copyState(newState: cubit.state.copyWith(latitude: result.latLng?.latitude ?? 0.0, longitude: result.latLng?.longitude ?? 0.0));
                            cubit.updateCurrentPositionCheckIn(context,result.latLng?.latitude ?? 0.0, result.latLng?.longitude ?? 0.0);
                            Navigator.of(context).pop();
                          },
                          initialLocation: LatLng(position?.latitude ?? 0.0, position?.longitude ?? 0.0),
                        ),
                      ),
                    );
                  },
                ));

              },
              child: const Text("Tetapkan Lokasi",
                  style: TextStyle(fontSize: fontSizeSmall, color: AppColors.secondaryColor))),
        ],
      ),
    );
  }
}
