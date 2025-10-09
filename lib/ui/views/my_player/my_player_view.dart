library my_player_view;

import 'package:flutter/material.dart';
import 'package:monirth_memories/ui/views/video_list/video_list_view_model.dart';
import 'package:monirth_memories/ui/widgets/custom_app_bar.dart';
import 'package:monirth_memories/ui/widgets/video_grid.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
part 'my_player_mobile.dart';

class VideoListView extends StatelessWidget {
  final String jsonUrl;
  const VideoListView(this.jsonUrl, {super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<VideoListViewModel>.reactive(
      viewModelBuilder: () => VideoListViewModel(jsonUrl),
      onViewModelReady: (VideoListViewModel model) async {
        await model.init();
      },
      builder: (context, model, child) {
        return ScreenTypeLayout.builder(
          mobile: (context) => const _VideoListMobile(),
          // desktop: (context) => _HomeDesktop(model),
          // tablet: (context) => _HomeTablet(model),
        );
      },
    );
  }
}
