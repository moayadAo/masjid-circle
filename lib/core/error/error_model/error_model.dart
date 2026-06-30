import 'package:masjid/core/network/api/api_key.dart';

class ErrorModel {
  ErrorModel({required this.message});

  factory ErrorModel.fromJson(final Map<String, dynamic> json) {
    return ErrorModel(
      // message: json['data']['date'][0] ?? "no message",
      message: json[BodyParameters.ERRORMESSAGE] ?? "no message",
    );
  }
  String message;
  toJson() {
    return {BodyParameters.ERRORMESSAGE: message};
  }
}
