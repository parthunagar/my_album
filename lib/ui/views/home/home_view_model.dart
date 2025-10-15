import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:monirth_memories/core/app.locator.dart';
import 'package:monirth_memories/core/route/router.gr.dart';
import 'package:monirth_memories/core/services/favorites_service.dart';
import 'package:stacked/stacked.dart';
import 'package:monirth_memories/core/logger.dart';
import 'package:logger/logger.dart';

class HomeViewModel extends BaseViewModel {
  BuildContext context;
  HomeViewModel(this.context);
  final Logger log = getLogger('HomeViewModel');
  
  init() {}

  final model = locator<PreferenceService>();
  String imgUrl =
      "https://raw.githubusercontent.com/parthunagar/my_album/images/assets/images/";
  String jsonUrl =
      "https://raw.githubusercontent.com/parthunagar/my_album/images/assets/";

  navigateTo(String json) {
    return AutoRouter.of(context)
        .push(GalleryRoute(jsonUrl: "$jsonUrl$json.json"));
  }

  navigateToVideo(String json) {
    return AutoRouter.of(context)
        .push(VideoListRoute(jsonUrl: "$jsonUrl$json.json"));
  }
}
