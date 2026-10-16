import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:printing/printing.dart';

class PdfToImageService {
  static Future<List<String>> savePdfAsImagesToGallery(Uint8List pdfData) async {
    final List<String> savedPaths = [];
    final raster = Printing.raster(pdfData, dpi: 300);

    int page = 0;
    await for (final pageImage in raster) {
      ui.Image img = await pageImage.toImage();

      // Crop the image to remove transparent/black padding
      img = await _cropTransparent(img);

      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      final bytes = byteData!.buffer.asUint8List();

      // Save to gallery
      final result = await ImageGallerySaverPlus.saveImage(
        bytes,
        name: "cover_page_${++page}",
        quality: 100,
      );

      if (result['isSuccess'] == true) {
        savedPaths.add(result['filePath']);
      }
    }

    return savedPaths;
  }

  // Crop transparent edges
  static Future<ui.Image> _cropTransparent(ui.Image image) async {
    final byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    final Uint8List pixels = byteData!.buffer.asUint8List();

    int width = image.width;
    int height = image.height;

    int top = 0, bottom = height - 1, left = 0, right = width - 1;
    bool found = false;

    // Find top
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        int i = (y * width + x) * 4;
        if (pixels[i + 3] != 0) { // alpha != 0
          top = y;
          found = true;
          break;
        }
      }
      if (found) break;
    }

    found = false;
    // Find bottom
    for (int y = height - 1; y >= 0; y--) {
      for (int x = 0; x < width; x++) {
        int i = (y * width + x) * 4;
        if (pixels[i + 3] != 0) {
          bottom = y;
          found = true;
          break;
        }
      }
      if (found) break;
    }

    found = false;
    // Find left
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        int i = (y * width + x) * 4;
        if (pixels[i + 3] != 0) {
          left = x;
          found = true;
          break;
        }
      }
      if (found) break;
    }

    found = false;
    // Find right
    for (int x = width - 1; x >= 0; x--) {
      for (int y = 0; y < height; y++) {
        int i = (y * width + x) * 4;
        if (pixels[i + 3] != 0) {
          right = x;
          found = true;
          break;
        }
      }
      if (found) break;
    }

    int croppedWidth = right - left + 1;
    int croppedHeight = bottom - top + 1;

    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    final paint = ui.Paint();
    canvas.drawImageRect(
      image,
      ui.Rect.fromLTWH(left.toDouble(), top.toDouble(), croppedWidth.toDouble(), croppedHeight.toDouble()),
      ui.Rect.fromLTWH(0, 0, croppedWidth.toDouble(), croppedHeight.toDouble()),
      paint,
    );

    final croppedImage = await recorder.endRecording().toImage(croppedWidth, croppedHeight);
    return croppedImage;
  }
}
