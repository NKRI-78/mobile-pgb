part of '../view/profile_page.dart';

class PreviewKtaPage extends StatefulWidget {
  final String noKta,
      nama,
      tempatTglLahir,
      agama,
      alamat,
      rtRw,
      kelurahan,
      kecamatan,
      fotoPath,
      provinsi,
      kab,
      createAt;

  const PreviewKtaPage({
    super.key,
    required this.noKta,
    required this.nama,
    required this.tempatTglLahir,
    required this.agama,
    required this.alamat,
    required this.rtRw,
    required this.kelurahan,
    required this.kecamatan,
    required this.fotoPath,
    required this.createAt,
    required this.provinsi,
    required this.kab,
  });

  @override
  State<PreviewKtaPage> createState() => _PreviewKtaPageState();
}

class _PreviewKtaPageState extends State<PreviewKtaPage> {
  final GlobalKey _ktaFrontKey = GlobalKey();
  final GlobalKey _ktaBackKey = GlobalKey();

  // bool _isDownloading = true;
  String _message = "Preparing download...";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _captureAndSave();
    });
  }

  Future<void> _captureAndSave() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      print('CAPTURE');
      setState(() => _message = "Capturing front side...");
      final frontImage = await _captureWidgetToImage(_ktaFrontKey);

      setState(() => _message = "Capturing back side...");
      final backImage = await _captureWidgetToImage(_ktaBackKey);

      final tempDir = await getTemporaryDirectory();

      final frontPath = '${tempDir.path}/kta_front.png';
      final backPath = '${tempDir.path}/kta_back.png';

      await File(frontPath).writeAsBytes(frontImage);
      await File(backPath).writeAsBytes(backImage);

      setState(() => _message = "Saving to gallery...");

      await GallerySaver.saveImage(frontPath, albumName: 'KTA');
      await GallerySaver.saveImage(backPath, albumName: 'KTA');

      setState(() => _message = "Download complete!");

      await Future.delayed(const Duration(seconds: 1));
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      print("Error capturing KTA: $e");
      setState(() {
        _message = "Error: $e";
      });
    }
  }

  Future<Uint8List> _captureWidgetToImage(GlobalKey key) async {
    RenderRepaintBoundary boundary =
        key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                RepaintBoundary(
                  key: _ktaFrontKey,
                  child: CustomCardProfile(
                    onCardSideChanged: (_) {},
                    isForExport: true,
                    cardSide: CardSide.front,
                    provinsi: widget.provinsi,
                    kab: widget.kab,
                    noKta: widget.noKta,
                    nama: widget.nama,
                    tempatTglLahir: widget.tempatTglLahir,
                    agama: widget.agama,
                    alamat: widget.alamat,
                    rtRw: widget.rtRw,
                    kelurahan: widget.kelurahan,
                    kecamatan: widget.kecamatan,
                    fotoPath: widget.fotoPath,
                    createAt: widget.createAt,
                  ),
                ),
                const SizedBox(height: 16),
                RepaintBoundary(
                  key: _ktaBackKey,
                  child: CustomCardProfile(
                    onCardSideChanged: (_) {},
                    isForExport: true,
                    cardSide: CardSide.back,
                    noKta: widget.noKta,
                    nama: widget.nama,
                    provinsi: widget.provinsi,
                    kab: widget.kab,
                    tempatTglLahir: widget.tempatTglLahir,
                    agama: widget.agama,
                    alamat: widget.alamat,
                    rtRw: widget.rtRw,
                    kelurahan: widget.kelurahan,
                    kecamatan: widget.kecamatan,
                    fotoPath: widget.fotoPath,
                    createAt: widget.createAt,
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CustomLoadingPage(),
                    Text(_message, textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
