
// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:monirth_memories/ui/model/photo_model.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class VideoListViewModel extends BaseViewModel {
  final String jsonUrl;
  VideoListViewModel(this.jsonUrl);

  List<PhotoModel> allVideos = [];
  List<PhotoModel> visibleVideos = [];

  int currentPage = 0;
  final int pageSize = 15;
  bool isLoading = false;
  bool allLoaded = false;
  bool isGeneratingThumbnails = false;

  final ScrollController scrollController = ScrollController();

  Future<void> init() async {
    await fetchVideos();
    scrollController.addListener(() {
      final maxScroll = scrollController.position.maxScrollExtent;
      final current = scrollController.position.pixels;
      if (current >= maxScroll - 300 && !isLoading && !allLoaded) {
        loadMore();
      }
    });
  }

  /// 🧠 Fetch videos
  Future<void> fetchVideos() async {
    try {
      final response = await http.get(Uri.parse(jsonUrl));
      if (response.statusCode == 200) {
        final parsed = await compute(parsePhotos, response.body);
        allVideos = parsed;

        // ✅ Attach cached thumbnails if available
        for (final video in allVideos) {
          final cachedFile = await _getCachedThumbnailFile(video.url);
          if (await cachedFile.exists()) {
            final bytes = await cachedFile.readAsBytes();
            video.thumbnailNotifier.value = bytes;
          }
        }

        visibleVideos.clear();
        currentPage = 0;
        allLoaded = false;
        notifyListeners();
        loadMore();
      } else {
        debugPrint("❌ Error: ${response.statusCode} || ${response.body}");
      }
    } catch (e) {
      debugPrint("❌ Error fetching videos: $e");
    }
  }

  Future<void> loadMore() async {
    if (isLoading || allLoaded) return;

    isLoading = true;
    notifyListeners();

    final start = currentPage * pageSize;
    final end = (start + pageSize).clamp(0, allVideos.length);

    if (start >= allVideos.length) {
      allLoaded = true;
      isLoading = false;
      notifyListeners();
      return;
    }

    final newVideos = allVideos.sublist(start, end);
    visibleVideos.addAll(newVideos);
    currentPage++;
    isLoading = false;
    notifyListeners();
    debugPrint(
        '🎞️ Loaded videos: ${visibleVideos.length}/${allVideos.length}');
    _generateThumbnailsAsync(newVideos);
  }

  final List<PhotoModel> _thumbnailQueue = [];

  /// ✅ Generates thumbnails once and caches locally
  Future<void> _generateThumbnailsAsync(List<PhotoModel> videos) async {
    _thumbnailQueue.addAll(videos);
    if (isGeneratingThumbnails) return;

    isGeneratingThumbnails = true;

    try {
      while (_thumbnailQueue.isNotEmpty) {
        final batch = _thumbnailQueue.take(3).toList();
        _thumbnailQueue.removeRange(0, batch.length);

        await Future.wait(batch.map((video) async {
          if (video.thumbnailNotifier.value != null) return;

          final cachedFile = await _getCachedThumbnailFile(video.url);
          if (await cachedFile.exists()) {
            final bytes = await cachedFile.readAsBytes();
            video.thumbnailNotifier.value = bytes;
            return;
          }

          try {
            final thumb = await VideoThumbnail.thumbnailData(
              video: video.url,
              imageFormat: ImageFormat.WEBP,
              maxHeight: 100,
              quality: 65,
              timeMs: 650,
            );

            if (thumb != null) {
              video.thumbnailNotifier.value = thumb;
              await cachedFile.writeAsBytes(thumb, flush: true);
            }
          } catch (e) {
            debugPrint('⚠️ Thumbnail generation failed for ${video.url}: $e');
          }
        }));

        await Future.delayed(const Duration(milliseconds: 10));
      }
    } finally {
      isGeneratingThumbnails = false;
    }
  }

  /// 🗂️ Local cache path for each thumbnail
  Future<File> _getCachedThumbnailFile(String videoUrl) async {
    final dir = await getApplicationDocumentsDirectory();
    final safeName = videoUrl.hashCode.toString();
    final filePath = '${dir.path}/thumb_$safeName.webp';
    return File(filePath);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}

// class VideoListViewModel extends BaseViewModel {
//   final String jsonUrl;
//   VideoListViewModel(this.jsonUrl);

//   List<PhotoModel> allVideos = [];
//   List<PhotoModel> visibleVideos = [];

