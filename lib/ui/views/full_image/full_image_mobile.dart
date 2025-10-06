part of full_image_view;

class _FullImageMobile extends ViewModelWidget<FullImageViewModel> {
  final int id;
  final String fullImagePath;
  final bool isAsset;
  final FavoritesService favoritesService;

  const _FullImageMobile({
    required this.id,
    required this.fullImagePath,
    required this.isAsset,
    required this.favoritesService,
  });

  @override
  Widget build(BuildContext context, FullImageViewModel vm) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Day ${id + 1}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => vm.saveToGallery(),
          ),
          FutureBuilder<bool>(
            future: favoritesService.contains(fullImagePath),
            builder: (context, snap) {
              final isFav = snap.data ?? false;
              return IconButton(
                icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
                onPressed: () async {
                  if (isFav) {
                    await favoritesService.remove(fullImagePath);
                  } else {
                    await favoritesService.add(fullImagePath);
                  }
                  vm.notifyListeners();
                },
              );
            },
          ),
        ],
      ),
      // body: vm.loading
      //     ? const Center(child: CircularProgressIndicator())
      //     : Hero(
      //         tag: fullImagePath, // vm.imageData!,
      //         child: PhotoView(
      //           imageProvider: isAsset && vm.imageData != null
      //               ? MemoryImage(vm.imageData!) as ImageProvider<Object>
      //               : CachedNetworkImageProvider(fullImagePath),
      //           enablePanAlways: true,
      //           minScale: PhotoViewComputedScale.contained,
      //           maxScale: PhotoViewComputedScale.covered * 3.0,
      //           loadingBuilder: (context, event) => const Center(
      //             child: CircularProgressIndicator(),
      //           ),
      //         ),
      //       ),
      body: Hero(
        tag: fullImagePath,
        child: Stack(
          fit: StackFit.expand,
          children: [
            /*
            if (!isAsset)
              CachedNetworkImage(
                imageUrl: fullImagePath,
                fit: BoxFit.cover,
                color: Colors.black.withValues(alpha: 0.5),
                colorBlendMode: BlendMode.darken,
                imageBuilder: (context, imageProvider) {
                  return ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                  );
                },
              ), */

            // ✅ Main interactive image view
            PhotoView(
              backgroundDecoration:
                  const BoxDecoration(color: Colors.transparent),
              imageProvider: isAsset && vm.imageData != null
                  ? MemoryImage(vm.imageData!) as ImageProvider<Object>
                  : CachedNetworkImageProvider(fullImagePath),
              enablePanAlways: true,
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 3,
              loadingBuilder: (context, event) {
                return const Center(
                  child: _SmoothImagePlaceholder(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SmoothImagePlaceholder extends StatelessWidget {
  const _SmoothImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              Colors.grey.shade800,
              Colors.grey.shade700,
              Colors.grey.shade800,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.all(20),
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white70,
          ),
        ),
      ),
    );
  }
}
