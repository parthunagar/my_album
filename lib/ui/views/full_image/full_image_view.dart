library full_image_view;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:monirth_memories/core/app.locator.dart';
import 'package:monirth_memories/core/services/favorites_service.dart';
import 'package:monirth_memories/ui/model/photo_model.dart';
import 'package:monirth_memories/ui/views/full_image/full_image_view_model.dart';
import 'package:monirth_memories/ui/widgets/custom_app_bar.dart';
import 'package:monirth_memories/ui/widgets/progress_bar.dart';
import 'package:monirth_memories/ui/widgets/shimmer_effect.dart';
import 'package:photo_view/photo_view.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';

part 'full_image_mobile.dart';

class FullImageView extends StatelessWidget {
  final List<PhotoModel> photos;
  final int initialIndex;
  const FullImageView({super.key, required this.photos, this.initialIndex = 0});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FullImageViewModel>.reactive(
      viewModelBuilder: () => FullImageViewModel(
        context,
        photos: photos,
        initialIndex: initialIndex,
      ),
      onViewModelReady: (FullImageViewModel model) async {
        await model.init();
      },
      builder: (context, model, child) {
        return ScreenTypeLayout.builder(
          mobile: (context) => _FullImageMobile(viewModel: model),
        );
      },
    );
  }
}
