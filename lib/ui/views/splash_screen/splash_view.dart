library splash_screen_view;

import 'package:auto_route/auto_route.dart';
import 'package:flame_splash_screen/flame_splash_screen.dart';
import 'package:monirth_memories/ui/gallary_app_demo/core/utils/app_string.dart';
import 'package:monirth_memories/ui/widgets/custom_app_bar.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'splash_view_model.dart';
part 'splash_mobile.dart';
part 'splash_tablet.dart';
part 'splash_desktop.dart';

class SplashScreenView extends StatelessWidget {
  const SplashScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SplashScreenViewModel>.reactive(
      viewModelBuilder: () => SplashScreenViewModel(),
      onViewModelReady: (model) => model.init(context),
      builder: (context, model, child) {
        return ScreenTypeLayout.builder(
          mobile: (context) => _SplashScreenMobile(model),
          desktop: (context) => _SplashScreenDesktop(model),
          tablet: (context) => _SplashScreenTablet(model),
        );
      },
    );
  }
}
