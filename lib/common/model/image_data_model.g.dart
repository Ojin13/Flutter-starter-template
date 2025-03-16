// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************


ImageDataModel _$ImageDataModelFromJson(Map<String, dynamic> json) => ImageDataModel(
  id: json['id'] as String,
  uploadedByUser: json['uploadedByUser'] as String,
  uploadedDate: DateTime.parse(json['uploadedDate'] as String),
);

Map<String, dynamic> _$ImageDataModelToJson(ImageDataModel instance) => <String, dynamic>{
  'id': instance.id,
  'uploadedByUser': instance.uploadedByUser,
  'uploadedDate': instance.uploadedDate.toIso8601String(),
};
