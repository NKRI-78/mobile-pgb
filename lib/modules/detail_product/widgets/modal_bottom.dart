part of '../view/detail_product_page.dart';

  final GlobalKey _cartKey = GlobalKey();
  final GlobalKey _imageKey = GlobalKey();
  final LayerLink _layerLink = LayerLink();
TextEditingController controller = TextEditingController();

class ModalBottom extends StatelessWidget {
  const ModalBottom({super.key, this.data});

  final DetailProductData? data;

  @override
  Widget build(BuildContext context) {
   return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<DetailProductCubit>()),
        BlocProvider.value(value: getIt<CartCubit>(),
      )
      ],
      child: ModalBottomView(data: data,),
    );
  }
}

class ModalBottomView extends StatefulWidget {
  const ModalBottomView({super.key, this.data});

  final DetailProductData? data;

  @override
  State<ModalBottomView> createState() => _ModalBottomViewState();
}

class _ModalBottomViewState extends State<ModalBottomView>  with TickerProviderStateMixin {
  late int _counterInit;
  late bool loadingAnimation;
  late AnimationController _controller;

  OverlayEntry? _overlayEntry;

  void _runAddToCartAnimation() {
    setState(() {
      loadingAnimation = true;
    });
    final overlay = Overlay.of(context);
    final overlayBox = overlay.context.findRenderObject() as RenderBox;

    // Pastikan posisi dihitung terhadap overlay
    final imageBox = _imageKey.currentContext!.findRenderObject() as RenderBox;
    final cartBox = _cartKey.currentContext!.findRenderObject() as RenderBox;

    final imagePosition = imageBox.localToGlobal(Offset.zero, ancestor: overlayBox);
    final cartPosition = cartBox.localToGlobal(Offset.zero, ancestor: overlayBox);

    final imageSize = imageBox.size;
    final cartSize = cartBox.size;

    // Perhitungan posisi tengah
    final beginOffset = imagePosition;
    final endOffset = Offset(
      cartPosition.dx + cartSize.width / 2 - imageSize.width / 2,
      cartPosition.dy + cartSize.height / 2 - imageSize.height / 2,
    );

    final controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    final positionAnimation = Tween<Offset>(
      begin: beginOffset,
      end: endOffset,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ));

    final scaleAnimation = Tween<double>(
      begin: 1.5, // mulai besar
      end: 0.2,   // mengecil saat ke cart
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ));

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            final offset = positionAnimation.value;
            final scale = scaleAnimation.value;

            return Positioned(
              left: offset.dx,
              top: offset.dy,
              child: Transform.scale(
                scale: scale,
                child: Opacity(
                  opacity: 1.0 - controller.value,
                  child: Image.network(
                    '${widget.data?.pictures?.first.link}',
                    width: imageSize.width,
                    height: imageSize.height,
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    overlay.insert(_overlayEntry!);
    controller.forward();

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _overlayEntry?.remove();
        controller.dispose();
        try {
          context.read<DetailProductCubit>().assignQty(widget.data?.id.toString() ?? "", _counterInit.toString(), context);
        } catch (e) {
          ShowSnackbar.snackbar(context, e.toString(), isSuccess: false);
        }
        setState(() {
          loadingAnimation = false;
        });
      }
    });
  }


  

  @override
  void initState() {
    super.initState();
    _counterInit = 1;
    loadingAnimation = false;
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this, // penting!
    );


    _controller.forward().then((_) {
      if (mounted) {
        // aman
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailProductCubit, DetailProductState>(
      builder: (context, state) {
        return SizedBox(
          height: 350,
          child: Scaffold(
            backgroundColor: AppColors.primaryColor,
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 5,
                        width: 35,
                        color: Colors.black12,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ImageCard(
                                key: _imageKey,
                                image: (widget.data?.pictures?.isEmpty ?? false) ? "" : widget.data?.pictures?.first.link ?? "", 
                                height: 130, 
                                radius: 0, 
                                width: 130,  
                                imageError: imageDefaultData,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${Price.currency(widget.data?.price?.toDouble() ?? 0)}',
                                    style: const TextStyle(
                                      color: AppColors.blueColor,
                                      fontSize: fontSizeOverLarge,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  Text(
                                    'Stock : ${widget.data?.stock}',
                                    style: const TextStyle(
                                      color: AppColors.blackColor,
                                      fontSize: fontSizeExtraLarge
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                }, 
                                icon: const Icon(
                                  Icons.close,
                                  size: 30,
                                )
                              )
                            ],
                          )
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "Jumlah",
                              style: TextStyle(
                                color: AppColors.blackColor,
                                fontWeight: FontWeight.bold,
                                fontSize: fontSizeDefault
                              ),
                            ),
                            CustomCartStepper(
                              value: _counterInit,
                              didChangeCount: (count) async {
                                 if (count > (widget.data?.stock ?? 0)) {
                                  setState(() {
                                    _counterInit = (widget.data?.stock ?? 0);
                                  });
                                  return;
                                }
                                if (count < 1) return;
                                setState(() {
                                  _counterInit = count;
                                });
                              },
                              size: 25,
                              editKeyboardType: TextInputType.number,
                              style: CartStepperStyle(
                                foregroundColor: Colors.red,
                                activeForegroundColor: Colors.white,
                                activeBackgroundColor: AppColors.secondaryColor,
                                buttonAspectRatio: 1,
                                iconPlus: _counterInit >= (widget.data?.stock ?? 0) ? Icons.block : Icons.add,
                                radius: const Radius.circular(5)
                              ),
                            )
                          ],
                        ),
                      ),
                      CustomButton(
                        onPressed: loadingAnimation ? null : _runAddToCartAnimation,
                        text: 'Masukkan keranjang',
                        backgroundColour: AppColors.redColor,
                        textColour: AppColors.whiteColor,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }
    );
  }
}