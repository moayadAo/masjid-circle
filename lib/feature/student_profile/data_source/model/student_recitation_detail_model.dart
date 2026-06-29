class RecitationTeacherModel {
  final int id;
  final String name;

  const RecitationTeacherModel({required this.id, required this.name});

  factory RecitationTeacherModel.fromJson(Map<String, dynamic> json) {
    return RecitationTeacherModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
    );
  }
}

class StudentRecitationDetailModel {
  final int id;
  final int cycleId;
  final int circleId;
  final int studentId;
  final int teacherId;
  final RecitationTeacherModel teacher;
  final String recitationType; // pages | surah | ayah_range
  final int? fromPage;
  final int? toPage;
  final int? surahId;
  final int? fromAyah;
  final int? toAyah;
  // final int? pagesCount;
  final String rating; // good | very_good | excellent
  final int? pointsAwarded;
  final String recitedAt;
  final String? notes;
  final String createdAt;

  const StudentRecitationDetailModel({
    required this.id,
    required this.cycleId,
    required this.circleId,
    required this.studentId,
    required this.teacherId,
    required this.teacher,
    required this.recitationType,
    this.fromPage,
    this.toPage,
    this.surahId,
    this.fromAyah,
    this.toAyah,
    // this.pagesCount,
    required this.rating,
    this.pointsAwarded,
    required this.recitedAt,
    this.notes,
    required this.createdAt,
  });

  bool get isPages => recitationType == 'pages';
  bool get isSurah => recitationType == 'surah';

  factory StudentRecitationDetailModel.fromJson(Map<String, dynamic> json) {
    return StudentRecitationDetailModel(
      id: json['id'] as int,
      cycleId: json['cycle_id'] as int,
      circleId: json['circle_id'] as int,
      studentId: json['student_id'] as int,
      teacherId: json['teacher_id'] as int,
      teacher: RecitationTeacherModel.fromJson(
        json['teacher'] as Map<String, dynamic>,
      ),
      recitationType: json['recitation_type'] as String? ?? 'pages',
      fromPage: json['from_page'] as int?,
      toPage: json['to_page'] as int?,
      surahId: json['surah_id'] as int?,
      fromAyah: json['from_ayah'] as int?,
      toAyah: json['to_ayah'] as int?,
      // pagesCount: json['pages_count'] as int?,
      rating: json['rating'] as String? ?? 'good',
      pointsAwarded: json['points_awarded'] as int?,
      recitedAt: json['recited_at'] as String? ?? '',
      notes: json['notes'] as String?,
      createdAt: json['created_at'] as String? ?? '',
    );
  }
}

class StudentPaginationModel {
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;
  final int pagesCount;

  const StudentPaginationModel({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
    required this.pagesCount,
  });

  bool get hasNextPage => currentPage < lastPage;

  factory StudentPaginationModel.fromJson(Map<String, dynamic> json) {
    return StudentPaginationModel(
      currentPage: json['current_page'] as int? ?? 1,
      perPage: json['per_page'] as int? ?? 15,
      total: json['total'] as int? ?? 0,
      lastPage: json['last_page'] as int? ?? 1,
      pagesCount: json['pages_count'] as int? ?? 1,
    );
  }
}

class StudentRecitationsPageModel {
  final List<StudentRecitationDetailModel> items;
  final StudentPaginationModel pagination;

  const StudentRecitationsPageModel({
    required this.items,
    required this.pagination,
  });

  factory StudentRecitationsPageModel.fromJson(Map<String, dynamic> json) {
    final list = (json['data'] as List<dynamic>? ?? [])
        .map(
          (e) =>
              StudentRecitationDetailModel.fromJson(e as Map<String, dynamic>),
        )
        .toList();

    final meta = json['meta'] as Map<String, dynamic>?;

    return StudentRecitationsPageModel(
      items: list,
      pagination: meta != null
          ? StudentPaginationModel.fromJson(meta)
          : const StudentPaginationModel(
              currentPage: 1,
              perPage: 15,
              total: 0,
              lastPage: 1,
              pagesCount: 1,
            ),
    );
  }
}
