part of favorites_view;

class _GalleryMobile extends ViewModelWidget<GalleryViewModel> {
  const _GalleryMobile();

  @override
  Widget build(BuildContext context, GalleryViewModel vm) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lazy Gallery'),
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
