class AuthResponseModel {
  final String token;
  final UserModel user;
  final List<String> roles;
  final List<String> permissions;
  final AbilitiesModel abilities;
  final FeaturesModel features;
  final ProfileModel profile;
  final ActiveCycleModel? activeCycle;

  const AuthResponseModel({
    required this.token,
    required this.user,
    required this.roles,
    required this.permissions,
    required this.abilities,
    required this.features,
    required this.profile,
    this.activeCycle,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return AuthResponseModel(
      token: data['token'] as String,
      user: UserModel.fromJson(data['user'] as Map<String, dynamic>),
      roles: List<String>.from(data['roles'] as List),
      permissions: List<String>.from(data['permissions'] as List),
      abilities: AbilitiesModel.fromJson(
        data['abilities'] as Map<String, dynamic>,
      ),
      features: FeaturesModel.fromJson(
        data['features'] as Map<String, dynamic>,
      ),
      profile: ProfileModel.fromJson(data['profile'] as Map<String, dynamic>),
      activeCycle: data['active_cycle'] != null
          ? ActiveCycleModel.fromJson(
              data['active_cycle'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class UserModel {
  final int id;
  final String name;
  final String username;
  final String? phone;
  final String status;
  final String? lastLoginAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.username,
    this.phone,
    required this.status,
    this.lastLoginAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      username: json['username'] as String,
      phone: json['phone'] as String?,
      status: json['status'] as String,
      lastLoginAt: json['last_login_at'] as String?,
    );
  }
}

class AbilitiesModel {
  final bool canAccessDashboard;
  final bool canAccessMobileApp;
  final bool canViewStudents;
  final bool canCreateStudents;
  final bool canUpdateStudents;
  final bool canDeleteStudents;
  final bool canTakeAttendance;
  final bool canUpdateAttendance;
  final bool canViewAttendance;
  final bool canCreateRecitation;
  final bool canViewRecitations;
  final bool canCreateJuzExam;
  final bool canViewReports;
  final bool canManageCycles;
  final bool canManageCircles;
  final bool canManageUsers;
  final bool canViewAuditLogs;

  const AbilitiesModel({
    required this.canAccessDashboard,
    required this.canAccessMobileApp,
    required this.canViewStudents,
    required this.canCreateStudents,
    required this.canUpdateStudents,
    required this.canDeleteStudents,
    required this.canTakeAttendance,
    required this.canUpdateAttendance,
    required this.canViewAttendance,
    required this.canCreateRecitation,
    required this.canViewRecitations,
    required this.canCreateJuzExam,
    required this.canViewReports,
    required this.canManageCycles,
    required this.canManageCircles,
    required this.canManageUsers,
    required this.canViewAuditLogs,
  });

  factory AbilitiesModel.fromJson(Map<String, dynamic> json) {
    return AbilitiesModel(
      canAccessDashboard: json['can_access_dashboard'] as bool,
      canAccessMobileApp: json['can_access_mobile_app'] as bool,
      canViewStudents: json['can_view_students'] as bool,
      canCreateStudents: json['can_create_students'] as bool,
      canUpdateStudents: json['can_update_students'] as bool,
      canDeleteStudents: json['can_delete_students'] as bool,
      canTakeAttendance: json['can_take_attendance'] as bool,
      canUpdateAttendance: json['can_update_attendance'] as bool,
      canViewAttendance: json['can_view_attendance'] as bool,
      canCreateRecitation: json['can_create_recitation'] as bool,
      canViewRecitations: json['can_view_recitations'] as bool,
      canCreateJuzExam: json['can_create_juz_exam'] as bool,
      canViewReports: json['can_view_reports'] as bool,
      canManageCycles: json['can_manage_cycles'] as bool,
      canManageCircles: json['can_manage_circles'] as bool,
      canManageUsers: json['can_manage_users'] as bool,
      canViewAuditLogs: json['can_view_audit_logs'] as bool,
    );
  }
}

class FeaturesModel {
  final bool dashboard;
  final bool mobileApp;
  final bool mobileMyCircles;
  final bool mobileAttendance;
  final bool mobileRecitations;
  final bool mobileStudentProfile;

  const FeaturesModel({
    required this.dashboard,
    required this.mobileApp,
    required this.mobileMyCircles,
    required this.mobileAttendance,
    required this.mobileRecitations,
    required this.mobileStudentProfile,
  });

  factory FeaturesModel.fromJson(Map<String, dynamic> json) {
    return FeaturesModel(
      dashboard: json['dashboard'] as bool,
      mobileApp: json['mobile_app'] as bool,
      mobileMyCircles: json['mobile_my_circles'] as bool,
      mobileAttendance: json['mobile_attendance'] as bool,
      mobileRecitations: json['mobile_recitations'] as bool,
      mobileStudentProfile: json['mobile_student_profile'] as bool,
    );
  }
}

class ProfileModel {
  final List<TeacherCircleModel> teacherCircles;
  final int circlesCount;

  const ProfileModel({
    required this.teacherCircles,
    required this.circlesCount,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      teacherCircles: (json['teacher_circles'] as List)
          .map((e) => TeacherCircleModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      circlesCount: json['circles_count'] as int,
    );
  }
}

class TeacherCircleModel {
  final int circleId;
  final String circleName;
  final String teacherRole;

  const TeacherCircleModel({
    required this.circleId,
    required this.circleName,
    required this.teacherRole,
  });

  factory TeacherCircleModel.fromJson(Map<String, dynamic> json) {
    return TeacherCircleModel(
      circleId: json['circle_id'] as int,
      circleName: json['circle_name'] as String,
      teacherRole: json['teacher_role'] as String,
    );
  }
}

class ActiveCycleModel {
  final int id;
  final String name;
  final String startsAt;
  final String endsAt;
  final String status;

  const ActiveCycleModel({
    required this.id,
    required this.name,
    required this.startsAt,
    required this.endsAt,
    required this.status,
  });

  factory ActiveCycleModel.fromJson(Map<String, dynamic> json) {
    return ActiveCycleModel(
      id: json['id'] as int,
      name: json['name'] as String,
      startsAt: json['starts_at'] as String,
      endsAt: json['ends_at'] as String,
      status: json['status'] as String,
    );
  }
}

// For /me endpoint — same shape minus token
class MeResponseModel {
  final UserModel user;
  final List<String> roles;
  final List<String> permissions;
  final AbilitiesModel abilities;
  final FeaturesModel features;
  final ProfileModel profile;
  final ActiveCycleModel? activeCycle;

  const MeResponseModel({
    required this.user,
    required this.roles,
    required this.permissions,
    required this.abilities,
    required this.features,
    required this.profile,
    this.activeCycle,
  });

  factory MeResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return MeResponseModel(
      user: UserModel.fromJson(data['user'] as Map<String, dynamic>),
      roles: List<String>.from(data['roles'] as List),
      permissions: List<String>.from(data['permissions'] as List),
      abilities: AbilitiesModel.fromJson(
        data['abilities'] as Map<String, dynamic>,
      ),
      features: FeaturesModel.fromJson(
        data['features'] as Map<String, dynamic>,
      ),
      profile: ProfileModel.fromJson(data['profile'] as Map<String, dynamic>),
      activeCycle: data['active_cycle'] != null
          ? ActiveCycleModel.fromJson(
              data['active_cycle'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}
