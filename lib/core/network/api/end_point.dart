// import 'package:ezsouq/env/env.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

class EndPoint {
  static String BASEURLApi = "api/";
  static String customerAPI = "${BASEURLApi}customer/";
  //static String BASEURL = Env.baseUrl;
  //static String BASEURL = 'https://test.backend.sellit-app.com/';
  static String BASEURL = 'https://backend.sellit-app.com/';
  static String serverClientId = "Env.clientIdRelease";

  ///********************************            ********************************
  ///******************************** Notifications ********************************
  ///********************************             *******************************
  static String updateFcmToken = "${BASEURLApi}customer/update/fcm-token";

  ///********************************            ********************************
  ///******************************** Feature one ********************************
  ///********************************             *******************************

  static String forImages = "${EndPoint.BASEURL}storage/";
  static String forVideos = "${EndPoint.BASEURL}uploads/videos/";

  /// ********************************            ********************************
  /// ******************************** Feature AUTH ********************************
  /// ********************************             *******************************
}
