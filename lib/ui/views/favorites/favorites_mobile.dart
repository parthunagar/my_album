part of favorites_view;

class _FavoritesMobile extends ViewModelWidget<FavoritesViewModel> {
  const _FavoritesMobile();

  @override
  Widget build(BuildContext context, FavoritesViewModel vm) {
    return ParentView(
      title: 'Favorites',
      body: FutureBuilder<List<String>>(
        future: vm.favsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const PhotoGrid(
              photos: ["", "", "", "", "", "", "", "", "", "", "", ""],
              useShimmer: true,
            );
          }

          final favorites = snapshot.data!;
          if (favorites.isEmpty) {
            return const Center(child: Text('No favorites yet ❤️'));
          }
          return PhotoGrid(photos: favorites, usePhotoObject: false);
        },
      ),
    );
  }
}
