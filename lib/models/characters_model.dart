import 'package:marvelous/models/thumbnail_model.dart';

class CharacterModel {
  String? name;
  String? description;
  ThumbnailModel? thumbnail;
  CharacterDetailsModel? comics;
  CharacterDetailsModel? series;
  CharacterDetailsModel? stories;
  CharacterDetailsModel? events;

  CharacterModel({
    this.name,
    this.description,
    this.thumbnail,
    this.comics,
    this.series,
    this.stories,
    this.events,
  });

  CharacterModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    thumbnail = (json['thumbnail'] != null
        ? ThumbnailModel.fromJson(json['thumbnail'])
        : null)!;
    comics =
    (json['comics'] != null ? CharacterDetailsModel.fromJson(json['comics']) : null)!;
    series =
    (json['series'] != null ? CharacterDetailsModel.fromJson(json['series']) : null)!;
    stories =
    (json['stories'] != null ? CharacterDetailsModel.fromJson(json['stories']) : null)!;
    events =
    (json['events'] != null ? CharacterDetailsModel.fromJson(json['events']) : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['description'] = description;
    if (thumbnail != null) {
      data['thumbnail'] = thumbnail?.toJson();
    }
    if (comics != null) {
      data['comics'] = comics?.toJson();
    }
    if (series != null) {
      data['series'] = series?.toJson();
    }
    if (stories != null) {
      data['stories'] = stories?.toJson();
    }
    if (events != null) {
      data['events'] = events?.toJson();
    }
    return data;
  }
}



class CharacterDetailsModel {
  int? available;

  CharacterDetailsModel({this.available});

  CharacterDetailsModel.fromJson(Map<String, dynamic> json) {
    available = json['available'];
  }









  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['available'] = available;
    return data;
  }
}


