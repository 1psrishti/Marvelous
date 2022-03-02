import 'package:marvelous/models/thumbnail_model.dart';

class SeriesModel {
  String? title;
  int? startYear;
  ThumbnailModel? thumbnail;

  SeriesModel({
    this.title,
    this.startYear,
    this.thumbnail,
  });

  SeriesModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    startYear = json['startYear'];
    thumbnail = json['thumbnail'] != null
        ? ThumbnailModel.fromJson(json['thumbnail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['startYear'] = startYear;
    if (thumbnail != null) {
      data['thumbnail'] = thumbnail?.toJson();
    }
    return data;
  }
}
