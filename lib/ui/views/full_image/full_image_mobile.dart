part of full_image_view;

class _FullImageMobile extends ViewModelWidget<FullImageViewModel> {
  final int id;
  final String fullImagePath;
  final bool isAsset;
  final PreferenceService favoritesService;

  const _FullImageMobile({
    required this.id,
    required this.fullImagePath,
    required this.isAsset,
    required this.favoritesService,
  });

  @override
  Widget build(BuildContext context, FullImageViewModel vm) {
    return ParentView(
      title: 'Day ${id + 1}',
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
      body: Stack(
        fit: StackFit.expand,
        children: [
          PhotoView(
            backgroundDecoration:
                const BoxDecoration(color: Colors.transparent),
            imageProvider: isAsset && vm.imageData != null
                ? MemoryImage(vm.imageData!) as ImageProvider<Object>
                : CachedNetworkImageProvider(fullImagePath),
            enablePanAlways: true,
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 3,
            loadingBuilder: (_, e) => const SmoothImagePlaceholder(),
          ),
        ],
      ),
    );
  }
}
