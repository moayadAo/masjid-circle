class CircleModel {
  final int id;
  final int mosqueId;
  final int cycleId;
  final int? categoryId;
  final String name;
  final String status;
  final String? notes;
  final CircleCategoryModel? category;
  final CircleCycleModel? cycle;
  // final int enrolledCount;
  final String createdAt;

  const CircleModel({
    required this.id,
    required this.mosqueId,
    required this.cycleId,
    this.categoryId,
    required this.name,
    required this.status,
    this.notes,
    this.category,
    this.cycle,
    // required this.enrolledCount,
    required this.createdAt,
  });

  factory CircleModel.fromJson(Map<String, dynamic> json) {
    return CircleModel(
      id: json['id'] as int,
      mosqueId: json['mosque_id'] as int,
      cycleId: json['cycle_id'] as int,
      categoryId: json['category_id'] as int?,
      name: json['name'] as String,
      status: json['status'] as String,
      notes: json['notes'] as String?,
      category: json['category'] != null
          ? CircleCategoryModel.fromJson(
              json['category'] as Map<String, dynamic>,
            )
          : null,
      cycle: json['cycle'] != null
          ? CircleCycleModel.fromJson(json['cycle'] as Map<String, dynamic>)
          : null,
      // enrolledCount: json['enrolled_count'] as int,
      createdAt: json['created_at'] as String,
    );
  }
}

class CircleCategoryModel {
  final int id;
  final String name;

  const CircleCategoryModel({required this.id, required this.name});

  factory CircleCategoryModel.fromJson(Map<String, dynamic> json) =>
      CircleCategoryModel(id: json['id'] as int, name: json['name'] as String);
}

class CircleCycleModel {
  final int id;
  final String name;

  const CircleCycleModel({required this.id, required this.name});

  factory CircleCycleModel.fromJson(Map<String, dynamic> json) =>
      CircleCycleModel(id: json['id'] as int, name: json['name'] as String);
}
