import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class FullscreenGallery extends StatefulWidget {
  final List<String> images;
  final int initialIndex;
  final int? stock;

  const FullscreenGallery({
    super.key,
    required this.images,
    this.initialIndex = 0,
    this.stock,
  });

  @override
  State<FullscreenGallery> createState() => _FullscreenGalleryState();
}

class _FullscreenGalleryState extends State<FullscreenGallery> {
  late PageController _pageController;
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('${currentIndex + 1} / ${widget.images.length}'),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.images.length,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        itemBuilder: (_, index) {
          return Stack(
            alignment: Alignment.center,
            children: [
              ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.black.withValues(
                    alpha: widget.stock == null
                        ? 0.0
                        : widget.stock == 0
                            ? 0.5
                            : 0.0,
                  ),
                  BlendMode.darken,
                ),
                child: ExtendedImage.network(
                  widget.images[index],
                  fit: BoxFit.contain,
                  mode: ExtendedImageMode.gesture,
                  initGestureConfigHandler: (state) => GestureConfig(
                    minScale: 1.0,
                    animationMinScale: 0.7,
                    maxScale: 3.0,
                    animationMaxScale: 3.5,
                    speed: 1.0,
                    inertialSpeed: 100.0,
                    initialScale: 1.0,
                    inPageView: true,
                    initialAlignment: InitialAlignment.center,
                    cacheGesture: false,
                  ),
                  cache: true,
                  enableSlideOutPage: true,
                ),
              ),

              // Teks di tengah gambar
              widget.stock == null
                  ? Container()
                  : widget.stock == 0
                      ? const Text(
                          "Stok Habis",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                blurRadius: 4.0,
                                color: Colors.black54,
                                offset: Offset(2.0, 2.0),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        )
                      : Container(),
            ],
          );
        },
      ),
    );
  }
}
