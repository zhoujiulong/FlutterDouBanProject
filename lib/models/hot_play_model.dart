import 'package:json_annotation/json_annotation.dart';

part 'hot_play_model.g.dart';

@JsonSerializable()
class HotPlayModel {
  int count;
  int start;
  int total;
  List<SubjectsModel> subjects;
  String title;

  HotPlayModel({this.count, this.start, this.total, this.subjects, this.title});

  factory HotPlayModel.fromJson(Map<String, dynamic> json) => _$HotPlayModelFromJson(json);

  Map<String, dynamic> toJson() => _$HotPlayModelToJson(this);
}

@JsonSerializable()
class SubjectsModel {
  RatingModel rating;
  List<String> genres;
  String title;
  List<CastsModel> casts;
  List<String> durations;
  int collectCount;
  String mainlandPubdate;
  bool hasVideo;
  String originalTitle;
  String subtype;
  List<DirectorsModel> directors;
  List<String> pubdates;
  String year;
  ImagesModel images;
  String alt;
  String id;

  SubjectsModel(
      {this.rating,
      this.genres,
      this.title,
      this.casts,
      this.durations,
      this.collectCount,
      this.mainlandPubdate,
      this.hasVideo,
      this.originalTitle,
      this.subtype,
      this.directors,
      this.pubdates,
      this.year,
      this.images,
      this.alt,
      this.id});

  factory SubjectsModel.fromJson(Map<String, dynamic> json) => _$SubjectsModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubjectsModelToJson(this);
}

@JsonSerializable()
class RatingModel {
  int max;
  double average;
  Map<String, double> details;
  String stars;
  int min;

  RatingModel({this.max, this.average, this.details, this.stars, this.min});

  factory RatingModel.fromJson(Map<String, dynamic> json) => _$RatingModelFromJson(json);

  Map<String, dynamic> toJson() => _$RatingModelToJson(this);
}

@JsonSerializable()
class CastsModel {
  AvatarsModel avatars;
  String nameEn;
  String name;
  String alt;
  String id;

  CastsModel({this.avatars, this.nameEn, this.name, this.alt, this.id});

  factory CastsModel.fromJson(Map<String, dynamic> json) => _$CastsModelFromJson(json);

  Map<String, dynamic> toJson() => _$CastsModelToJson(this);
}

@JsonSerializable()
class AvatarsModel {
  String small;
  String large;
  String medium;

  AvatarsModel({this.small, this.large, this.medium});

  factory AvatarsModel.fromJson(Map<String, dynamic> json) => _$AvatarsModelFromJson(json);

  Map<String, dynamic> toJson() => _$AvatarsModelToJson(this);
}

@JsonSerializable()
class DirectorsModel {
  AvatarsModel avatars;
  String nameEn;
  String name;
  String alt;
  String id;

  DirectorsModel({this.avatars, this.nameEn, this.name, this.alt, this.id});

  factory DirectorsModel.fromJson(Map<String, dynamic> json) => _$DirectorsModelFromJson(json);

  Map<String, dynamic> toJson() => _$DirectorsModelToJson(this);
}

@JsonSerializable()
class ImagesModel {
  String small;
  String large;
  String medium;

  ImagesModel({this.small, this.large, this.medium});

  factory ImagesModel.fromJson(Map<String, dynamic> json) => _$ImagesModelFromJson(json);

  Map<String, dynamic> toJson() => _$ImagesModelToJson(this);
}
