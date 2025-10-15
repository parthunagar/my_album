library splash_screen_view;

import 'package:monirth_memories/ui/widgets/custom_app_bar.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'splash_view_model.dart';
part 'splash_mobile.dart';

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
        );
      },
    );
  }
}
