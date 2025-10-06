part of favorites_view;

class _GalleryMobile extends ViewModelWidget<GalleryViewModel> {
  const _GalleryMobile();

  @override
  Widget build(BuildContext context, GalleryViewModel vm) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Gallery',
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FavoritesView(
                    favoritesService: vm.fav,
                    useThumbAssets: false,
                  ),
                ),
              );
              vm.notifyListeners();
            },
          )
        ],
      ),
      body: vm.allPhotos.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                vm.currentPage = 0;
                vm.visiblePhotos.clear();
                vm.allLoaded = false;
                await vm.fetchPhotos();
              },
              child: GridView.builder(
                controller: vm.scrollController,
                padding: const EdgeInsets.all(4),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                ),
                itemCount: vm.visiblePhotos.length + (vm.isLoading ? 3 : 0),
                itemBuilder: (context, index) {
                  if (index >= vm.visiblePhotos.length) {
                    return _buildShimmer();
                  }
                  final photo = vm.visiblePhotos[index];
                  final thumbUrl =
                      "https://images.weserv.nl/?url=${Uri.encodeComponent(photo.url)}&w=200&h=200&fit=cover";
                  return GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FullImageView(
                            id: index,
                            fullImagePath: photo.url,
                            isAsset: false,
                            favoritesService: vm.fav,
                          ),
                        ),
                      );
                      vm.notifyListeners();
                    },
                    child: GridTile(
                      footer: GridTileBar(
                        backgroundColor: Colors.black26,
                        leading: FutureBuilder<bool>(
                          future: vm.fav.contains(photo.url),
                          builder: (context, snap) {
                            final isFav = snap.data ?? false;
                            return IconButton(
                              icon: Icon(isFav
                                  ? Icons.favorite
                                  : Icons.favorite_border),
                              onPressed: () async {
                                if (isFav) {
                                  await vm.fav.remove(photo.url);
                                } else {
                                  await vm.fav.add(photo.url);
                                }
                                vm.notifyListeners();
                              },
                            );
                          },
                        ),
                        title: Text('${index + 1}'),
                      ),
                      child: Hero(
                        tag: photo.url,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: CachedNetworkImage(
                            // cacheManager: CustomCacheManager.instance,
                            imageUrl: thumbUrl, //photo.url,
                            placeholder: (c, s) => _buildShimmer(),
                            errorWidget: (c, s, e) =>
                                const Icon(Icons.broken_image),
                            fadeInDuration: const Duration(milliseconds: 300),
                            fadeOutDuration: const Duration(milliseconds: 100),
                            fit: BoxFit.cover,
                            memCacheHeight: 200,
                            memCacheWidth: 200,
                            maxWidthDiskCache: 200,
                            maxHeightDiskCache: 200,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}


///
/// WITHOUT PAGINATION
///
/*
 class _GalleryMobile extends ViewModelWidget<GalleryViewModel> {
  const _GalleryMobile();

  @override
  Widget build(BuildContext context, GalleryViewModel vm) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Lazy Gallery',
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FavoritesView(
                    favoritesService: vm.fav,
                    useThumbAssets: vm.useThumbAssets,
                  ),
                ),
              );
              vm.notifyListeners();
            },
          )
        ],
      ),
      body: GridView.builder(
        controller: vm.scrollController,
        padding: const EdgeInsets.all(4),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
        ),
        itemCount: 48, //itemCount,
        itemBuilder: (context, index) {
          final thumb = vm.thumbPath(index);
          final full = vm.fullPath(index);
          return GestureDetector(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FullImageView(
                    id: index,
                    fullImagePath: full,
                    isAsset: vm.useThumbAssets,
                    favoritesService: vm.fav,
                  ),
                ),
              );
              vm.notifyListeners();
            },
            child: GridTile(
              footer: GridTileBar(
                backgroundColor: Colors.black26,
                leading: FutureBuilder<bool>(
                  future: vm.fav.contains(full),
                  builder: (context, snap) {
                    final isFav = snap.data ?? false;
                    return IconButton(
                      icon:
                          Icon(isFav ? Icons.favorite : Icons.favorite_border),
                      onPressed: () async {
                        if (isFav) {
                          await vm.fav.remove(full);
                        } else {
                          await vm.fav.add(full);
                        }
                        vm.notifyListeners();
                      },
                    );
                  },
                ),
                title: Text('${index + 1}'),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: vm.useThumbAssets
                    ? Image.asset(
                        thumb,
                        fit: BoxFit.cover,
                        // cacheHeight: 300, cacheWidth: 300,
                        cacheHeight: 100, cacheWidth: 100,
                        // Important: avoid letting asset decode at full resolution by using
                        // a low-res thumb and letting framework handle the rest.
                      )
                    : CachedNetworkImage(
                        imageUrl: full,
                        placeholder: (c, s) =>
                            Container(color: Colors.grey[300]),
                        errorWidget: (c, s, e) =>
                            const Icon(Icons.broken_image),
                        fit: BoxFit.cover,
                        // memCacheWidth: ,
                        // memCacheHeight: 100,
                        // memCacheWidth: 100,
                        maxWidthDiskCache: 100,
                        maxHeightDiskCache: 100,
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}

 */