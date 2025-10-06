import 'dart:convert';

class PhotoModel {
  final String title;
  final String url;

  PhotoModel({required this.title, required this.url});

  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    return PhotoModel(
      title: json['title'] ?? '',
      url: json['url'] ?? '',
    );
  }
}

List<PhotoModel> parsePhotos(String responseBody) {
  final List<dynamic> jsonList = json.decode(responseBody);
  return jsonList.map((e) => PhotoModel.fromJson(e)).toList();
}
