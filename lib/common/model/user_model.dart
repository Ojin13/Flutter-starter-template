import 'package:json_annotation/json_annotation.dart';

import 'database_entity.dart';

part 'user_model.g.dart';

// Run 'dart run build_runner build' to generate JsonSerializable
@JsonSerializable(explicitToJson: true, includeIfNull: false)
class UserModel extends DatabaseEntity {
  final int experiencePoints;
  final String email;
  final String bio;
  final String profilePicture;
  final String backgroundPicture;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  const UserModel({
    required super.id,
    required super.name,
    required super.createdByUser,
    required super.createdDate,
    required super.description,
    this.experiencePoints = 0,
    this.email = '',
    this.bio = '',
    this.profilePicture = '',
    this.backgroundPicture = '',
  });

  // This is used for skeletonizer
  UserModel.empty()
      : experiencePoints = 0,
        email = '',
        bio = '',
        profilePicture = '',
        backgroundPicture = '',
        super(
        id: '',
        name: '',
        imageIds: {},
        createdByUser: '',
        createdDate: DateTime.now(),
        description: '',
      );

  @override
  UserModel copyWith(
      {String? id,
        String? name,
        String? createdByUser,
        DateTime? createdDate,
        Set<String>? imageIds,
        String? reportAssessment,
        String? description,
        int? experiencePoints,
        String? email,
        String? bio,
        String? profilePicture,
        String? backgroundPicture}) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      createdByUser: createdByUser ?? this.createdByUser,
      description: description ?? this.description,
      createdDate: createdDate ?? this.createdDate,
      experiencePoints: experiencePoints ?? this.experiencePoints,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      profilePicture: profilePicture ?? this.profilePicture,
      backgroundPicture: backgroundPicture ?? this.backgroundPicture,
    );
  }
}
