abstract class DatabaseEntity {
  final String id;
  final String name;
  final String description;
  final Set<String> imageIds;
  final String createdByUser;
  final DateTime createdDate;

  const DatabaseEntity({
    required this.id,
    required this.name,
    required this.createdDate,
    required this.createdByUser,
    required this.description,
    this.imageIds = const {},
  });

  // This is used for skeletonizer
  DatabaseEntity.empty()
      : id = '',
        name = '',
        description = '',
        createdDate = DateTime.now(),
        createdByUser = '',
        imageIds = const {};

  get isNew => DateTime.now().difference(createdDate).inDays < 7;

  DatabaseEntity copyWith({
    String? id,
    String? name,
    String? description,
    Set<String>? imageIds,
    String? createdByUser,
    DateTime? createdDate,
  });
}
