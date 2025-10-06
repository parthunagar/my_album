library favorites_view;

import 'package:flutter/material.dart';
import 'package:monirth_memories/ui/views/favorites/favorites_view_model.dart';
import 'package:monirth_memories/ui/widgets/image_tile.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';

part 'favorites_mobile.dart';

class FavoritesView extends StatelessWidget {
  // final FavoritesService favoritesService;
  // final bool useThumbAssets;
  const FavoritesView({
    super.key,
    // required this.favoritesService,
    // required this.useThumbAssets,
  });

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FavoritesViewModel>.reactive(
      viewModelBuilder: () => FavoritesViewModel(),
      onViewModelReady: (FavoritesViewModel model) async {
        await model.init();
      },
      builder: (context, model, child) {
        return ScreenTypeLayout.builder(
          mobile: (context) => _FavoritesMobile(),
          // desktop: (context) => _HomeDesktop(model),
          // tablet: (context) => _HomeTablet(model),
        );
      },
    );
  }
}
