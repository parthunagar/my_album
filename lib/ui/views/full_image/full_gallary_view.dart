// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monirth_memories/core/app.locator.dart';
import 'package:monirth_memories/core/services/favorites_service.dart';
import 'package:monirth_memories/ui/model/photo_model.dart';
import 'package:monirth_memories/ui/widgets/custom_app_bar.dart';
import 'package:monirth_memories/ui/widgets/progress_bar.dart';
import 'package:monirth_memories/ui/widgets/shimmer_effect.dart';
import 'package:monirth_memories/utils/globals.dart';
import 'package:photo_view/photo_view.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';

class FullGalleryView extends StatefulWidget {
  final List<PhotoModel> photos;
  final int initialIndex;
  const FullGalleryView(
      {required this.photos, this.initialIndex = 0, super.key});

  @override
  State<FullGalleryView> createState() => _FullGalleryViewState();
}

class _FullGalleryViewState extends State<FullGalleryView>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late ScrollController _thumbController;
  late AnimationController _animController;
  late Animation<double> _anim;
  int currentIndex = 0;
  double verticalDrag = 0, maxDrag = 300, rotation = 0;
  final prefService = PreferenceService();

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: currentIndex);
    _thumbController = ScrollController();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _prefetchImages(currentIndex);
      _scrollThumb(currentIndex);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _thumbController.dispose();
    _animController.dispose();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    super.dispose();
  }

  void _prefetchImages(int index) {
    for (int i = index - 2; i <= index + 2; i++) {
      if (i >= 0 && i < widget.photos.length) {
        precacheImage(
            CachedNetworkImageProvider(widget.photos[i].url,
                maxWidth: 1080, maxHeight: 1080),
            context);
      }
    }
  }

  void _scrollThumb(int index) {
    final offset = (index * 68) - MediaQuery.of(context).size.width / 2 + 34;
    _thumbController.animateTo(
      offset.clamp(_thumbController.position.minScrollExtent,
          _thumbController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  List<PhotoModel> get _visibleThumbs {
    final start = (currentIndex - 10).clamp(0, widget.photos.length);
    final end = (currentIndex + 10).clamp(0, widget.photos.length);
    return widget.photos.sublist(start, end);
  }

  double get _bgOpacity => (1 - (verticalDrag.abs() / maxDrag)).clamp(0.0, 1.0);

  void _animateBack() {
    _anim = Tween<double>(begin: verticalDrag, end: 0).animate(
        CurvedAnimation(parent: _animController, curve: Curves.easeOut))
      ..addListener(() => setState(() => verticalDrag = _anim.value));
    _animController.forward(from: 0);
  }

  Future<void> _saveImage(String url) async {
    try {
      await GallerySaver.saveImage(url);
      snackBar(context, 'Saved!');
    } catch (_) {
      snackBar(context, 'Failed to save');
    }
  }

  Widget _buildFullImage(PhotoModel photo, int i) {
    // final scale = 1.0 - 0.2 * (_bgOpacity < 0.5 ? 1 - _bgOpacity : 0);
    final targetScale = 1.0 - 0.2 * (_bgOpacity < 0.5 ? 1 - _bgOpacity : 0);

    return Hero(
      tag: 'photo_$i',
      child: Transform.translate(
        offset: Offset(0, verticalDrag),
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.9, end: targetScale),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          builder: (_, scale, child) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              alignment: Alignment.center,
              child: Transform.scale(
                scale: scale,
                alignment: Alignment.center,
                child: child,
              ),
            );
          },
          child: PhotoView(
            imageProvider: CachedNetworkImageProvider(photo.url,
                maxWidth: 1080, maxHeight: 1080, cacheKey: photo.url),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 3,
            // enableRotation: true,
            enablePanAlways: true,
            backgroundDecoration:
                const BoxDecoration(color: Colors.transparent),
            loadingBuilder: (_, __) => const SmoothImagePlaceholder(),
          ),
        ),
      ),
    );
  }

  Widget _buildThumb(PhotoModel photo, bool isSelected) {
    final model = locator<PreferenceService>();
    return GestureDetector(
      onTap: () => _pageController.jumpToPage(widget.photos.indexOf(photo)),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          border: isSelected
              ? Border.all(
                  color: model.isDark ? Colors.white : Colors.black, width: 1.5)
              : null,
          borderRadius: BorderRadius.circular(6),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: CachedNetworkImage(
              imageUrl: photo.url,
              width: 55,
              memCacheWidth: 120,
              memCacheHeight: 120,
              fit: BoxFit.fill,
              placeholder: (_, __) => ShimmerEffect()),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = locator<PreferenceService>();
    return ParentView(
      backgroundColor: Colors.transparent,
      showLeading: true,
      showAppBar: false,
      actions: [
        FutureBuilder<bool>(
          future: prefService.contains(widget.photos[currentIndex].url),
          builder: (_, snap) {
            final isFav = snap.data ?? false;
            return IconButton(
              icon: Icon(isFav ? Icons.favorite : Icons.favorite_border,
                  color: Colors.redAccent),
              onPressed: () async {
                final url = widget.photos[currentIndex].url;
                isFav
                    ? await prefService.remove(url)
                    : await prefService.add(url);
                setState(() {});
              },
            );
          },
        ),
      ],
      body: GestureDetector(
        onVerticalDragUpdate: (d) => setState(() => verticalDrag += d.delta.dy),
        onVerticalDragEnd: (_) =>
            verticalDrag > 150 ? Navigator.pop(context) : _animateBack(),
        child: Stack(
          children: [
            Container(
                color: model.isDark
                    ? Colors.black.withOpacity(_bgOpacity)
                    : Colors.white.withOpacity(_bgOpacity)),
            PageView.builder(
              controller: _pageController,
              itemCount: widget.photos.length,
              onPageChanged: (i) {
                setState(() {
                  currentIndex = i;
                  rotation = 0;
                });
                _prefetchImages(i);
                _scrollThumb(i);
              },
              itemBuilder: (_, i) => _buildFullImage(widget.photos[i], i),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 4,
              right: 16,
              child: Row(
                children: [
                  IconButton(
                      icon: const Icon(Icons.download, color: Colors.white),
                      onPressed: () =>
                          _saveImage(widget.photos[currentIndex].url)),
                  IconButton(
                      icon: const Icon(Icons.rotate_right, color: Colors.white),
                      onPressed: () =>
                          setState(() => rotation += 90 * 3.14159 / 180)),
                ],
              ),
            ),
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              height: 60,
              child: ListView.builder(
                controller: _thumbController,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _visibleThumbs.length,
                itemBuilder: (_, i) {
                  final photo = _visibleThumbs[i];
                  return _buildThumb(
                      photo, widget.photos.indexOf(photo) == currentIndex);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*

class FullGalleryView extends StatefulWidget {
  final List<PhotoModel> photos;
  final int initialIndex;
  const FullGalleryView({
    required this.photos,
    this.initialIndex = 0,
    super.key,
  });

  @override
  State<FullGalleryView> createState() => _FullGalleryViewState();
}

class _FullGalleryViewState extends State<FullGalleryView>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late ScrollController _thumbController;
  late int currentIndex;
  final PreferenceService prefService = PreferenceService();
  double verticalDrag = 0;
  double maxDrag = 300.0;
  double _rotation = 0.0;

  late AnimationController _animController;
  late Animation<double> _anim;
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    currentIndex = widget.initialIndex;
    _thumbController = ScrollController();
    _pageController = PageController(initialPage: currentIndex);

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _prefetchImages(currentIndex);
      _scrollThumbnailToCenter(currentIndex);
    });
  }

  void _prefetchImages(int index) {
    for (int i = index - 2; i <= index + 2; i++) {
      if (i >= 0 && i < widget.photos.length) {
        precacheImage(
          CachedNetworkImageProvider(
            widget.photos[i].url,
            maxHeight: 1080,
            maxWidth: 1080,
          ),
          context,
        );
      }
    }
  }

  void _scrollThumbnailToCenter(int index) {
    final screenWidth = MediaQuery.of(context).size.width;
    const thumbWidth = 68; // width + margin of thumbnail
    final offset = (index * thumbWidth) - screenWidth / 2 + thumbWidth / 2;
    _thumbController.animateTo(
      offset.clamp(
        _thumbController.position.minScrollExtent,
        _thumbController.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  List<PhotoModel> _visibleThumbnails() {
    // Show only ±10 thumbnails around current index
    final start = (currentIndex - 10).clamp(0, widget.photos.length);
    final end = (currentIndex + 10).clamp(0, widget.photos.length);
    return widget.photos.sublist(start, end);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _thumbController.dispose();
    _animController.dispose();
    // Lock back to portrait only when leaving
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  Widget _buildFullImage(PhotoModel photo, int i) {
    final scale = 1.0 - 0.2 * (_bgOpacity < 0.5 ? 1 - _bgOpacity : 0);

    return Hero(
      tag: 'photo_$i',
      child: Transform.translate(
        offset: Offset(0, verticalDrag),
        child: Transform.scale(
          scale: scale,
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: _rotation),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            builder: (_, angle, child) {
              return Transform.rotate(
                angle: angle,
                child: child,
              );
            },
            child: PhotoView(
              imageProvider: CachedNetworkImageProvider(
                photo.url,
                maxWidth: 1080,
                maxHeight: 1080,
                cacheKey: photo.url,
              ),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 3,
              enablePanAlways: true,
              enableRotation: true,
              backgroundDecoration:
                  const BoxDecoration(color: Colors.transparent),
              loadingBuilder: (_, __) => const SmoothImagePlaceholder(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail(PhotoModel photo, bool isSelected, bool realIndex) {
    final model = locator<PreferenceService>();
    return GestureDetector(
      onTap: () => _pageController.jumpToPage(widget.photos.indexOf(photo)),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          border: isSelected
              ? Border.all(
                  color: model.isDark ? Colors.white : Colors.black,
                  width: 1.5,
                )
              : null,
          borderRadius: BorderRadius.circular(6),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: CachedNetworkImage(
            imageUrl: photo.url,
            width: 55,
            // height: 60,
            memCacheWidth: 120,
            memCacheHeight: 120,
            fit: BoxFit.fill,
            placeholder: (_, __) => ShimmerEffect(),
          ),
        ),
      ),
    );
  }

  void _animateBack() {
    _anim = Tween<double>(begin: verticalDrag, end: 0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    )..addListener(() {
        setState(() => verticalDrag = _anim.value);
      });

    _animController.forward(from: 0);
  }

  double get _bgOpacity => (1 - (verticalDrag.abs() / maxDrag)).clamp(0.0, 1.0);

  Future<void> _saveImage(String url) async {
    try {
      await GallerySaver.saveImage(url);
      snackBar(context, 'Image saved to gallery!');
    } catch (e) {
      snackBar(context, 'Failed to save image.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = locator<PreferenceService>();
    return ParentView(
      backgroundColor: Colors.transparent,
      showLeading: true,
      showAppBar: false,
      actions: [
        FutureBuilder<bool>(
          future: prefService.contains(widget.photos[currentIndex].url),
          builder: (context, snap) {
            final isFav = snap.data ?? false;
            return IconButton(
              icon: Icon(isFav ? Icons.favorite : Icons.favorite_border,
                  color: Colors.redAccent),
              onPressed: () async {
                final url = widget.photos[currentIndex].url;
                if (isFav) {
                  await prefService.remove(url);
                } else {
                  await prefService.add(url);
                }
                setState(() {});
              },
            );
          },
        ),
      ],
      body: GestureDetector(
        onVerticalDragUpdate: (details) {
          setState(() => verticalDrag += details.delta.dy);
        },
        onVerticalDragEnd: (details) {
          if (verticalDrag > 150) {
            Navigator.of(context).pop();
          } else {
            _animateBack();
          }
        },
        child: Stack(
          children: [
            Container(
              color: model.isDark
                  ? Colors.black.withValues(alpha: _bgOpacity)
                  : Colors.white.withValues(alpha: _bgOpacity),
            ),
            PageView.builder(
              controller: _pageController,
              itemCount: widget.photos.length,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                  _rotation = 0;
                });
                _prefetchImages(index);
                _scrollThumbnailToCenter(index);
              },
              itemBuilder: (_, i) => _buildFullImage(widget.photos[i], i),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 4,
              right: 16,
              child: Row(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.download, color: Colors.white),
                        onPressed: () =>
                            _saveImage(widget.photos[currentIndex].url),
                      ),
                      IconButton(
                        icon:
                            const Icon(Icons.rotate_right, color: Colors.white),
                        onPressed: () =>
                            setState(() => _rotation += 90 * 3.14159 / 180),
                      ),
                    ],
                  ),
                  FutureBuilder<bool>(
                    future:
                        prefService.contains(widget.photos[currentIndex].url),
                    builder: (context, snap) {
                      final isFav = snap.data ?? false;
                      return IconButton(
                        icon: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: Colors.redAccent),
                        onPressed: () async {
                          final url = widget.photos[currentIndex].url;
                          if (isFav) {
                            await prefService.remove(url);
                          } else {
                            await prefService.add(url);
                          }
                          setState(() {});
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 60,
                child: ListView.builder(
                  controller: _thumbController,
                  scrollDirection: Axis.horizontal,
                  itemCount: _visibleThumbnails().length,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemBuilder: (_, i) {
                    final photo = _visibleThumbnails()[i];
                    final realIndex = widget.photos.indexOf(photo);
                    final isSelected = realIndex == currentIndex;
                    return _buildThumbnail(
                        photo, i == currentIndex, isSelected);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

 */
