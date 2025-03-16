// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: json['id'] as String,
  name: json['name'] as String,
  createdByUser: json['createdByUser'] as String,
  createdDate: DateTime.parse(json['createdDate'] as String),
  description: json['description'] as String,
  experiencePoints: (json['experiencePoints'] as num?)?.toInt() ?? 0,
  email: json['email'] as String? ?? '',
  bio: json['bio'] as String? ?? '',
  profilePicture: json['profilePicture'] as String? ?? '',
  backgroundPicture: json['backgroundPicture'] as String? ?? '',
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'createdByUser': instance.createdByUser,
  'createdDate': instance.createdDate.toIso8601String(),
  'experiencePoints': instance.experiencePoints,
  'email': instance.email,
  'bio': instance.bio,
  'profilePicture': instance.profilePicture,
  'backgroundPicture': instance.backgroundPicture,
};
