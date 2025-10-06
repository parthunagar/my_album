part of home_view;

class _HomeMobile extends StatelessWidget {
  final HomeViewModel viewModel;
  const _HomeMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    // var w = MediaQuery.of(context).size.width;
    // var h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: CustomAppBar(title: 'Home'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AlbumThumbnailCard(
              title: "Pre-Wedding Album",
              imageUrl:
                  "https://raw.githubusercontent.com/parthunagar/my_album/main/assets/images/pre_wedding_album_pic/album/album1.jpg",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GalleryView(
                      jsonUrl:
                          "https://raw.githubusercontent.com/parthunagar/my_album/main/assets/pre_wedding_album.json",
                    ),
                  ),
                );
              },
            ),
            AlbumThumbnailCard(
              title: "Pre-Wedding Days",
              imageUrl:
                  "https://raw.githubusercontent.com/parthunagar/my_album/main/assets/images/pre_wedding_album_pic/days/day2.jpg",
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const GalleryView(
                              jsonUrl:
                                  "https://raw.githubusercontent.com/parthunagar/my_album/main/assets/pre_wedding_days.json",
                            )));
              },
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PaginatedGallery()));
                },
                child: const Text('Gallary Page')),
          ],
        ),
      ),
    );
  }
}

class PaginatedGallery extends StatefulWidget {
  const PaginatedGallery({super.key});

  @override
  State<PaginatedGallery> createState() => _PaginatedGalleryState();
}

class _PaginatedGalleryState extends State<PaginatedGallery> {
  List<PhotoModel> allPhotos = [];
  List<PhotoModel> visiblePhotos = [];
  int currentPage = 0;
  final int pageSize = 20;
  bool isLoading = false;
  bool allLoaded = false;
  final ScrollController _scrollController = ScrollController();

  Future<void> fetchPhotos() async {
    const url =
        "https://raw.githubusercontent.com/parthunagar/my_album/main/assets/pre_wedding_album.json";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final parsed = await compute(parsePhotos, response.body);
        setState(() {
          allPhotos = parsed;
        });
        loadMore(); // load first batch
      } else {
        debugPrint("Error: ${response.statusCode} || ${response.body}");
      }
    } catch (e) {
      debugPrint("Error fetching photos: $e");
    }
  }

  void loadMore() {
    if (isLoading || allLoaded) return;

    setState(() => isLoading = true);

    Future.delayed(const Duration(milliseconds: 300), () {
      final start = currentPage * pageSize;
      final end = start + pageSize;

      if (start >= allPhotos.length) {
        setState(() {
          allLoaded = true;
          isLoading = false;
        });
        return;
      }

      setState(() {
        visiblePhotos.addAll(allPhotos.sublist(
          start,
          end > allPhotos.length ? allPhotos.length : end,
        ));
        currentPage++;
        isLoading = false;
      });
    });
    print('visiblePhotos.length : ${visiblePhotos.length}');
  }

  @override
  void initState() {
    super.initState();
    fetchPhotos();

    // 🔁 Infinite scroll listener
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 300 &&
          !isLoading &&
          !allLoaded) {
        loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Smooth Lazy Gallery")),
      body: allPhotos.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                currentPage = 0;
                visiblePhotos.clear();
                allLoaded = false;
                await fetchPhotos();
              },
              child: GridView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(4),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                ),
                itemCount: visiblePhotos.length + (isLoading ? 3 : 0),
                itemBuilder: (context, index) {
                  if (index >= visiblePhotos.length) {
                    return _buildShimmer();
                  }

                  // final imageUrl = visiblePhotos[index];
                  final photo = visiblePhotos[index];
                  return GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (_) => FullImageView(url: imageUrl),
                      //   ),
                      // );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: photo.url,
                        placeholder: (c, s) => _buildShimmer(),
                        errorWidget: (c, s, e) =>
                            const Icon(Icons.broken_image),
                        fit: BoxFit.cover,
                        memCacheHeight: 300,
                        memCacheWidth: 300,
                        maxWidthDiskCache: 100,
                        maxHeightDiskCache: 100,
                      ),
                    ),
                  );
                },
              ),
            ),
    );
    // return Scaffold(
    //   appBar: AppBar(title: const Text("Paginated Gallery")),
    //   body: allPhotos.isEmpty
    //       ? const Center(child: CircularProgressIndicator())
    //       : NotificationListener<ScrollNotification>(
    //           onNotification: (scrollInfo) {
    //             if (!isLoading &&
    //                 scrollInfo.metrics.pixels ==
    //                     scrollInfo.metrics.maxScrollExtent) {
    //               loadMore();
    //             }
    //             return false;
    //           },
    //           child: GridView.builder(
    //             controller: _scrollController,
    //             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    //               crossAxisCount: 3,
    //               crossAxisSpacing: 4,
    //               mainAxisSpacing: 4,
    //             ),
    //             itemCount: visiblePhotos.length + (isLoading ? 1 : 0),
    //             itemBuilder: (context, index) {
    //               if (index >= visiblePhotos.length) {
    //                 return _buildShimmer();
    //               }
    //               final photo = visiblePhotos[index];
    //               return CachedNetworkImage(
    //                 imageUrl: photo['url'],
    //                 // placeholder: (ctx, _) => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
    //                 placeholder: (context, url) => _buildShimmer(),
    //                 errorWidget: (ctx, _, __) =>
    //                     const Icon(Icons.error, color: Colors.red),
    //                 fit: BoxFit.cover,
    //                 memCacheHeight: 300,
    //                 memCacheWidth: 300,
    //                 maxWidthDiskCache: 100,
    //                 maxHeightDiskCache: 100,
    //               );
    //             },
    //           ),
    //         ),
    // );
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


