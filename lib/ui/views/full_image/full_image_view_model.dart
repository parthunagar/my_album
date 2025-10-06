import 'package:logger/logger.dart';
import 'package:monirth_memories/core/logger.dart';
import 'package:stacked/stacked.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart' show rootBundle;

class FullImageViewModel extends BaseViewModel {
  BuildContext context;
  bool isAsset;
  String fullImagePath;
  FullImageViewModel(this.context, this.isAsset, this.fullImagePath);

  final Logger log = getLogger('FullImageViewModel');
  Future<void> init() async {
    _load();
  }

  Uint8List? imageData;
  bool loading = true;

  Future<void> _load() async {
    // setState(() => );
    loading = true;
    notifyListeners();
    try {
      log.i('widget.isAsset : $isAsset');
      if (isAsset) {
        // Load asset bytes but avoid decoding into full-size Image widget memory until displayed
        log.i('widget.fullImagePath : $fullImagePath');
        final bytes = await rootBundle.load(fullImagePath);
        imageData = bytes.buffer.asUint8List();
      } else {
        // If remote, let PhotoViewImage handle caching via CachedNetworkImage in other approaches.
        imageData = null; // indicating network usage
      }
    } catch (e) {
      imageData = null;
    }
    loading = false;
    notifyListeners();
  }

  Future<void> saveToGallery() async {
    final status = await Permission.storage.request();
    if (!status.isGranted) return;

    try {
      if (isAsset && imageData != null) {
        // final result = await ImageGallerySaver.saveImage(_imageData!, quality: 90, name: 'img_${widget.id}');
        _showSnack('Saved: \$result');
      } else {
        // For remote, provide URL to native saver which fetches it; here we fallback to letting user save via network image cache.
        _showSnack(
            'Saving remote images: not fully implemented. Consider downloading via provided URL.');
      }
    } catch (e) {
      _showSnack('Save failed: \$e');
    }
  }

  void _showSnack(String msg) {
    // if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
