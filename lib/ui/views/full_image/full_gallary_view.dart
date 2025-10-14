// // ignore_for_file: use_build_context_synchronously

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:monirth_memories/core/app.locator.dart';
// import 'package:monirth_memories/core/services/favorites_service.dart';
// import 'package:monirth_memories/ui/model/photo_model.dart';
// import 'package:monirth_memories/ui/widgets/custom_app_bar.dart';
// import 'package:monirth_memories/ui/widgets/progress_bar.dart';
// import 'package:monirth_memories/ui/widgets/shimmer_effect.dart';
// import 'package:monirth_memories/utils/globals.dart';
// import 'package:photo_view/photo_view.dart';
// import 'package:gallery_saver_plus/gallery_saver.dart';

// class FullGalleryView extends StatefulWidget {
//   final List<PhotoModel> photos;
//   final int initialIndex;
//   const FullGalleryView(
//       {required this.photos, this.initialIndex = 0, super.key});

//   @override
//   State<FullGalleryView> createState() => _FullGalleryViewState();
// }

// class _FullGalleryViewState extends State<FullGalleryView>
//     with SingleTickerProviderStateMixin {
//   late PageController pageController;
//   late ScrollController thumbController;
//   late AnimationController animController;
//   late Animation<double> anim;
//   int currentIndex = 0;
//   double verticalDrag = 0, maxDrag = 300, rotation = 0;
//   final prefService = PreferenceService();

//   late List<PhotoViewController> controllers;
//   late List<PhotoViewScaleStateController> scaleControllers;
//   @override
//   void initState() {
//     super.initState();
//     controllers =
//         List.generate(widget.photos.length, (_) => PhotoViewController());
//     scaleControllers = List.generate(
//         widget.photos.length, (_) => PhotoViewScaleStateController());

//     currentIndex = widget.initialIndex;
//     pageController = PageController(initialPage: currentIndex);
//     thumbController = ScrollController();
//     animController = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 300));
//     SystemChrome.setPreferredOrientations(DeviceOrientation.values);
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       prefetchImages(currentIndex);
//       scrollThumb(currentIndex);
//     });
//   }

//   @override
//   void dispose() {
//     for (var c in controllers) {
//       c.dispose();
//     }
//     for (var s in scaleControllers) {
//       s.dispose();
//     }

//     pageController.dispose();
//     thumbController.dispose();
//     animController.dispose();
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//     ]);
//     super.dispose();
//   }

//   void prefetchImages(int index) {
//     for (int i = index - 2; i <= index + 2; i++) {
//       if (i >= 0 && i < widget.photos.length) {
//         precacheImage(
//           CachedNetworkImageProvider(widget.photos[i].url,
//               maxWidth: 1080, maxHeight: 1080),
//           context,
//         );
//       }
//     }
//   }

//   void scrollThumb(int index) {
//     final offset = (index * 68) - MediaQuery.of(context).size.width / 2 + 34;
//     thumbController.animateTo(
//       offset.clamp(
//         thumbController.position.minScrollExtent,
//         thumbController.position.maxScrollExtent,
//       ),
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//     );
//   }

//   List<PhotoModel> get visibleThumbs {
//     final start = (currentIndex - 10).clamp(0, widget.photos.length);
//     final end = (currentIndex + 10).clamp(0, widget.photos.length);
//     return widget.photos.sublist(start, end);
//   }

//   double get bgOpacity => (1 - (verticalDrag.abs() / maxDrag)).clamp(0.0, 1.0);

//   void animateBack() {
//     anim = Tween<double>(begin: verticalDrag, end: 0)
//         .animate(CurvedAnimation(parent: animController, curve: Curves.easeOut))
//       ..addListener(() => setState(() => verticalDrag = anim.value));
//     animController.forward(from: 0);
//   }

//   Future<void> saveImage(String url) async {
//     try {
//       await GallerySaver.saveImage(url);
//       snackBar(context, 'Saved!');
//     } catch (_) {
//       snackBar(context, 'Failed to save');
//     }
//   }