/*
class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  final FavoritesService fav = FavoritesService();
  final ScrollController _scrollController = ScrollController();

  // Example mode: useThumbAssets = true -> load from assets thumbs + asset full images
  // If you set to false, we construct example remote URLs and use cached_network_image
  // final bool useThumbAssets = true;
  final bool useThumbAssets = false;

  @override
  void initState() {
    super.initState();
    fav.load();
  }

  String thumbPath(int index) {
    // final id = (index + 1).toString().padLeft(4, '0');
    final id = (index + 1);
    if (id == 19) {
      return 'assets/images/pre_wedding_album_pic/album/album$id.JPG';
    }
    return 'assets/images/pre_wedding_album_pic/album/album$id.jpg';
  }

  String fullPath(int index) {
    // final id = (index + 1).toString().padLeft(4, '0');
    final id = (index + 1);

    if (useThumbAssets) {
      if (id == 19) {
        return 'assets/images/pre_wedding_album_pic/album/album$id.JPG';
      }
      return 'assets/images/pre_wedding_album_pic/album/album$id.jpg';
    } else {
      // Example remote full image url (replace with your CDN)
      // String url = "https://github.com/parthunagar/monirth_memories/blob/main/assets/images/pre_wedding_album_pic/album/album";
      String url =
          "https://raw.githubusercontent.com/parthunagar/monirth_memories/main/assets/images/pre_wedding_album_pic/album/album";

      if (id == 19) {
        // return '$url$id.JPG?raw=true';
        return '$url$id.JPG';
      }
      return '$url$id.jpg';
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    favoritesService: fav,
                    useThumbAssets: useThumbAssets,
                  ),
                ),
              );
              setState(() {});
            },
          )
        ],
      ),
      body: GridView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(4),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
        ),
        itemCount: 48, //itemCount,
        itemBuilder: (context, index) {
          final thumb = thumbPath(index);
          final full = fullPath(index);

          return GestureDetector(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FullImageView(
                    id: index,
                    fullImagePath: full,
                    isAsset: useThumbAssets,
                    favoritesService: fav,
                  ),
                ),
              );
              setState(() {}); // refresh favorites state in grid
            },
            child: GridTile(
              footer: GridTileBar(
                backgroundColor: Colors.black26,
                leading: FutureBuilder<bool>(
                  future: fav.contains(full),
                  builder: (context, snap) {
                    final isFav = snap.data ?? false;
                    return IconButton(
                      icon:
                          Icon(isFav ? Icons.favorite : Icons.favorite_border),
                      onPressed: () async {
                        if (isFav) {
                          await fav.remove(full);
                        } else {
                          await fav.add(full);
                        }
                        setState(() {});
                      },
                    );
                  },
                ),
                title: Text('${index + 1}'),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: useThumbAssets
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
                        memCacheHeight: 100,
                        memCacheWidth: 100,
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


/*
class FavoritesPage extends StatefulWidget {
  final FavoritesService favoritesService;
  final bool useThumbAssets;

  const FavoritesPage({
    super.key,
    required this.favoritesService,
    required this.useThumbAssets,
  });

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late Future<List<String>> _favsFuture;
  final FavoritesService fav = FavoritesService();
  @override
  void initState() {
    super.initState();
    // fav.load();
    _favsFuture = widget.favoritesService.getAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: FutureBuilder<List<String>>(
        future: _favsFuture,
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
            itemBuilder: (context, index) {
              final imgPath = favorites[index];
              return GestureDetector(
                onTap: () async {
                  // final favorites = await fav.getAll();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FullImageView(
                        fullImagePath: imgPath,
                        isAsset: widget.useThumbAssets,
                        id: index,
                        favoritesService: fav, // favorites,
                      ),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: widget.useThumbAssets
                      ? Image.asset(
                          imgPath,
                          fit: BoxFit.cover,
                          cacheWidth: 300,
                          cacheHeight: 300,
                        )
                      : Image.network(
                          imgPath,
                          fit: BoxFit.cover,
                        ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

 */

