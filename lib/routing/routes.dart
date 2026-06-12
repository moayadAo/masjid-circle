class Routes {
  // Auth
  static const splash = '/';
  static const login = '/login';

  // Main Teacher
  static const generalRecitation = '/general-recitation';
  static const recitationForm = '/recitation-form';
  static const myCircles = '/my-circles';
  static const circleDetails = '/my-circles/:circleId';
  static const attendanceSession = '/attendance-session/:sessionId';

  // Assistant Teacher
  static const assistantHome = '/assistant-home';

  // Helpers
  static String circleDetailsPath(int circleId) => '/my-circles/$circleId';

  static String attendanceSessionPath(int sessionId) =>
      '/attendance-session/$sessionId';
}