//   int currentPage = 0;
//   final int pageSize = 15;
//   bool isLoading = false;
//   bool allLoaded = false;
//   bool isGeneratingThumbnails = false;

//   final ScrollController scrollController = ScrollController();

//   Future<void> init() async {
//     await fetchVideos();
//     scrollController.addListener(() {
//       final maxScroll = scrollController.position.maxScrollExtent;
//       final current = scrollController.position.pixels;
//       if (current >= maxScroll - 300 && !isLoading && !allLoaded) {
//         loadMore();
//       }
//     });
//   }

//   /// 🧠 Fetch videos
//   Future<void> fetchVideos() async {
//     try {
//       final response = await http.get(Uri.parse(jsonUrl));
//       if (response.statusCode == 200) {
//         final parsed = await compute(parsePhotos, response.body);
//         allVideos = parsed;
//         visibleVideos.clear();
//         currentPage = 0;
//         allLoaded = false;
//         notifyListeners();
//         loadMore();
//       } else {
//         debugPrint("❌ Error: ${response.statusCode} || ${response.body}");
//       }
//     } catch (e) {
//       debugPrint("❌ Error fetching videos: $e");
//     }
//   }

//   Future<void> loadMore() async {
//     if (isLoading || allLoaded) return;

//     isLoading = true;
//     notifyListeners();

//     final start = currentPage * pageSize;
//     final end = (start + pageSize).clamp(0, allVideos.length);

//     if (start >= allVideos.length) {
//       allLoaded = true;
//       isLoading = false;
//       notifyListeners();
//       return;
//     }

//     final newVideos = allVideos.sublist(start, end);
//     visibleVideos.addAll(newVideos);
//     currentPage++;
//     isLoading = false;
//     notifyListeners();
//     debugPrint(
//         '🎞️ Loaded videos: ${visibleVideos.length}/${allVideos.length}');
//     _generateThumbnailsAsync(newVideos);
//   }

//   final List<PhotoModel> _thumbnailQueue = [];

//   /*
//   Future<void> _generateThumbnailsAsync(List<PhotoModel> videos) async {
//     _thumbnailQueue.addAll(videos);
//     if (isGeneratingThumbnails) return;
//     isGeneratingThumbnails = true;
//     try {
//       while (_thumbnailQueue.isNotEmpty) {
//         final video = _thumbnailQueue.removeAt(0);
//         if (video.thumbnailNotifier.value != null) continue;
//         try {
//           final thumb = await VideoThumbnail.thumbnailData(
//             video: video.url,
//             imageFormat: ImageFormat.WEBP,
//             maxHeight: 124,
//             quality: 75,
//             timeMs: 1000,
//           );
//           if (thumb != null) {
//             video.thumbnailNotifier.value = thumb;
//           }
//         } catch (e) {
//           debugPrint('⚠️ Thumbnail generation failed for ${video.url}: $e');
//         }
//         await Future.delayed(const Duration(milliseconds: 30));
//       }
//     } finally {
//       isGeneratingThumbnails = false;
//     }
//   }
//    */

//   Future<void> _generateThumbnailsAsync(List<PhotoModel> videos) async {
//     // Add new videos to queue
//     _thumbnailQueue.addAll(videos);

//     // Already generating? Just return; queue will handle it.
//     if (isGeneratingThumbnails) return;

//     isGeneratingThumbnails = true;

//     try {
//       while (_thumbnailQueue.isNotEmpty) {
//         final batch = _thumbnailQueue.take(3).toList();
//         _thumbnailQueue.removeRange(0, batch.length);
//         await Future.wait(batch.map((video) async {
//           if (video.thumbnailNotifier.value != null) return;

//           try {
//             final thumb = await VideoThumbnail.thumbnailData(
//               video: video.url,
//               imageFormat: ImageFormat.WEBP,
//               maxHeight: 100,
//               quality: 65,
//               timeMs: 650,
//             );

//             if (thumb != null) {
//               video.thumbnailNotifier.value = thumb;
//             }
//           } catch (e) {
//             debugPrint('⚠️ Thumbnail generation failed for ${video.url}: $e');
//           }
//         }));
//         await Future.delayed(const Duration(milliseconds: 5));
//         // await Future.delayed(const Duration(milliseconds: 15));
//       }
//     } finally {
//       isGeneratingThumbnails = false;
//     }
//   }

//   @override
//   void dispose() {
//     scrollController.dispose();
//     super.dispose();
//   }
// }
