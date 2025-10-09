import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:monirth_memories/ui/model/photo_model.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;
import 'package:monirth_memories/core/services/favorites_service.dart';

class GalleryViewModel extends BaseViewModel {
  final String jsonUrl;
  GalleryViewModel(this.jsonUrl);
  final PreferenceService fav = PreferenceService();

  List<PhotoModel> allPhotos = [];
  List<PhotoModel> visiblePhotos = [];
  int currentPage = 0;
  final int pageSize = 20;
  bool isLoading = false;
  bool allLoaded = false;
  final ScrollController scrollController = ScrollController();
  Future<void> init() async {
    fetchPhotos();
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

    final start = currentPage * pageSize;
    final end = (start + pageSize).clamp(0, allPhotos.length);

    if (start >= allPhotos.length) {
      allLoaded = true;
      isLoading = false;
      notifyListeners();
      return;
    }

    visiblePhotos.addAll(allPhotos.sublist(start, end));
    currentPage++;
    isLoading = false;

    notifyListeners();
    debugPrint('visiblePhotos.length : ${visiblePhotos.length}');
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
