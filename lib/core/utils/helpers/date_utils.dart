import 'package:timeago/timeago.dart' as timeago;

class DateUtilsHelper {
  static bool _isLocaleSet = false;

  static String timeAgoFromDate(DateTime createdAt) {
    if (!_isLocaleSet) {
      timeago.setLocaleMessages('ar', timeago.ArMessages());
      _isLocaleSet = true;
    }

    return timeago.format(createdAt, locale: 'ar');
  }
}
