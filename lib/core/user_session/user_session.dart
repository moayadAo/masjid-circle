import 'dart:developer';

import 'package:masjid/core/di/service_locator.dart';
import 'package:masjid/core/network/api/end_point.dart';
import 'package:masjid/core/storage/hive_boxes.dart';
import 'package:masjid/core/storage/hive_helper.dart';
import 'package:masjid/core/storage/hive_key.dart';

class UserSession {
  static String? _name;
  static String? _email;
  static int? _userId;
  static String? _phone;
  static String? _avatarUrl;
  static String? _firstName;
  static String? _lastName;
  static String? _address;
  static String? _city;

  static final HiveHelper _hive = getIt<HiveHelper>();

  static Future<void> init() async {
    _name = await _hive.getData(HiveBoxes.appBox, HiveKey.userName);
    _email = await _hive.getData(HiveBoxes.appBox, HiveKey.email);
    _userId = await _hive.getData(HiveBoxes.appBox, HiveKey.userId);
    _phone = await _hive.getData(HiveBoxes.appBox, HiveKey.phone);
    _avatarUrl = await _hive.getData(HiveBoxes.appBox, HiveKey.avatar);
    _firstName = await _hive.getData(HiveBoxes.appBox, HiveKey.firstName);
    _lastName = await _hive.getData(HiveBoxes.appBox, HiveKey.lastName);
    _address = await _hive.getData(HiveBoxes.appBox, HiveKey.address);
    _city = await _hive.getData(HiveBoxes.appBox, HiveKey.city);
  }

  static Future<void> setUser({
    required String userName,
    required int userId,
    required String userEmail,
    required String firstName,
    required String lastName,
    String? address,
    String? city,
    String? phone,
    String? avatarUrl,
  }) async {
    _name = userName;
    _email = userEmail;
    _userId = userId;
    _phone = phone;
    // _avatarUrl = avatarUrl != null ? '${EndPoint.forImages}${avatarUrl}' : null;
    _address = address;
    _city = city;
    _firstName = firstName;
    _lastName = lastName;

    await _hive.saveData(HiveBoxes.appBox, HiveKey.userName, userName);
    await _hive.saveData(HiveBoxes.appBox, HiveKey.firstName, firstName);
    await _hive.saveData(HiveBoxes.appBox, HiveKey.lastName, lastName);
    await _hive.saveData(HiveBoxes.appBox, HiveKey.email, userEmail);
    await _hive.saveData(HiveBoxes.appBox, HiveKey.userId, userId);

    if (address != null) {
      await _hive.saveData(HiveBoxes.appBox, HiveKey.address, address);
    }

    if (city != null) {
      await _hive.saveData(HiveBoxes.appBox, HiveKey.city, city);
    }

    if (phone != null) {
      await _hive.saveData(HiveBoxes.appBox, HiveKey.phone, phone);
    }

    if (avatarUrl != null) {
      log('avatar url saved: ${_avatarUrl}');
      await _hive.saveData(HiveBoxes.appBox, HiveKey.avatar, _avatarUrl);
    }
  }

  static Future<void> updateUser({
    String? userName,
    int? userId,
    String? userEmail,
    String? firstName,
    String? lastName,
    String? address,
    String? city,
    String? phone,
    String? avatarUrl,
  }) async {
    if (userName != null) {
      _name = userName;
      _hive.saveData(HiveBoxes.appBox, HiveKey.userName, userName);
    }
    if (userEmail != null) {
      _email = userEmail;
      _hive.saveData(HiveBoxes.appBox, HiveKey.email, userEmail);
    }
    if (userId != null) {
      _userId = userId;
      _hive.saveData(HiveBoxes.appBox, HiveKey.userId, userId);
    }
    if (phone != null) {
      _phone = phone;
      _hive.saveData(HiveBoxes.appBox, HiveKey.phone, phone);
    }
    if (avatarUrl != null) {
      // _avatarUrl = '${EndPoint.forImages}${avatarUrl}';
      log('avatar url updated: ${_avatarUrl}');
      _hive.saveData(HiveBoxes.appBox, HiveKey.avatar, _avatarUrl);
    }
    if (firstName != null) {
      _firstName = firstName;
      _hive.saveData(HiveBoxes.appBox, HiveKey.firstName, firstName);
    }
    if (lastName != null) {
      _lastName = lastName;
      _hive.saveData(HiveBoxes.appBox, HiveKey.lastName, lastName);
    }
    if (address != null) {
      _address = address;
      _hive.saveData(HiveBoxes.appBox, HiveKey.address, address);
    }
    if (city != null) {
      _city = city;
      _hive.saveData(HiveBoxes.appBox, HiveKey.city, city);
    }
  }

  /// getters
  static String? get name => '$_firstName $_lastName';
  static String? get firstName => _firstName;
  static String? get lastName => _lastName;
  static String? get address => _address;
  static String? get city => _city;
  static String? get email => _email;
  static int? get userId => _userId;
  static String? get phone => _phone;
  static String? get avatar => _avatarUrl;

  /// check login
  static bool get isLoggedIn => _userId != null;

  static Future<void> clear() async {
    _name = null;
    _email = null;
    _userId = null;
    _phone = null;
    _avatarUrl = null;
    _firstName = null;
    _lastName = null;
    _address = null;
    _city = null;
    await _hive.deleteData(HiveBoxes.appBox, HiveKey.userName);
    await _hive.deleteData(HiveBoxes.appBox, HiveKey.firstName);
    await _hive.deleteData(HiveBoxes.appBox, HiveKey.lastName);
    await _hive.deleteData(HiveBoxes.appBox, HiveKey.address);
    await _hive.deleteData(HiveBoxes.appBox, HiveKey.city);
    await _hive.deleteData(HiveBoxes.appBox, HiveKey.email);
    await _hive.deleteData(HiveBoxes.appBox, HiveKey.userId);
    await _hive.deleteData(HiveBoxes.appBox, HiveKey.phone);
    await _hive.deleteData(HiveBoxes.appBox, HiveKey.avatar);
  }
}
