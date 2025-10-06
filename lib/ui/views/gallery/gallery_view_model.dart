import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:monirth_memories/ui/model/photo_model.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;
import 'package:monirth_memories/core/services/favorites_service.dart';

class GalleryViewModel extends BaseViewModel {
  final String jsonUrl;
  GalleryViewModel(this.jsonUrl);
  final FavoritesService fav = FavoritesService();

  List<PhotoModel> allPhotos = [];
  List<PhotoModel> visiblePhotos = [];
  int currentPage = 0;
  final int pageSize = 20;
  bool isLoading = false;
  bool allLoaded = false;
  final ScrollController scrollController = ScrollController();
  Future<void> init() async {
    fetchPhotos();

    // 🔁 Infinite scroll listener
    scrollController.addListener(() {
      final maxScroll = scrollController.position.maxScrollExtent;
      final current = scrollController.position.pixels;
      if (current >= maxScroll - 300 && !isLoading && !allLoaded) {
        loadMore();
      }
    });
  }

  Future<void> fetchPhotos() async {
    try {
      final response = await http.get(Uri.parse(jsonUrl));
      if (response.statusCode == 200) {
        final parsed = await compute(parsePhotos, response.body);
        allPhotos = parsed;
        visiblePhotos.clear();
        currentPage = 0;
        allLoaded = false;
        notifyListeners();
        loadMore();
      } else {
        debugPrint("Error: ${response.statusCode} || ${response.body}");
      }
    } catch (e) {
      debugPrint("Error fetching photos: $e");
    }
  }

  void loadMore() {
    if (isLoading || allLoaded) return;

    isLoading = true;
    notifyListeners();

    // Future.delayed(const Duration(milliseconds: 300), () {
    final start = currentPage * pageSize;
    // final end = start + pageSize;
    final end = (start + pageSize).clamp(0, allPhotos.length);

    if (start >= allPhotos.length) {
      allLoaded = true;
      isLoading = false;
      notifyListeners();
      return;
    }

    // visiblePhotos.addAll(allPhotos.sublist(start,end > allPhotos.length ? allPhotos.length : end));
    visiblePhotos.addAll(allPhotos.sublist(start, end));
    currentPage++;
    isLoading = false;

    notifyListeners();
    // });
    print('visiblePhotos.length : ${visiblePhotos.length}');
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}


///
/// WITHOUT PAGINATION
///
/*
class GalleryViewModel extends BaseViewModel {
  final FavoritesService fav = FavoritesService();
  final ScrollController scrollController = ScrollController();

  // Example mode: useThumbAssets = true -> load from assets thumbs + asset full images
  // If you set to false, we construct example remote URLs and use cached_network_image
  final bool useThumbAssets = false;

  Future<void> init() async {
    fav.load();
  }

  String thumbPath(int index) {
    final id = (index + 1);
    // if (id == 19) {
    //   return 'assets/images/pre_wedding_album_pic/album/album$id.JPG';
    // }
    return 'assets/images/pre_wedding_album_pic/album/album$id.jpg';
  }

  String fullPath(int index) {
    final id = (index + 1);
    if (useThumbAssets) {
      return 'assets/images/pre_wedding_album_pic/album/album$id.jpg';
    } else {
      String url =
          "https://raw.githubusercontent.com/parthunagar/my_album/main/assets/images/pre_wedding_album_pic/album/album";

      // return id == 19 ? '$url$id.JPG' : '$url$id.jpg';
      return '$url$id.jpg';
    }
  }

  List<dynamic> photos = [];

  Future<void> fetchPhotos() async {
    final url = Uri.parse(
        "https://raw.githubusercontent.com/username/repo/main/photos.json");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Move JSON parsing to Isolate
      final parsed = await compute(parsePhotos, response.body);
      photos = parsed;
      notifyListeners();
    } else {
      throw Exception("Failed to load photos");
    }
  }

  List<dynamic> parsePhotos(String responseBody) {
    return json.decode(responseBody) as List<dynamic>;
  }
}

 */