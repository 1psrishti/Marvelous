import 'package:marvelous/models/thumbnail_model.dart';

class ComicsModel {
  String? title;
  int? pageCount;
  ThumbnailModel? thumbnail;

  ComicsModel({
    this.title,
    this.pageCount,
    this.thumbnail,
  });

  ComicsModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    pageCount = json['pageCount'];
    thumbnail = (json['thumbnail'] != null
        ? ThumbnailModel.fromJson(json['thumbnail'])
        : null);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['pageCount'] = pageCount;
    data['thumbnail'] = thumbnail?.toJson();
    return data;
  }
}

