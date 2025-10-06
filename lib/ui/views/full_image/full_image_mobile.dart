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
    // FullImageViewModel vm = widget.viewModel;
    return Scaffold(
      appBar: AppBar(
        title: Text('Image ${id + 1}'),
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
      body: vm.loading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: isAsset && vm.imageData != null
                  ? Hero(
                      tag: vm.imageData!,
                      child: PhotoView(
                        imageProvider: MemoryImage(vm.imageData!),
                        // imageProvider: AssetImage(
                        //   widget.fullImagePath,
                        //   bundle: rootBundle,
                        //   cacheWidth: 1080, // decode only up to screen width
                        // ),
                        enablePanAlways: true,
                        minScale: PhotoViewComputedScale.contained,
                        maxScale: PhotoViewComputedScale.covered * 3.0,
                      ),
                    )
                  : Hero(
                      tag: fullImagePath,
                      child: PhotoView(
                        imageProvider: NetworkImage(fullImagePath),
                        enablePanAlways: true,
                        minScale: PhotoViewComputedScale.contained,
                        maxScale: PhotoViewComputedScale.covered * 3.0,
                      ),
                    ),
            ),
    );
  }
}
