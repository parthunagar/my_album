library home_view;

import 'package:monirth_memories/ui/widgets/album_thumbnail_card.dart';
import 'package:monirth_memories/ui/widgets/custom_app_bar.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'home_view_model.dart';
// ignore: unnecessary_import
import 'package:flutter/foundation.dart'; // for compute()

part 'home_mobile.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(context),
      onViewModelReady: (model) => model.init(),
      builder: (context, model, child) {
        return ScreenTypeLayout.builder(
          mobile: (context) => _HomeMobile(),
        );
      },
    );
  }
}
