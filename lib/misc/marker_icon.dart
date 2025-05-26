// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;

class MarkerIcon {
  static Future<BitmapDescriptor> pictureAsset({
    required String assetPath,
    required double width,
    required double height,
  }) async {
    ByteData imageFile = await rootBundle.load(assetPath);
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Uint8List imageUint8List = imageFile.buffer.asUint8List();
    final ui.Codec codec = await ui.instantiateImageCodec(imageUint8List);
    final ui.FrameInfo imageFI = await codec.getNextFrame();

    paintImage(canvas: canvas, rect: Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), image: imageFI.image);

    final image = await pictureRecorder.endRecording().toImage(width.toInt(), (height).toInt());
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  static Future<BitmapDescriptor> pictureAssetWithCenterText(
      {required String assetPath,
      required String text,
      required Size size,
      double fontSize = 15,
      Color fontColor = Colors.black,
      FontWeight fontWeight = FontWeight.w500}) async {
    ByteData imageFile = await rootBundle.load(assetPath);
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Path clipPath = Path();
    final Radius radius = Radius.circular(size.width / 2);
    clipPath.addRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(0.0, 0.0, size.width.toDouble(), size.height.toDouble()),
        topLeft: radius,
        topRight: radius,
        bottomLeft: radius,
        bottomRight: radius,
      ),
    );
    TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
    painter.text = TextSpan(
      text: text,
      style: TextStyle(fontSize: fontSize, color: fontColor, fontWeight: fontWeight),
    );

    canvas.clipPath(clipPath);
    final Uint8List imageUint8List = imageFile.buffer.asUint8List();
    final ui.Codec codec = await ui.instantiateImageCodec(imageUint8List);
    final ui.FrameInfo imageFI = await codec.getNextFrame();

    paintImage(
        fit: BoxFit.contain,
        alignment: Alignment.center,
        canvas: canvas,
        rect: Rect.fromLTWH(0, 0, size.width.toDouble(), size.height.toDouble()),
        image: imageFI.image);
    painter.layout();
    painter.paint(canvas, Offset((size.width * 0.5) - painter.width * 0.5, (size.height * .5) - painter.height * 0.5));

    final image = await pictureRecorder.endRecording().toImage(size.width.toInt(), (size.height).toInt());
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  static Future<BitmapDescriptor> circleCanvasWithText({
    required Size size,
    required String text,
    double fontSize = 15.0,
    Color circleColor = Colors.red,
    Color fontColor = Colors.black,
    FontWeight fontWeight = FontWeight.w500,
  }) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = circleColor;
    final Radius radius = Radius.circular(size.width / 2);

    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(0.0, 0.0, size.width.toDouble(), size.height.toDouble()),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        paint);

    TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
    painter.text = TextSpan(
      text: text,
      style: TextStyle(fontSize: fontSize, color: fontColor, fontWeight: fontWeight),
    );

    painter.layout();
    painter.paint(canvas, Offset((size.width * 0.5) - painter.width * 0.5, (size.height * .5) - painter.height * 0.5));

    final img = await pictureRecorder.endRecording().toImage(size.width.toInt(), size.height.toInt());
    final data = await img.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  static Future<BitmapDescriptor> downloadResizePicture({required String url, int imageSize = 50}) async {
    final File imageFile = await DefaultCacheManager().getSingleFile(url);
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Uint8List imageUint8List = await imageFile.readAsBytes();
    final ui.Codec codec = await ui.instantiateImageCodec(imageUint8List);
    final ui.FrameInfo imageFI = await codec.getNextFrame();
    paintImage(
        canvas: canvas, rect: Rect.fromLTWH(0, 0, imageSize.toDouble(), imageSize.toDouble()), image: imageFI.image);
    final image = await pictureRecorder.endRecording().toImage(imageSize, (imageSize * 1.1).toInt());
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  static Future<BitmapDescriptor> downloadResizePictureCircle(
    String url, {
    int size = 150,
    bool addBorder = false,
    Color borderColor = Colors.white,
    double borderSize = 10.0,
  }) async {
    try {
      final http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
      return await _resizeCircle(
        response.bodyBytes,
        size: size,
        addBorder: addBorder,
        borderColor: borderColor,
        borderSize: borderSize,
      );
      } else {
        print('⚠️ Image not found. Using fallback image.');
        return await _getFallbackImage(size, addBorder, borderColor, borderSize);
      }
    } catch (e) {
      print('❌ Error loading image for marker: $e');
      // Fallback to default image URL
      final fallbackUrl = "https://i.ibb.co.com/vxkjJQD/Png-Item-1503945.png";
      try {
        final response = await http.get(Uri.parse(fallbackUrl));
        if (response.statusCode == 200) {
          return await _resizeCircle(response.bodyBytes,
              size: size,
              addBorder: addBorder,
              borderColor: borderColor,
              borderSize: borderSize);
        } else {
          print('❌ Failed to load fallback image.');
          return BitmapDescriptor.defaultMarker;
        }
      } catch (e) {
        print('❌ Error loading fallback image: $e');
        return BitmapDescriptor.defaultMarker;
      }
    }
    }

    static Future<BitmapDescriptor> _getFallbackImage(
  int size,
  bool addBorder,
  Color borderColor,
  double borderSize,
) async {
  final fallbackUrl = "https://i.ibb.co/vxkjJQD/Png-Item-1503945.png"; // ✅ URL valid

  try {
    final response = await http.get(Uri.parse(fallbackUrl));
    if (response.statusCode == 200) {
      return await _resizeCircle(
        response.bodyBytes,
        size: size,
        addBorder: addBorder,
        borderColor: borderColor,
        borderSize: borderSize,
      );
    } else {
      print('❌ Fallback image failed to load too.');
      return BitmapDescriptor.defaultMarker;
    }
  } catch (e) {
    print('❌ Error loading fallback image: $e');
    return BitmapDescriptor.defaultMarker;
  }
}

    static Future<BitmapDescriptor>  _resizeCircle(
    Uint8List imageBytes, {
    required int size,
    required bool addBorder,
    required Color borderColor,
    required double borderSize,
  }) async {
    final codec = await ui.instantiateImageCodec(imageBytes, targetWidth: size, targetHeight: size);
    final frame = await codec.getNextFrame();
    final ui.Image originalImage = frame.image;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint();

    final center = Offset(size / 2, size / 2);
    final radius = size / 2;

    if (addBorder) {
      final borderPaint = Paint()
        ..color = borderColor
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, radius, borderPaint);
      canvas.drawCircle(center, radius - borderSize, paint);
    } else {
      canvas.drawCircle(center, radius, paint);
    }

    paint.shader = ImageShader(originalImage, TileMode.clamp, TileMode.clamp, Matrix4.identity().storage);
    canvas.drawCircle(center, radius - (addBorder ? borderSize : 0), paint);

    final picture = recorder.endRecording();
    final imgFinal = await picture.toImage(size, size);
    final byteData = await imgFinal.toByteData(format: ui.ImageByteFormat.png);
    final resizedBytes = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(resizedBytes);
  }

  static Future<BitmapDescriptor> widgetToIcon(GlobalKey globalKey) async {
    RenderRepaintBoundary boundary = globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
  }

  static Future<BitmapDescriptor> markerFromIcon(IconData icon, Color color, double size) async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    textPainter.text = TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          letterSpacing: 0.0,
          fontSize: size,
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
          color: color,
        ));
    textPainter.layout();
    textPainter.paint(canvas, Offset.zero);

    final picture = pictureRecorder.endRecording();
    final image = await picture.toImage(size.round(), size.round());
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }
}