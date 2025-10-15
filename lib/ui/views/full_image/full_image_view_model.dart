// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:logger/logger.dart';
import 'package:monirth_memories/core/logger.dart';
import 'package:monirth_memories/core/services/favorites_service.dart';
import 'package:monirth_memories/ui/model/photo_model.dart';
import 'package:monirth_memories/utils/globals.dart';
import 'package:photo_view/photo_view.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemChrome, DeviceOrientation;

class FullImageViewModel extends BaseViewModel{
  BuildContext context;
  final List<PhotoModel> photos;
  int initialIndex;
  FullImageViewModel(this.context,
      {required this.photos, this.initialIndex = 0});

  final Logger log = getLogger('FullImageViewModel');

  late PageController pageController;
  late ScrollController thumbController;
  late AnimationController animController;
  late Animation<double> anim;

  double verticalDrag = 0, maxDrag = 300, rotation = 0;
  final prefService = PreferenceService();

  late List<PhotoViewController> controllers;
  late List<PhotoViewScaleStateController> scaleControllers;

  Future<void> init() async {
    controllers = List.generate(photos.length, (_) => PhotoViewController());
    scaleControllers =
        List.generate(photos.length, (_) => PhotoViewScaleStateController());

    pageController = PageController(initialPage: initialIndex);
    thumbController = ScrollController();

    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      prefetchImages(initialIndex);
      scrollThumb(initialIndex);
    });
  }

  void prefetchImages(int index) {
    for (int i = index - 2; i <= index + 2; i++) {
      if (i >= 0 && i < photos.length) {
        precacheImage(
          CachedNetworkImageProvider(photos[i].url,
              maxWidth: 1080, maxHeight: 1080),
          context,
        );
      }
    }
  }

  void scrollThumb(int index) {
    final offset = (index * 68) - MediaQuery.of(context).size.width / 2 + 34;
    thumbController.animateTo(
      offset.clamp(
        thumbController.position.minScrollExtent,
        thumbController.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  List<PhotoModel> get visibleThumbs {
    final start = (initialIndex - 10).clamp(0, photos.length);
    final end = (initialIndex + 10).clamp(0, photos.length);
    return photos.sublist(start, end);
  }

  double get bgOpacity => (1 - (verticalDrag.abs() / maxDrag)).clamp(0.0, 1.0);

  void animateBack() {
    anim = Tween<double>(begin: verticalDrag, end: 0)
        .animate(CurvedAnimation(parent: animController, curve: Curves.easeOut))
      ..addListener(() {
        verticalDrag = anim.value;
        notifyListeners();
      });
    animController.forward(from: 0);
  }

  Future<void> saveImage(String url) async {
    try {
      await GallerySaver.saveImage(url);
      snackBar(context, 'Saved!');
    } catch (_) {
      snackBar(context, 'Failed to save');
    }
  }

  @override
  void dispose() {
    for (var c in controllers) {
      c.dispose();
    }
    for (var s in scaleControllers) {
      s.dispose();
    }

    pageController.dispose();
    thumbController.dispose();
    animController.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }
}
