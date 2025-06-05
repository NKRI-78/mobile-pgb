import 'package:carousel_slider/carousel_slider.dart';
import 'package:cart_stepper/cart_stepper.dart';
import 'package:badges/badges.dart' as Badges;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_pgb/widgets/pages/page_full_screen_gallery.dart';
import '../../../misc/colors.dart';
import '../../../misc/custom_cart_stepper.dart';
import '../../../misc/injections.dart';
import '../../../misc/price_currency.dart';
import '../../../misc/snackbar.dart';
import '../../../misc/text_style.dart';
import '../../../misc/theme.dart';
import '../../app/bloc/app_bloc.dart';
import '../../cart/cubit/cart_cubit.dart';
import '../cubit/detail_product_cubit.dart';
import '../widgets/body_detail.dart';
import '../../../repositories/shop_repository/models/detail_product_model.dart';
import '../../../router/builder.dart';
import '../../../widgets/button/custom_button.dart';
import '../../../widgets/image/image_card.dart';
import '../../../widgets/pages/empty_page.dart';
import '../../../widgets/pages/loading_page.dart';

part '../widgets/modal_bottom.dart';
part '../widgets/button_arrow.dart';

class DetailProductPage extends StatelessWidget {
  const DetailProductPage({super.key, required this.idProduct});

  final String idProduct;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<AppBloc>()..add(InitialAppData())),
        BlocProvider.value(
          value: getIt<DetailProductCubit>()..fetchDetailProduct(idProduct),
        )
      ],
      child: const DetailProductView(),
    );
  }
}

class DetailProductView extends StatefulWidget {
  const DetailProductView({super.key});

  @override
  State<DetailProductView> createState() => _DetailProductViewState();
}

class _DetailProductViewState extends State<DetailProductView> {
  int current = 0;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailProductCubit, DetailProductState>(
      builder: (context, state) {
        final data = state.detail?.data;
        final isLoggedIn = getIt<AppBloc>().state.user != null;
        return Scaffold(
          backgroundColor: AppColors.primaryColor,
          bottomNavigationBar: state.loading ? null : Container(
              padding: const EdgeInsets.only(
                bottom: 10,
                left: 10,
                right: 10,
              ),
              width: double.infinity,
              height: 50,
              color: Colors.transparent,
              child: data?.stock == 0 ? Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.redColor,
                    borderRadius: BorderRadius.circular(12)
                  ),
                  child: const Text(
                    "Mohon Maaf Saat Ini Barang Belum Tersedia",
                    textScaler: TextScaler.noScaling,
                    style: TextStyle(
                      fontSize: fontSizeDefault,
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ) : Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: CustomButton(
                      radius: 12,
                      onPressed: () {
                        isLoggedIn ? 
                        showModalBottomSheet(
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(32)),
                          ),
                          context: context,
                          builder: (BuildContext context) => Padding(
                            padding:
                                MediaQuery.of(context).viewInsets,
                            child: ModalBottom(data: data),
                          ),
                        ) : RegisterRoute().push(context);
                      },
                      text: '+ Keranjang',
                      backgroundColour: AppColors.blackColor,
                      textColour: AppColors.whiteColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: CustomButton(
                      radius: 12,
                      onPressed: () {
                        isLoggedIn ? CheckoutRoute(
                          from: "NOW",
                          qty: "1",
                          productId: data?.id.toString() ?? "",
                        ).push(context) : RegisterRoute().push(context);
                      },
                      text: 'Beli Sekarang',
                      backgroundColour: AppColors.secondaryColor,
                      textColour: AppColors.whiteColor,
                    ),
                  ),
                ],
                              ),
            ),
          body: state.loading
              ? const CustomLoadingPage()
              : state.detail?.data == null
                  ? const EmptyPage(msg: "Produk tidak ditemukan")
                  : RefreshIndicator(
                      onRefresh: () async {
                        context
                            .read<DetailProductCubit>()
                            .fetchDetailProduct(state.idProduct);
                      },
                      child: SafeArea(
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            CarouselSlider(
                              items: data?.pictures
                                  ?.asMap()
                                  .entries
                                  .map((e) => InkWell(
                                        onTap: () {
                                          Navigator.push(context, MaterialPageRoute(
                                            builder: (_) => FullscreenGallery(
                                              images: data.pictures?.map((media) => media.link)
                                              .whereType<String>()
                                              .toList() ?? [],
                                              initialIndex: e.key,
                                              stock: data.stock,
                                            ),
                                          ));
                                        },
                                        child: Stack(
                                          children: [
                                            ImageCard(
                                                image: e.value.link ?? "",
                                                height: 330,
                                                radius: 0,
                                                width: double.infinity,
                                                fit: BoxFit.fill,
                                                imageError: imageDefaultData),
                                            data.stock == 0
                                                ? Container(
                                                    width: double.infinity,
                                                    height: 330,
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                  )
                                                : const SizedBox.shrink(),
                                            data.stock == 0
                                                ? const Center(
                                                    child: Text(
                                                      'Stok Habis',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        shadows: [
                                                          Shadow(
                                                            offset:
                                                                Offset(1, 1),
                                                            blurRadius: 2,
                                                            color:
                                                                Colors.black54,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                      ))
                                  .toList(),
                              options: CarouselOptions(
                                  height: 350,
                                  enableInfiniteScroll: false,
                                  aspectRatio: 16 / 9,
                                  autoPlay: false,
                                  viewportFraction: 1.0,
                                  onPageChanged: (int i,
                                      CarouselPageChangedReason reason) {
                                    setState(() => current = i);
                                  }),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 220, right: 10),
                                child: Container(
                                  width: 80,
                                  height: 30,
                                  decoration: const BoxDecoration(
                                      color: AppColors.secondaryColor),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const Icon(
                                        Icons.photo_sharp,
                                        size: 20,
                                        color: AppColors.whiteColor,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "${current + 1} / ${data!.pictures!.length}",
                                        style: AppTextStyles.textStyleNormal
                                            .copyWith(
                                                color: AppColors.whiteColor),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const ButtonArrow(),
                            BodyDetail(
                              data: data,
                            ),
                          ],
                        ),
                      ),
                    ),
        );
      },
    );
  }
}
