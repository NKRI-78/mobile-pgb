part of '../view/update_address_page.dart';

class InputName extends StatelessWidget {
  const InputName({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpdateShippingAddressCubit, UpdateShippingAddressState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Nama Penerima",
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
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1.0,
                          blurRadius: 3.0,
                          offset: const Offset(0.0, 1.0))
                    ],
                  ),
                  child: TextFormField(
                      initialValue: state.nameAddress,
                      cursorColor: AppColors.blackColor,
                      onChanged: (value) {
                        print("Name : $value");
                        var cubit = context.read<UpdateShippingAddressCubit>();
                        cubit.copyState(newState: cubit.state.copyWith(nameAddress: value));
                      },
                      keyboardType: TextInputType.text,
                      inputFormatters: [
                        FilteringTextInputFormatter.singleLineFormatter
                      ],
                      decoration: const InputDecoration(
                        hintText: "Nama Penerima",
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
                )
              ),
            ],
          ),
        );
      },
    );
  }
}
