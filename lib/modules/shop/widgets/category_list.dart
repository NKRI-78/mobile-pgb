part of '../view/shop_page.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({super.key});

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopBloc, ShopState>(
  builder: (context, state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: state.category.map((data) => InkWell(
          onTap: () {
            print("==== Category Clicked: ${data.id} ====");
            context.read<ShopBloc>().add(ChangeProduct(idCategory: data.id ?? 0));
          },
          child: Column(
            children: [
              Container(
                width: 50,
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: state.idCategory == data.id ? AppColors.blueColor : AppColors.greyColor,
                  borderRadius: const BorderRadius.all(Radius.circular(50))
                ),
                child: ImageCard(
                  image: data.iconUrl ?? "", 
                  height: 20, 
                  radius: 0, 
                  width: 20, 
                  fit: BoxFit.contain,
                  imageError: "assets/icons/shirt.png"
                ),
              ),
              SizedBox(
                width: 80,
                child: Text(
                  data.name ?? "-",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.textStyleBold.copyWith(
                    color: state.idCategory == data.id ? AppColors.blueColor :  AppColors.blackColor,
                  ),
                ),
              )
            ],
          ),
        )).toList(),
      ),
    );
  }
)
;
  }
}