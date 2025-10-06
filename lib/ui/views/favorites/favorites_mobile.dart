part of favorites_view;

class _FavoritesMobile extends ViewModelWidget<FavoritesViewModel> {
  const _FavoritesMobile();

  @override
  Widget build(BuildContext context, FavoritesViewModel vm) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: FutureBuilder<List<String>>(
        future: vm.favsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            // return const Center(child: CircularProgressIndicator());
            return const PhotoGrid(
              photos: ["", "", "", "", "", "", "", "", "", "", "", ""],
              useShimmer: true,
            );
          }

          final favorites = snapshot.data!;
          if (favorites.isEmpty) {
            return const Center(
              child: Text(
                'No favorites yet ❤️',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            );
          }
          // return MasonryGridView.builder(
          //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          //   gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
          //     crossAxisCount: 3,
          //   ),
          //   mainAxisSpacing: 6,
          //   crossAxisSpacing: 6,
          //   itemCount: favorites.length,
          //   itemBuilder: (context, i) {
          //     final photo = favorites[i];
          //     final thumbUrl = thumbnailUrl(photo);
          //     return ImageTile(i: i, photo: photo, thumbnail: thumbUrl);
          //   },
          // );
          return PhotoGrid(photos: favorites, usePhotoObject: false);
        },
      ),
    );
  }
}
