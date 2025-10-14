part of favorites_view;

class _GalleryMobile extends ViewModelWidget<GalleryViewModel> {
  const _GalleryMobile();

  @override
  Widget build(BuildContext context, GalleryViewModel vm) {
    return ParentView(
      title: 'Gallery',
      actions: [
        IconButton(
          icon: const Icon(Icons.favorite_border),
          onPressed: () async {
            await AutoRouter.of(context).push(const FavoritesRoute());
            vm.notifyListeners();
          },
        ),
      ],
      body: vm.allPhotos.isEmpty
          // ? const PhotoGrid(
          //     photos: ["", "", "", "", "", "", "", "", "", "", "", ""],
          //     useShimmer: true,
          //   )
          ? PhotoGrid(photos: List.generate(12, (_) => null), useShimmer: true)
          : RefreshIndicator(
              onRefresh: () async {
                vm.currentPage = 0;
                vm.visiblePhotos.clear();
                vm.allLoaded = false;
                await vm.fetchPhotos();
              },
              child: PhotoGrid(
                controller: vm.scrollController,
                photos: vm.visiblePhotos,
                isLoading: vm.isLoading,
                useShimmer: true,
                usePhotoObject: true, // because vm.visiblePhotos has .url
              ),
            ),
    );
  }
}
