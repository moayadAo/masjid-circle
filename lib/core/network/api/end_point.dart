// import 'package:ezsouq/env/env.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
const String BASEURLApi = "${BASEURL}api/";
const String BASEURL = 'https://alzahraa-api.cronica-co.com/';

class EndPoint {
  static const String BASEURL = 'https://alzahraa-api.cronica-co.com/';

  /// ********************************            ********************************
  /// ******************************** Feature AUTH ********************************
  /// ********************************             *******************************
  static const String login = '${BASEURLApi}mobile/v1/auth/login';
  static const String me = '${BASEURLApi}mobile/v1/auth/me';
  static const String logout = '${BASEURLApi}mobile/v1/auth/logout';
}
