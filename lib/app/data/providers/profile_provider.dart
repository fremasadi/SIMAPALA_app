import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../utils/base_url.dart';

class ProfileProvider {
  Map<String, String> _headers(String token) => {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

  Future<http.Response> getProfileImage({required String token}) {
    return http.get(
      Uri.parse(AppUrl.profileImage),
      headers: _headers(token),
    );
  }

  Future<http.Response> uploadProfileImage({
    required String token,
    required File imageFile,
  }) async {
    final request =
        http.MultipartRequest('POST', Uri.parse(AppUrl.profileImage));
    request.headers.addAll(_headers(token));
    request.files.add(
      await http.MultipartFile.fromPath('image', imageFile.path),
    );
    final streamed = await request.send();
    return http.Response.fromStream(streamed);
  }

  Future<http.Response> changePassword({
    required String token,
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) {
    return http.post(
      Uri.parse(AppUrl.changePassword),
      headers: {
        ..._headers(token),
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'current_password': currentPassword,
        'new_password': newPassword,
        'new_password_confirmation': newPasswordConfirmation,
      }),
    );
  }
}
