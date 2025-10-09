import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:monirth_memories/main.dart';
import 'package:monirth_memories/ui/widgets/shimmer_effect.dart';

class AlbumThumbnailCard extends StatefulWidget {
  final String title;
  final String imageUrl;
  final VoidCallback? onTap;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;
  final double height;
  final double borderRadius;

  const AlbumThumbnailCard({
    super.key,
    required this.title,
    required this.imageUrl,
    this.onTap,
    this.isFavorite = false,
    this.onFavoriteTap,
    this.height = 200,
    this.borderRadius = 14,
  });

  @override
  State<AlbumThumbnailCard> createState() => _AlbumThumbnailCardState();
}

class _AlbumThumbnailCardState extends State<AlbumThumbnailCard>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final thumbUrl =
        'https://images.weserv.nl/?url=${Uri.encodeComponent(widget.imageUrl)}&fit=cover&w=600&h=400&mask=corners:${widget.borderRadius.toInt()}';
    bool isDark = themeMode == ThemeMode.dark;
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    child: CachedNetworkImage(
                      imageUrl: thumbUrl,
                      width: double.infinity,
                      height: widget.height,
                      fit: BoxFit.cover,
                      fadeInDuration: const Duration(milliseconds: 400),
                      fadeOutDuration: const Duration(milliseconds: 200),
                      placeholder: (context, url) => ShimmerEffect(height: 200),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.broken_image, size: 50),
                    ),
                  ),
                ),
                Container(
                  height: widget.height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.6),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.7],
                    ),
                  ),
                ),

                // --- Favorite icon ---
                /*
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: widget.onFavoriteTap,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      transitionBuilder: (child, anim) => ScaleTransition(scale: anim,child: child),
                      child: Icon(
                        widget.isFavorite ? Icons.favorite : Icons.favorite_border,
                        key: ValueKey(widget.isFavorite),
                        color: widget.isFavorite ? Colors.redAccent : Colors.white,
                        size: 26,
                      ),
                    ),
                  ),
                ), */

                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.black.withValues(alpha: 0.25)
                          : Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(widget.borderRadius),
                      ),
                    ),
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        shadows: [
                          Shadow(
                            color: Colors.black54,
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
