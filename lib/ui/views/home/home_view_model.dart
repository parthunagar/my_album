// import 'dart:typed_data';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:monirth_memories/core/logger.dart';
import 'package:logger/logger.dart';

class HomeViewModel extends BaseViewModel {
  BuildContext context;
  HomeViewModel(this.context);

  bool showProgressBar = false;
  final Logger log = getLogger('HomeViewModel');

  List notificationModelList = [];

  init() {}
}
