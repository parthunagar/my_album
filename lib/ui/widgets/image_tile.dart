import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:monirth_memories/core/services/favorites_service.dart';
import 'package:monirth_memories/ui/gallary_app_demo/core/utils/app_string.dart';
import 'package:monirth_memories/ui/model/photo_model.dart';
import 'package:monirth_memories/ui/views/full_image/full_image_view.dart';
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

          final photoData = photos[i];
          final img =
              usePhotoObject ? (photoData as PhotoModel).url : photoData;
          final thumbnail = thumbnailUrl(img);

          return _ImageTile(i: i, img: img, thumbnail: thumbnail);
        },
      ),
    );
  }
}

class _ImageTile extends StatefulWidget {
  final String img;
  final String thumbnail;
  final int i;
  const _ImageTile({
    required this.i,
    required this.img,
    required this.thumbnail,
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
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FullImageView(
              id: widget.i,
              fullImagePath: widget.img,
              isAsset: false,
              favoritesService: fav,
            ),
          ),
        );
        setState(() {});
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            CachedNetworkImage(
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
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      transitionBuilder: (child, anim) => ScaleTransition(
                        scale: anim,
                        child: child,
                      ),
                      child: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        key: ValueKey(isFav),
                        color: isFav ? Colors.redAccent : Colors.white,
                        size: 22,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
