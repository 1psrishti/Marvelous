import 'package:marvelous/models/thumbnail_model.dart';

class EventsModel {
  String? title;
  String? description;
  ThumbnailModel? thumbnail;

  EventsModel({
    this.title,
    this.description,
    this.thumbnail,
  });

  EventsModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];

    thumbnail = json['thumbnail'] != null
        ? ThumbnailModel.fromJson(json['thumbnail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    if (thumbnail != null) {
      data['thumbnail'] = thumbnail?.toJson();
    }
    return data;
  }
}
