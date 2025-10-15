library my_player_view;

import 'package:flutter/material.dart';
import 'package:monirth_memories/ui/views/my_player/my_player_view_model.dart';
import 'package:monirth_memories/ui/widgets/custom_app_bar.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'dart:ui';
import 'package:monirth_memories/ui/widgets/progress_bar.dart';
import 'package:video_player/video_player.dart';
import 'package:pip_view/pip_view.dart';
part 'my_player_mobile.dart';

class MyPlayerView extends StatelessWidget {
  final String videoUrl;
  const MyPlayerView({super.key, required this.videoUrl});

  @override
  Widget build(BuildContext context) {
    return PIPView(builder: (context, isFloating) {
      return ViewModelBuilder<MyPlayerViewModel>.reactive(
        viewModelBuilder: () => MyPlayerViewModel(context, videoUrl),
        onViewModelReady: (MyPlayerViewModel model) async {
          await model.init();
        },
        builder: (context, model, child) {
          return ScreenTypeLayout.builder(
            mobile: (context) => const _MyPlayerMobile(),
          );
        },
      );
    });
  }
}
