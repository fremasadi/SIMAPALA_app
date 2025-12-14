import 'dart:convert';
import '../utils/base_url.dart';
import 'package:http/http.dart' as http;


class AuthProvider {
  Future<http.Response> login({
    required String email,
    required String password,
  }) {
    return http.post(
      Uri.parse(AppUrl.login),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );
  }

  Future<http.Response> logout(String token) {
    return http.post(
      Uri.parse(AppUrl.logout),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }
}
