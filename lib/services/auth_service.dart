import 'package:otobix_customer_app/services/shared_prefs_helper.dart';

class AuthService {
  /// Returns true only if all required auth fields exist and are non-empty.
  /// Required keys: token, userId, userRole
  static Future<bool> isLoggedIn() async {
    final token = await SharedPrefsHelper.getString(SharedPrefsHelper.tokenKey);
    final userId = await SharedPrefsHelper.getString(
      SharedPrefsHelper.userIdKey,
    );
    final userRole = await SharedPrefsHelper.getString(
      SharedPrefsHelper.userTypeKey,
    );

    bool isNullOrEmpty(String? v) => v == null || v.trim().isEmpty;

    if (isNullOrEmpty(token) ||
        isNullOrEmpty(userId) ||
        isNullOrEmpty(userRole)) {
      return false;
    }

    return true;
  }
}
