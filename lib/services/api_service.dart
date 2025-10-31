import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:otobix_customer_app/services/shared_prefs_helper.dart';

typedef UnauthorizedHandler = Future<void> Function();

class ApiService {
  /// Optional: set this once (e.g., in main/init) to handle 401s globally.
  /// Example:
  /// ApiService.configure(onUnauthorized: () async {
  ///   await SharedPrefsHelper.clear();
  ///   Get.offAll(() => LoginPage());
  /// });
  static UnauthorizedHandler? _onUnauthorized;

  static void configure({UnauthorizedHandler? onUnauthorized}) {
    _onUnauthorized = onUnauthorized;
  }

  // ---- public HTTP methods ----

  static Future<http.Response> get({
    required String endpoint,
    Map<String, String>? headers,
  }) async {
    final url = Uri.parse(endpoint);
    final h = await _headers(headers);
    return _send(() => http.get(url, headers: h));
  }

  static Future<http.Response> post({
    required String endpoint,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final url = Uri.parse(endpoint);
    final h = await _headers(headers);
    return _send(
      () => http.post(url, headers: h, body: jsonEncode(body ?? {})),
    );
  }

  static Future<http.Response> put({
    required String endpoint,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final url = Uri.parse(endpoint);
    final h = await _headers(headers);
    return _send(() => http.put(url, headers: h, body: jsonEncode(body ?? {})));
  }

  // ---- internals ----

  static Future<Map<String, String>> _headers([
    Map<String, String>? headers,
  ]) async {
    final token = await SharedPrefsHelper.getString(SharedPrefsHelper.tokenKey);
    return {
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      ...?headers,
    };
  }

  /// Single place to handle auth failures. If the server returns 401 with a code
  /// like TOKEN_MISSING / TOKEN_INVALID / TOKEN_EXPIRED / USER_NOT_FOUND,
  /// we call the configured handler so you can clear storage and redirect.
  static Future<http.Response> _send(
    Future<http.Response> Function() request,
  ) async {
    final res = await request();

    if (res.statusCode == 401) {
      try {
        final dynamic body = jsonDecode(res.body);
        final code = (body is Map<String, dynamic>)
            ? body['code'] as String?
            : null;

        if (code == 'TOKEN_MISSING' ||
            code == 'TOKEN_INVALID' ||
            code == 'TOKEN_EXPIRED' ||
            code == 'USER_NOT_FOUND') {
          // Let the app decide what to do (clear prefs, route to login, etc.)
          if (_onUnauthorized != null) {
            await _onUnauthorized!.call();
          }
        }
      } catch (_) {
        // ignore JSON parse errors and still treat as unauthorized
        if (_onUnauthorized != null) {
          await _onUnauthorized!.call();
        }
      }
    }

    return res;
  }
}
