import 'package:stacked/stacked.dart';
import 'package:monirth_memories/core/services/favorites_service.dart';

class FavoritesViewModel extends BaseViewModel {
  final FavoritesService favoritesService;
  FavoritesViewModel(this.favoritesService);

  late Future<List<String>> favsFuture;
  final FavoritesService fav = FavoritesService();
  Future<void> init() async {
    favsFuture = favoritesService.getAll();
  }
}
