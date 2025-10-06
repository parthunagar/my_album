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
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const GalleryView()));
              },
              child: const Text('Gallary Page')),
          ElevatedButton(
              onPressed: () {
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => GalleryPage()));
              },
              child: const Text('Gallary Page')),
        ],
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