import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:monirth_memories/core/services/favorites_service.dart';
import 'package:monirth_memories/ui/gallary_app_demo/core/utils/app_string.dart';
import 'package:monirth_memories/ui/model/photo_model.dart';
import 'package:monirth_memories/ui/views/full_image/full_image_view.dart';
import 'package:monirth_memories/ui/widgets/progress_bar.dart';
import 'package:monirth_memories/ui/widgets/shimmer_effect.dart';

class PhotoGrid extends StatelessWidget {
  final ScrollController? controller;
  final List<dynamic> photos;
  final bool isLoading;
  final bool useShimmer;
  final bool usePhotoObject;
  final EdgeInsetsGeometry padding;

  const PhotoGrid({
    super.key,
    this.controller,
    required this.photos,
    this.isLoading = false,
    this.useShimmer = false,
    this.usePhotoObject = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
  });

  @override
  Widget build(BuildContext context) {
    final totalCount = photos.length + (isLoading && useShimmer ? 6 : 0);
    return Scrollbar(
      controller: controller,
      thumbVisibility: true,
      child: MasonryGridView.builder(
        controller: controller,
        padding: padding,
        gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        itemCount: totalCount,
        itemBuilder: (context, i) {
          if (i >= photos.length) {
            return ShimmerEffect();
          }

          final img = usePhotoObject ? (photos[i] as PhotoModel).url : null;
          final thumbnail = thumbnailUrl(img ?? '');

          return GestureDetector(
            onLongPress: () {
              showGeneralDialog(
                barrierDismissible: true,
                barrierColor: Colors.black.withValues(alpha: 0.5),
                barrierLabel: 'FullScreenImage',
                context: context,
                transitionBuilder: (context, anim1, anim2, child) {
                  return FadeTransition(
                    opacity: anim1,
                    child: child,
                  );
                },
                transitionDuration: const Duration(milliseconds: 300),
                pageBuilder: (context, anim1, anim2) {
                  return AlertDialog(
                    backgroundColor: Colors.transparent,
                    contentPadding: EdgeInsets.zero,
                    actionsAlignment: MainAxisAlignment.center,
                    alignment: Alignment.center,
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Hero(
                              tag: 'photo_$i',
                              child: CachedNetworkImage(
                                imageUrl: img ?? '',
                                fit: BoxFit.contain,
                                placeholder: (c, s) =>
                                    const SmoothImagePlaceholder(),
                                errorWidget: (c, s, e) =>
                                    const Icon(Icons.broken_image),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: _ImageTile(
              i: i,
              img: img ?? '',
              thumbnail: thumbnail,
              photoData: photos,
            ),
          );
        },
      ),
    );
  }
}

class _ImageTile extends StatefulWidget {
  final String img;
  final String thumbnail;
  final int i;
  final List<dynamic> photoData;
  const _ImageTile({
    required this.i,
    required this.img,
    required this.thumbnail,
    required this.photoData,
  });

  @override
  State<_ImageTile> createState() => _ImageTileState();
}

class _ImageTileState extends State<_ImageTile> {
  final PreferenceService fav = PreferenceService();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        List<PhotoModel> list = widget.photoData as List<PhotoModel>;
        for (int j = widget.i; j < widget.i + 3 && j < list.length; j++) {
          precacheImage(CachedNetworkImageProvider(list[j].url), context);
        }
        Navigator.push(
          context,
          PageRouteBuilder(
            opaque: false,
            pageBuilder: (context, animation, secondaryAnimation) =>
                FullImageView(
              photos: list,
              initialIndex: widget.i,
            ),
          ),
        );
        setState(() {});
      },
      child: Hero(
        tag: 'photo_${widget.i}',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              widget.thumbnail.isEmpty
                  ? ShimmerEffect()
                  : CachedNetworkImage(
                      imageUrl: widget.thumbnail,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200,
                      fadeInDuration: const Duration(milliseconds: 250),
                      fadeOutDuration: const Duration(milliseconds: 150),
                      memCacheHeight: 250,
                      memCacheWidth: 250,
                      maxHeightDiskCache: 300,
                      maxWidthDiskCache: 300,
                      placeholder: (c, s) => ShimmerEffect(),
                      errorListener: (val) {},
                      errorWidget: (c, s, e) =>
                          const Icon(Icons.broken_image, color: Colors.grey),
                    ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.4),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 6,
                right: 6,
                child: FutureBuilder<bool>(
                  future: fav.contains(widget.img),
                  builder: (context, snapshot) {
                    final isFav = snapshot.data ?? false;
                    return GestureDetector(
                      onTap: () async {
                        if (isFav) {
                          await fav.remove(widget.img);
                        } else {
                          await fav.add(widget.img);
                        }
                        setState(() {});
                      },
                      child: TweenAnimationBuilder<double>(
                        key: ValueKey(isFav),
                        tween: Tween<double>(begin: 0.8, end: 1.0),
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.elasticOut,
                        builder: (context, scale, child) {
                          return Transform.scale(
                            scale: scale,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.25),
                                shape: BoxShape.circle,
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 20,
                                    spreadRadius: 0.1,
                                    offset: Offset(4, 5),
                                  ),
                                ],
                              ),
                              child: Icon(
                                isFav ? Icons.favorite : Icons.favorite_border,
                                color: Colors.redAccent,
                                size: 22,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