/*
class FullImagePage extends StatefulWidget {
  final int id;
  final String fullImagePath;
  final bool isAsset;
  final FavoritesService favoritesService;

  const FullImagePage({
    super.key,
    required this.id,
    required this.fullImagePath,
    required this.isAsset,
    required this.favoritesService,
  });

  @override
  State<FullImagePage> createState() => _FullImagePageState();
}

class _FullImagePageState extends State<FullImagePage> {
  Uint8List? _imageData;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      print('widget.isAsset : ${widget.isAsset}');
      if (widget.isAsset) {
        // Load asset bytes but avoid decoding into full-size Image widget memory until displayed
        print('widget.fullImagePath : ${widget.fullImagePath}');
        final bytes = await rootBundle.load(widget.fullImagePath);
        _imageData = bytes.buffer.asUint8List();
      } else {
        // If remote, let PhotoViewImage handle caching via CachedNetworkImage in other approaches.
        _imageData = null; // indicating network usage
      }
    } catch (e) {
      _imageData = null;
    }
    setState(() => _loading = false);
  }

  Future<void> _saveToGallery() async {
    final status = await Permission.storage.request();
    if (!status.isGranted) return;

    try {
      if (widget.isAsset && _imageData != null) {
        // final result = await ImageGallerySaver.saveImage(_imageData!, quality: 90, name: 'img_${widget.id}');
        _showSnack('Saved: \$result');
      } else {
        // For remote, provide URL to native saver which fetches it; here we fallback to letting user save via network image cache.
        _showSnack(
            'Saving remote images: not fully implemented. Consider downloading via provided URL.');
      }
    } catch (e) {
      _showSnack('Save failed: \$e');
    }
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image ${widget.id + 1}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _saveToGallery,
          ),
          FutureBuilder<bool>(
            future: widget.favoritesService.contains(widget.fullImagePath),
            builder: (context, snap) {
              final isFav = snap.data ?? false;
              return IconButton(
                icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
                onPressed: () async {
                  if (isFav) {
                    await widget.favoritesService.remove(widget.fullImagePath);
                  } else {
                    await widget.favoritesService.add(widget.fullImagePath);
                  }
                  setState(() {});
                },
              );
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: widget.isAsset && _imageData != null
                  ? PhotoView(
                      imageProvider: MemoryImage(_imageData!),
                      // imageProvider: AssetImage(
                      //   widget.fullImagePath,
                      //   bundle: rootBundle,
                      //   cacheWidth: 1080, // decode only up to screen width
                      // ),
                      enablePanAlways: true,
                      minScale: PhotoViewComputedScale.contained,
                      maxScale: PhotoViewComputedScale.covered * 3.0,
                    )
                  : PhotoView(
                      imageProvider: NetworkImage(widget.fullImagePath),
                      enablePanAlways: true,
                      minScale: PhotoViewComputedScale.contained,
                      maxScale: PhotoViewComputedScale.covered * 3.0,
                    ),
            ),
    );
  }
} */