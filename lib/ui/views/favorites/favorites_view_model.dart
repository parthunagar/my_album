import 'package:stacked/stacked.dart';
import 'package:monirth_memories/core/services/favorites_service.dart';

class FavoritesViewModel extends BaseViewModel {
  FavoritesViewModel();

  final PreferenceService fav = PreferenceService();
  late Future<List<String>> favsFuture;

  Future<void> init() async {
    favsFuture = fav.getAll();
  }
}
