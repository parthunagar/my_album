library home_view;

import 'package:monirth_memories/ui/model/photo_model.dart';
import 'package:monirth_memories/ui/views/gallery/gallery_view.dart';
import 'package:monirth_memories/ui/widgets/album_thumbnail_card.dart';
import 'package:monirth_memories/ui/widgets/custom_app_bar.dart';
import 'package:monirth_memories/ui/widgets/shimmer_pkg.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'home_view_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart'; // for compute()
import 'package:cached_network_image/cached_network_image.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';

part 'home_mobile.dart';
part 'home_tablet.dart';
part 'home_desktop.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onViewModelReady: (model) {},
      builder: (context, model, child) {
        return ScreenTypeLayout.builder(
          mobile: (context) => _HomeMobile(model),
          desktop: (context) => _HomeDesktop(model),
          tablet: (context) => _HomeTablet(model),
        );
      },
    );
  }
}
