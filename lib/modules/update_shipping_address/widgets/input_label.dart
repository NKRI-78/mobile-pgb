part of '../view/update_address_page.dart';

class InputLabel extends StatefulWidget {
  const InputLabel({super.key});

  @override
  State<InputLabel> createState() => _InputLabelState();
}

class _InputLabelState extends State<InputLabel> {
  bool defaultLocation = false;
  bool isCheck = true;
  List<String> typePlace = ['Rumah', 'Kantor', 'Apartement', 'Kos'];

  late TextEditingController typeAddressC;

  @override
  void initState() {
    super.initState();
    typeAddressC = TextEditingController();
  }

  @override
  void dispose() {
    typeAddressC.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpdateShippingAddressCubit, UpdateShippingAddressState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Label Alamat",
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
                      onTap: () {
                        setState(() {
                          isCheck = false;
                        });
                      },
                      cursorColor: AppColors.blackColor,
                      controller: typeAddressC,
                      keyboardType: TextInputType.text,
                      inputFormatters: [
                        FilteringTextInputFormatter.singleLineFormatter
                      ],
                      decoration: const InputDecoration(
                        hintText: "Ex: Rumah",
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
              isCheck
                  ? const SizedBox()
                  : Container(
                      height: 35.0,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: ListView(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        children: [
                          ...typePlace.map((e) => GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isCheck = true;
                                    typeAddressC.text = e;
                                    var cubit = context.read<UpdateShippingAddressCubit>();
                                    cubit.copyState(newState: cubit.state.copyWith(label: e));
                                  });
                                },
                                child: Container(
                                    height: 20,
                                    padding: const EdgeInsets.all(8),
                                    margin: const EdgeInsets.only(right: 8),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(35),
                                        color: AppColors.whiteColor,
                                        border: Border.all(
                                            color: Colors.grey[350]!)),
                                    child: Center(
                                        child: Text(e,
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 14,
                                            )))),
                              ))
                        ],
                      )),
            ],
          ),
        );
      },
    );
  }
}