//   Widget buildFullImage(PhotoModel photo, int i, bool isCurrent) {
//     return Hero(
//       tag: 'photo_$i',
//       child: AnimatedOpacity(
//         opacity: isCurrent ? 1 : 0.4,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeOut,
//         child: AnimatedScale(
//           scale: isCurrent ? 1.0 : 0.9,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//           child: Transform.translate(
//             offset: Offset(0, verticalDrag),
//             child: Transform.rotate(
//               angle: rotation,
//               child: GestureDetector(
//                 onDoubleTap: () {
//                   setState(() {
//                     final nextScale =
//                         (controllers[i].scale ?? 1.0) == 1.0 ? 2.5 : 1.0;
//                     controllers[i].scale = nextScale;
//                   });
//                 },
//                 child: PhotoView(
//                   controller: controllers[i],
//                   scaleStateController: scaleControllers[i],
//                   imageProvider: CachedNetworkImageProvider(
//                     photo.url,
//                     cacheKey: photo.url,
//                   ),
//                   minScale: PhotoViewComputedScale.contained,
//                   maxScale: PhotoViewComputedScale.covered * 3,
//                   backgroundDecoration:
//                       const BoxDecoration(color: Colors.transparent),
//                   loadingBuilder: (_, __) => const SmoothImagePlaceholder(),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildThumb(PhotoModel photo, bool isSelected) {
//     final model = locator<PreferenceService>();
//     return GestureDetector(
//       onTap: () => pageController.jumpToPage(widget.photos.indexOf(photo)),
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 4),
//         decoration: BoxDecoration(
//           border: isSelected
//               ? Border.all(
//                   color: model.isDark ? Colors.white : Colors.black, width: 1.5)
//               : null,
//           borderRadius: BorderRadius.circular(6),
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(5),
//           child: CachedNetworkImage(
//               imageUrl: photo.url,
//               width: 55,
//               memCacheWidth: 120,
//               memCacheHeight: 120,
//               fit: BoxFit.fill,
//               placeholder: (_, __) => ShimmerEffect()),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final model = locator<PreferenceService>();
//     return Opacity(
//       opacity: bgOpacity,
//       child: ParentView(
//         backgroundColor: Colors.transparent,
//         showLeading: true,
//         showAppBar: false,
//         body: GestureDetector(
//           onVerticalDragUpdate: (d) {
//             setState(() => verticalDrag += d.delta.dy);
//           },
//           onVerticalDragEnd: (_) {
//             verticalDrag > 150 ? Navigator.pop(context) : animateBack();
//           },
//           child: Stack(
//             children: [
//               Container(
//                   color: model.isDark
//                       ? Colors.black.withValues(alpha: bgOpacity)
//                       : Colors.white.withValues(alpha: bgOpacity)),
//               PageView.builder(
//                 controller: pageController,
//                 itemCount: widget.photos.length,
//                 onPageChanged: (i) {
//                   setState(() {
//                     currentIndex = i;
//                     rotation = 0;
//                   });
//                   scaleControllers[i].scaleState = PhotoViewScaleState.initial;

//                   prefetchImages(i);
//                   scrollThumb(i);
//                 },
//                 itemBuilder: (_, i) =>
//                     buildFullImage(widget.photos[i], i, i == currentIndex),
//               ),
//               Positioned(
//                 top: MediaQuery.of(context).padding.top + 4,
//                 right: 16,
//                 child: Row(
//                   children: [
//                     IconButton(
//                         icon: const Icon(Icons.download, color: Colors.white),
//                         onPressed: () =>
//                             saveImage(widget.photos[currentIndex].url)),
//                     IconButton(
//                         icon:
//                             const Icon(Icons.rotate_right, color: Colors.white),
//                         onPressed: () =>
//                             setState(() => rotation += 90 * 3.14159 / 180)),
//                     FutureBuilder<bool>(
//                       future:
//                           prefService.contains(widget.photos[currentIndex].url),
//                       builder: (_, snap) {
//                         final isFav = snap.data ?? false;
//                         return IconButton(
//                           icon: Icon(
//                             isFav ? Icons.favorite : Icons.favorite_border,
//                             color: isFav ? Colors.redAccent : Colors.white,
//                           ),
//                           onPressed: () async {
//                             final url = widget.photos[currentIndex].url;
//                             isFav
//                                 ? await prefService.remove(url)
//                                 : await prefService.add(url);
//                             setState(() {});
//                           },
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               Positioned(
//                 bottom: 16,
//                 left: 0,
//                 right: 0,
//                 height: 60,
//                 child: ListView.builder(
//                   controller: thumbController,
//                   scrollDirection: Axis.horizontal,
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   itemCount: visibleThumbs.length,
//                   itemBuilder: (_, i) {
//                     final photo = visibleThumbs[i];
//                     return buildThumb(
//                         photo, widget.photos.indexOf(photo) == currentIndex);
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
