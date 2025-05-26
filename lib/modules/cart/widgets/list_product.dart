part of '../view/cart_page.dart';

class ListProduct extends StatefulWidget {
  const ListProduct({super.key, required this.cart});

  final CartModel cart;

  @override
  State<ListProduct> createState() => _ListProductState();
}

class _ListProductState extends State<ListProduct> {
  @override
  Widget build(BuildContext context) {
    print('fasd ${widget.cart.carts?.first.quantity}');
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Checkbox(
                //   value: false,
                //   onChanged: (value) {
                //     context.read<CartCubit>().toggleSeller(widget.cart.id ?? 0, value);
                //   },
                //   activeColor: Colors.red,
                //   checkColor: Colors.white,
                // ),
                ImageAvatar(
                  image : widget.cart.linkPhoto ?? "-", 
                  radius: 15
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  widget.cart.name ?? "",
                  style: const TextStyle(
                    color: AppColors.blackColor,
                    fontSize: fontSizeDefault,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: widget.cart.carts!.map((e) => 
              Container(
                width: double.infinity,
                height: 110,
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: e.product?.stock == 0 ? AppColors.whiteColor.withValues(alpha: 0.5) : AppColors.whiteColor.withValues(alpha: 1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: e.product?.stock == 0 ? AppColors.greyColor : AppColors.blackColor, width: e.product?.stock == 0 ? 0.5 : 2)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                e.product?.stock == 0 ? Container() : Checkbox(
                                  value: e.isSelected ?? false,
                                  onChanged: (value) {
                                    setState(() {
                                      e.isSelected = value!;
                                      context.read<CartCubit>().assignQty(
                                        productId:  e.product?.id.toString() ?? "", 
                                        qty:  e.quantity.toString(), 
                                        isSelected: value
                                      );
                                      context.read<CartCubit>().toggleSelection(
                                        productId: e.product?.id.toString() ?? "", 
                                        isSelected: value,
                                      );
                                    });
                                  },
                                  activeColor: AppColors.secondaryColor,
                                  checkColor: Colors.white,
                                ),
                                ImageCard(
                                  image: (e.product?.pictures?.isEmpty ?? false) ? "" : e.product?.pictures?.first.link ?? "", 
                                  height: 80, 
                                  radius: 0, 
                                  width: 80, 
                                  imageError: imageDefaultData
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                               
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                               e.product?.name ?? "",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: e.product?.stock == 0 ? AppColors.blackColor.withValues(alpha: 0.5) : AppColors.blackColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: fontSizeDefault
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                Text(
                                                e.product?.stock == 0 ? "Stock Habis" : 'Stock : ${e.product?.stock}',
                                                style: TextStyle(
                                                  color: e.product?.stock == 0 ?  AppColors.redColor : AppColors.blackColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: fontSizeSmall
                                                ),
                                              ),
                                              Text(
                                                '${Price.currency(e.price?.toDouble() ?? 0)}',
                                                style: TextStyle(
                                                  color: e.product?.stock == 0 ? AppColors.blackColor.withValues(alpha: 0.5) : AppColors.blackColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: fontSizeSmall
                                                ),
                                              )
                                                ],),
                                              ),
                                            ],),
                                          ],
                                        ),
                                      ),
                                      e.product?.stock == 0 ? TextButton(
                                        onPressed: () async {
                                          await context.read<CartCubit>().deleteCart(e.product?.id.toString() ?? "");
                                        }, 
                                        child: Icon(
                                          Icons.delete,
                                          color: AppColors.secondaryColor,
                                          size: 28,
                                        ),
                                      ) : 
                                      
                                      CustomCartStepper(
                                        value: e.quantity,
                                        didChangeCount: (count) async {
                                          if (count > (e.product?.stock ?? 0)) {
                                            setState(() {
                                              e.quantity = e.product?.stock;
                                            });
                                            return;
                                          }
                                          
                                          setState(() {
                                            e.quantity = count;
                                          });
                                          if(count < 1){
                                            await context.read<CartCubit>().deleteCart(e.product?.id.toString() ?? "");
                                          } else {
                                            context.read<CartCubit>().assignQty(productId:  e.product?.id.toString() ?? "", qty:  count.toString()); // Update jika masih ada
                                          }
                                          context.read<CartCubit>().toggleSelection(
                                            productId: e.product?.id.toString() ?? "", 
                                            isSelected: e.isSelected ?? true,
                                          );
                                    
                                        },
                                        size: 25,
                                        editKeyboardType: TextInputType.number,
                                        style: CartStepperStyle(
                                          foregroundColor: Colors.red,
                                          activeForegroundColor: Colors.white,
                                          activeBackgroundColor: AppColors.secondaryColor,
                                          buttonAspectRatio: 1,
                                          iconPlus: e.quantity! >= (e.product?.stock ?? 0) ? Icons.block : Icons.add,
                                          iconMinus: e.quantity! <= 1 ? Icons.delete : Icons.remove,
                                          radius: const Radius.circular(5)
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ).toList(),
          )
        ],
      ),
    );
  }
}