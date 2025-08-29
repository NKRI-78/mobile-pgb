import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../misc/colors.dart';
import '../../../misc/text_style.dart';
import '../../../repositories/ppob_repository/models/listrik_data_model.dart';

class CustomListListrikDataSection extends StatefulWidget {
  final List<ListrikDataModel> listrikData;
  final Function(ListrikDataModel) onSelected;

  const CustomListListrikDataSection({
    super.key,
    required this.listrikData,
    required this.onSelected,
  });

  @override
  State<CustomListListrikDataSection> createState() =>
      _CustomListListrikDataSectionState();
}

class _CustomListListrikDataSectionState
    extends State<CustomListListrikDataSection> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return widget.listrikData.isEmpty
        ? Center(
            child: Text(
              "Tidak ada produk listrik tersedia",
              style: const TextStyle(fontSize: 16, color: Colors.red),
            ),
          )
        : GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.2,
            ),
            itemCount: widget.listrikData.length,
            itemBuilder: (context, index) {
              final listrik = widget.listrikData[index];
              final isSelected = selectedIndex == index;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });

                  widget.onSelected(listrik);
                },
                child: Card(
                  color: isSelected ? AppColors.whiteColor : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color:
                          isSelected ? AppColors.secondaryColor : Colors.white,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  elevation: isSelected ? 5 : 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          listrik.name,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.textStyleNormal
                              .copyWith(color: AppColors.blackColor),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          formatCurrency(listrik.price),
                          style: AppTextStyles.textStyleNormal,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
  }

  String formatCurrency(int price) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(price);
  }
}
