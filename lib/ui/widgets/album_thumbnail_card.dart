import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:monirth_memories/ui/widgets/shimmer_pkg.dart';

// class AlbumThumbnailCard extends StatelessWidget {
//   final String title;
//   final String imageUrl;
//   final VoidCallback? onTap;
//   final double height;
//   final double borderRadius;

//   const AlbumThumbnailCard({
//     super.key,
//     required this.title,
//     required this.imageUrl,
//     this.onTap,
//     this.height = 200,
//     this.borderRadius = 12,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final thumbUrl =
//         'https://images.weserv.nl/?url=${Uri.encodeComponent(imageUrl)}&fit=cover&w=600&h=400';

//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         children: [
//           Stack(
//             alignment: Alignment.bottomLeft,
//             children: [
//               // --- Image with rounded corners and shadow ---
//               Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(borderRadius),
//                   boxShadow: const [
//                     BoxShadow(
//                       color: Colors.black26,
//                       blurRadius: 6,
//                       offset: Offset(2, 2),
//                     ),
//                   ],
//                 ),
//                 clipBehavior: Clip.antiAlias,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(borderRadius),
//                   child: CachedNetworkImage(
//                     imageUrl: thumbUrl,
//                     width: double.infinity,
//                     height: height,
//                     fit: BoxFit.cover,
//                     fadeInDuration: const Duration(milliseconds: 300),
//                     fadeOutDuration: const Duration(milliseconds: 100),
//                     placeholder: (context, url) => Shimmer.fromColors(
//                       baseColor: Colors.grey[300]!,
//                       highlightColor: Colors.grey[100]!,
//                       child: Container(
//                         width: double.infinity,
//                         height: height,
//                         decoration: BoxDecoration(
//                           color: Colors.grey[300],
//                           borderRadius: BorderRadius.circular(borderRadius),
//                         ),
//                       ),
//                     ),
//                     errorWidget: (context, url, error) =>
//                         const Icon(Icons.broken_image),
//                   ),
//                 ),
//               ),

//               // --- Gradient overlay for fade effect ---
//               Container(
//                 height: height,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(borderRadius),
//                   gradient: const LinearGradient(
//                     begin: Alignment.bottomCenter,
//                     end: Alignment.topCenter,
//                     colors: [
//                       Colors.black54, // bottom shadow
//                       Colors.transparent, // fade upward
//                     ],
//                     stops: [0.0, 0.7],
//                   ),
//                 ),
//               ),

//               // --- Text overlay ---
//               Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Text(
//                   title,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     shadows: [
//                       Shadow(
//                         color: Colors.black45,
//                         blurRadius: 6,
//                         offset: Offset(1, 1),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//         ],
//       ),
//     );
//   }
// }


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
                // --- Image with soft shadow ---
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
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: double.infinity,
                          height: widget.height,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius:
                                BorderRadius.circular(widget.borderRadius),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.broken_image, size: 50),
                    ),
                  ),
                ),

                // --- Gradient overlay for bottom fade ---
                Container(
                  height: widget.height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.6),
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

                // --- Title text with glass effect ---
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
                      color: Colors.black.withOpacity(0.25),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(widget.borderRadius),
                      ),
                    ),
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
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
