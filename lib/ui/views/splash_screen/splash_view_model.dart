import 'package:monirth_memories/core/logger.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:logger/logger.dart';
class SplashScreenViewModel extends BaseViewModel {
  SplashScreenViewModel();
  
  final Logger log = getLogger('SplashScreenViewModel');

   init(BuildContext context){
    log.i('===> init call <===');
  }
}