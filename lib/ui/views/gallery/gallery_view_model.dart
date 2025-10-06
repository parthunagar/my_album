import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;
import 'package:monirth_memories/core/services/favorites_service.dart';

class GalleryViewModel extends BaseViewModel {
  final FavoritesService fav = FavoritesService();
  final ScrollController scrollController = ScrollController();

  // Example mode: useThumbAssets = true -> load from assets thumbs + asset full images
  // If you set to false, we construct example remote URLs and use cached_network_image
  // final bool useThumbAssets = true;
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
