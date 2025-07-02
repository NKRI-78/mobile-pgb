part of '../view/update_address_page.dart';

class _InputLocationLabel extends StatelessWidget {
  const _InputLocationLabel();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpdateShippingAddressCubit, UpdateShippingAddressState>(
      builder: (context, state) {
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
                    var cubit = context.read<UpdateShippingAddressCubit>();
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return Theme(
                          data: ThemeData(
                            appBarTheme: const AppBarTheme(
                              backgroundColor: Colors.deepPurple,
                              foregroundColor: Colors.white,
                            ),
                            scaffoldBackgroundColor: Colors.white,
                            colorScheme: ColorScheme.fromSeed(
                                seedColor: Colors.deepPurple),
                          ),
                          child: BlocProvider.value(
                            value: cubit,
                            child: CustomPlacePicker(
                              onPlacePicked: (LocationResult result) {
                                debugPrint(
                                    "Place picked: ${result.formattedAddress}");
                                cubit.copyState(
                                    newState: cubit.state.copyWith(
                                        latitude:
                                            result.latLng?.latitude ?? 0.0,
                                        longitude:
                                            result.latLng?.longitude ?? 0.0));
                                cubit.updateCurrentPositionCheckIn(
                                    context,
                                    result.latLng?.latitude ?? 0.0,
                                    result.latLng?.longitude ?? 0.0);
                                Navigator.of(context).pop();
                              },
                              initialLocation:
                                  LatLng(state.latitude, state.longitude),
                            ),
                          ),
                        );
                      },
                    ));
                  },
                  child: Text("Tetapkan Lokasi",
                      style: TextStyle(
                          fontSize: fontSizeSmall,
                          color: AppColors.secondaryColor))),
            ],
          ),
        );
      },
    );
  }
}
