class ThumbnailModel {
  String? path;
  String? extension;

  ThumbnailModel({this.path, this.extension});

  ThumbnailModel.fromJson(Map<String, dynamic> json) {
    path = json['path'];
    extension = json['extension'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['path'] = path;
    data['extension'] = extension;
    return data;
  }
}