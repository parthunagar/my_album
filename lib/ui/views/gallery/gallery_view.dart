library favorites_view;

import 'package:flutter/material.dart';
import 'package:monirth_memories/ui/views/favorites/favorites_view.dart';
import 'package:monirth_memories/ui/views/gallery/gallery_view_model.dart';
import 'package:monirth_memories/ui/widgets/custom_app_bar.dart';
import 'package:monirth_memories/ui/widgets/image_tile.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';

part 'gallery_mobile.dart';

class GalleryView extends StatelessWidget {
  final String jsonUrl;
  const GalleryView({super.key, required this.jsonUrl});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<GalleryViewModel>.reactive(
      viewModelBuilder: () => GalleryViewModel(jsonUrl),
      onViewModelReady: (GalleryViewModel model) async {
        await model.init();
      },
      builder: (context, model, child) {
        return ScreenTypeLayout.builder(
          mobile: (context) => const _GalleryMobile(),
          // desktop: (context) => _HomeDesktop(model),
          // tablet: (context) => _HomeTablet(model),
        );
      },
    );
  }
}
