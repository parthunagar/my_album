part of favorites_view;

class _FavoritesMobile extends ViewModelWidget<FavoritesViewModel> {
  final FavoritesService favoritesService;
  final bool useThumbAssets;

  const _FavoritesMobile({
    required this.favoritesService,
    required this.useThumbAssets,
  });

  @override
  Widget build(BuildContext context, FavoritesViewModel vm) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: FutureBuilder<List<String>>(
        future: vm.favsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final favorites = snapshot.data!;
          if (favorites.isEmpty) {
            return const Center(child: Text('No favorites yet.'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(4),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: favorites.length,
            itemBuilder: (context, i) {
              final imgPath = favorites[i];
              return GestureDetector(
                onTap: () async {
                  // final favorites = await fav.getAll();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FullImageView(
                        fullImagePath: imgPath,
                        isAsset: useThumbAssets,
                        id: i,
                        favoritesService: vm.fav, // favorites,
                      ),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: useThumbAssets
                      ? Image.asset(imgPath,
                          fit: BoxFit.cover, cacheWidth: 300, cacheHeight: 300)
                      : Image.network(imgPath, fit: BoxFit.cover),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
