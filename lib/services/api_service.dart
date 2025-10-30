import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // GET method
  static Future<http.Response> get({
    required String endpoint,
    Map<String, String>? headers,
  }) async {
    final url = Uri.parse(endpoint);
    // debugPrint("GET: $url");

    final defaultHeaders = {"Content-Type": "application/json", ...?headers};

    return await http.get(url, headers: defaultHeaders);
  }

  // POST method
  static Future<http.Response> post({
    required String endpoint,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) async {
    final url = Uri.parse(endpoint);
    // debugPrint("POST: $url");

    final defaultHeaders = {"Content-Type": "application/json", ...?headers};

    return await http.post(
      url,
      headers: defaultHeaders,
      body: jsonEncode(body),
    );
  }

  // PUT method
  static Future<http.Response> put({
    required String endpoint,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) async {
    final url = Uri.parse(endpoint);
    // debugPrint("PUT: $url");

    final defaultHeaders = {"Content-Type": "application/json", ...?headers};

    return await http.put(url, headers: defaultHeaders, body: jsonEncode(body));
  }

}
