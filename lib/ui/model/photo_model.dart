import 'dart:convert';

import 'package:flutter/foundation.dart';

class PhotoModel {
  final String title;
  final String url;
  final ValueNotifier<Uint8List?> thumbnailNotifier = ValueNotifier(null);

  PhotoModel({
    required this.title,
    required this.url,
    Uint8List? thumbnailPath,
  });

  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    return PhotoModel(
      title: json['title'] ?? '',
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'title': title, 'url': url};
}

List<PhotoModel> parsePhotos(String responseBody) {
  final List<dynamic> jsonList = json.decode(responseBody);
  return jsonList.map((e) => PhotoModel.fromJson(e)).toList();
}
