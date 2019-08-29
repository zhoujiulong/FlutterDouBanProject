// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MusicModel _$MusicModelFromJson(Map<String, dynamic> json) {
  return MusicModel(
      count: json['count'] as int,
      start: json['start'] as int,
      total: json['total'] as int,
      subjects: (json['subjects'] as List)
          ?.map((e) => e == null
              ? null
              : SubjectsModel.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      title: json['title'] as String);
}

Map<String, dynamic> _$MusicModelToJson(MusicModel instance) =>
    <String, dynamic>{
      'count': instance.count,
      'start': instance.start,
      'total': instance.total,
      'subjects': instance.subjects,
      'title': instance.title
    };

SubjectsModel _$SubjectsModelFromJson(Map<String, dynamic> json) {
  return SubjectsModel(
      rating: json['rating'] == null
          ? null
          : RatingModel.fromJson(json['rating'] as Map<String, dynamic>),
      genres: (json['genres'] as List)?.map((e) => e as String)?.toList(),
      title: json['title'] as String,
      casts: (json['casts'] as List)
          ?.map((e) =>
              e == null ? null : CastsModel.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      durations: (json['durations'] as List)?.map((e) => e as String)?.toList(),
      collectCount: json['collectCount'] as int,
      mainlandPubdate: json['mainlandPubdate'] as String,
      hasVideo: json['hasVideo'] as bool,
      originalTitle: json['originalTitle'] as String,
      subtype: json['subtype'] as String,
      directors: (json['directors'] as List)
          ?.map((e) => e == null
              ? null
              : DirectorsModel.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      pubdates: (json['pubdates'] as List)?.map((e) => e as String)?.toList(),
      year: json['year'] as String,
      images: json['images'] == null
          ? null
          : ImagesModel.fromJson(json['images'] as Map<String, dynamic>),
      alt: json['alt'] as String,
      id: json['id'] as String);
}

Map<String, dynamic> _$SubjectsModelToJson(SubjectsModel instance) =>
    <String, dynamic>{
      'rating': instance.rating,
      'genres': instance.genres,
      'title': instance.title,
      'casts': instance.casts,
      'durations': instance.durations,
      'collectCount': instance.collectCount,
      'mainlandPubdate': instance.mainlandPubdate,
      'hasVideo': instance.hasVideo,
      'originalTitle': instance.originalTitle,
      'subtype': instance.subtype,
      'directors': instance.directors,
      'pubdates': instance.pubdates,
      'year': instance.year,
      'images': instance.images,
      'alt': instance.alt,
      'id': instance.id
    };

RatingModel _$RatingModelFromJson(Map<String, dynamic> json) {
  return RatingModel(
      max: json['max'] as int,
      average: (json['average'] as num)?.toDouble(),
      details: (json['details'] as Map<String, dynamic>)?.map(
        (k, e) => MapEntry(k, (e as num)?.toDouble()),
      ),
      stars: json['stars'] as String,
      min: json['min'] as int);
}

Map<String, dynamic> _$RatingModelToJson(RatingModel instance) =>
    <String, dynamic>{
      'max': instance.max,
      'average': instance.average,
      'details': instance.details,
      'stars': instance.stars,
      'min': instance.min
    };

CastsModel _$CastsModelFromJson(Map<String, dynamic> json) {
  return CastsModel(
      avatars: json['avatars'] == null
          ? null
          : AvatarsModel.fromJson(json['avatars'] as Map<String, dynamic>),
      nameEn: json['nameEn'] as String,
      name: json['name'] as String,
      alt: json['alt'] as String,
      id: json['id'] as String);
}

Map<String, dynamic> _$CastsModelToJson(CastsModel instance) =>
    <String, dynamic>{
      'avatars': instance.avatars,
      'nameEn': instance.nameEn,
      'name': instance.name,
      'alt': instance.alt,
      'id': instance.id
    };

AvatarsModel _$AvatarsModelFromJson(Map<String, dynamic> json) {
  return AvatarsModel(
      small: json['small'] as String,
      large: json['large'] as String,
      medium: json['medium'] as String);
}

Map<String, dynamic> _$AvatarsModelToJson(AvatarsModel instance) =>
    <String, dynamic>{
      'small': instance.small,
      'large': instance.large,
      'medium': instance.medium
    };

DirectorsModel _$DirectorsModelFromJson(Map<String, dynamic> json) {
  return DirectorsModel(
      avatars: json['avatars'] == null
          ? null
          : AvatarsModel.fromJson(json['avatars'] as Map<String, dynamic>),
      nameEn: json['nameEn'] as String,
      name: json['name'] as String,
      alt: json['alt'] as String,
      id: json['id'] as String);
}

Map<String, dynamic> _$DirectorsModelToJson(DirectorsModel instance) =>
    <String, dynamic>{
      'avatars': instance.avatars,
      'nameEn': instance.nameEn,
      'name': instance.name,
      'alt': instance.alt,
      'id': instance.id
    };

ImagesModel _$ImagesModelFromJson(Map<String, dynamic> json) {
  return ImagesModel(
      small: json['small'] as String,
      large: json['large'] as String,
      medium: json['medium'] as String);
}

Map<String, dynamic> _$ImagesModelToJson(ImagesModel instance) =>
    <String, dynamic>{
      'small': instance.small,
      'large': instance.large,
      'medium': instance.medium
    };
