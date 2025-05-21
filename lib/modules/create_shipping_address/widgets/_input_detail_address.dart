part of '../view/create_address_page.dart';

class InputDetailAddress extends StatelessWidget {
  const InputDetailAddress({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateShippingAddressCubit, CreateShippingAddressState>(
      builder: (context, st) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Detail Alamat",
                  style: TextStyle(
                    fontSize: fontSizeDefault,
                  )),
              const SizedBox(
                height: 10.0,
              ),
              Container(
                  decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(6.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 1.0,
                            blurRadius: 3.0,
                            offset: const Offset(0.0, 1.0))
                      ],
                    ),
                    child: TextFormField(
                      minLines: 3,
                      maxLines: 5,
                      cursorColor: AppColors.blackColor,
                      onChanged: (value) {
                        var cubit = context.read<CreateShippingAddressCubit>();
                        cubit.copyState(newState: cubit.state.copyWith(currentAddress: value));
                      },
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      inputFormatters: [
                        FilteringTextInputFormatter.singleLineFormatter
                      ],
                      decoration: const InputDecoration(
                        hintText: "Detail Alamat",
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 15.0),
                        isDense: true,
                        hintStyle: TextStyle(color: AppColors.blackColor),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.5),
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        );
      },
    );
  }
}
