// ignore: must_be_immutable
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:monirth_memories/main.dart';
import 'package:monirth_memories/ui/model/photo_model.dart';
import 'package:monirth_memories/ui/widgets/shimmer_effect.dart';
import 'package:monirth_memories/ui/widgets/video_player.dart';
import 'package:pip_view/pip_view.dart';

class VideoGrid extends StatelessWidget {
  final ScrollController? controller;
  final dynamic videos;
  final bool useShimmer;
  final bool useVideoObject;
  final bool? isLoading;

  const VideoGrid({
    super.key,
    this.controller,
    required this.videos,
    this.useShimmer = false,
    this.useVideoObject = false,
    this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final totalCount =
        videos.length + (isLoading == true && useShimmer ? 6 : 0);
    bool isDark = themeMode == ThemeMode.dark;
    return MasonryGridView.builder(
      controller: controller,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      itemCount: totalCount,
      itemBuilder: (context, i) {
        if (i >= videos.length) return ShimmerEffect(height: 110);

        final video = useVideoObject ? (videos[i] as PhotoModel) : null;
        final String videoUrl = video?.url ?? '';
        final String title = video?.title ?? '';

        return ValueListenableBuilder<Uint8List?>(
          valueListenable: video!.thumbnailNotifier,
          builder: (context, thumbData, _) {
            return GestureDetector(
              onTap: thumbData == null
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PIPView(
                            builder: (context, isFloating) =>
                                MyPlayer(videoUrl: videoUrl),
                          ),
                        ),
                      );
                    },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade800),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Stack(
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: thumbData == null
                              ? ShimmerEffect(height: 110)
                              : Image.memory(
                                  thumbData,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                  errorBuilder: (_, e, s) =>
                                      ShimmerEffect(height: 110),
                                ),
                        ),
                        if (thumbData != null) ...[
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withValues(alpha: 0.02),
                                  Colors.black.withValues(alpha: 0.35),
                                ],
                              ),
                            ),
                          ),
                          const Center(
                            child: Icon(
                              Icons.play_circle_fill_rounded,
                              color: Colors.white,
                              size: 30,
                              shadows: [
                                Shadow(color: Colors.black54, blurRadius: 10),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            left: 10,
                            right: 10,
                            child: Text(
                              title,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: isDark ? null : Colors.white,
                                shadows: const [
                                  Shadow(
                                    color: Colors.black54,
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
