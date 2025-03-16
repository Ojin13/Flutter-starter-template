import 'package:json_annotation/json_annotation.dart';

part 'image_data_model.g.dart';

// Run 'dart run build_runner build' to generate file
@JsonSerializable(explicitToJson: true, includeIfNull: false)
class ImageDataModel {
  final String id;
  final String uploadedByUser;
  final DateTime uploadedDate;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final String? imageUrl;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final String? imageLocalPath;

  factory ImageDataModel.fromJson(Map<String, dynamic> json) =>
      _$ImageDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$ImageDataModelToJson(this);

  ImageDataModel({
    required this.id,
    required this.uploadedByUser,
    required this.uploadedDate,
    this.imageUrl,
    this.imageLocalPath,
  });

  ImageDataModel copyWith({
    String? id,
    String? uploadedByUser,
    DateTime? uploadedDate,
    String? imageLocalPath,
    String? imageUrl,
  }) {
    return ImageDataModel(
      id: id ?? this.id,
      uploadedByUser: uploadedByUser ?? this.uploadedByUser,
      uploadedDate: uploadedDate ?? this.uploadedDate,
      imageLocalPath: imageLocalPath ?? this.imageLocalPath,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
