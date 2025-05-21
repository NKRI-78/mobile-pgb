part of '../view/update_address_page.dart';

class _InputLocationLabel extends StatelessWidget {
  const _InputLocationLabel();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20, ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Wrap(
            spacing: 10.0,
            children: [
              Text("Lokasi",
                style: TextStyle(
                  fontSize: fontSizeDefault,
                )
              ),
            ],
          ),
          const Expanded(
            child: SizedBox.shrink()
          ),
          GestureDetector(
            onTap: () async { 
              final add = await CustomSelectMapLocationWidget.go(context);
              if (add != null) {
                debugPrint("Addres current ${add.address}");
                debugPrint("Lat result : ${add.latLng.latitude}");
                if(context.mounted){
                  var cubit = context.read<UpdateShippingAddressCubit>();
                  cubit.copyState(newState: cubit.state.copyWith(latitude: add.latLng.latitude, longitude: add.latLng.longitude));
                  cubit.updateCurrentPositionCheckIn(context, add.latLng.latitude, add.latLng.longitude);
                }
              }
            },
            child: const Text("Tetapkan Lokasi",
              style: TextStyle(
                fontSize: fontSizeSmall,
                color: AppColors.blueColor
              )
            )
          ),
        ],
      ),
    );
  }
}