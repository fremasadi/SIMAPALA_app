import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user_model.dart';
import '../providers/auth_provider.dart';

class AuthService extends GetxService {
  final AuthProvider _provider = Get.find();

  final Rxn<UserModel> user = Rxn<UserModel>();
  final RxString token = ''.obs;

  static const _tokenKey = 'token';
  static const _userKey = 'user';

  bool get isLoggedIn => token.isNotEmpty;

  /// 🔐 LOGIN
  Future<void> login(String email, String password) async {
    final response = await _provider.login(
      email: email,
      password: password,
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      token.value = body['token'];
      user.value = UserModel.fromJson(body['user']);

      await _saveToLocal();
    } else {
      final body = jsonDecode(response.body);
      throw body['message'] ?? 'Login gagal';
    }
  }

  /// 💾 SIMPAN KE LOCAL
  Future<void> _saveToLocal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token.value);
    await prefs.setString(_userKey, jsonEncode(user.value!.toJson()));
  }

  /// 📥 LOAD DARI LOCAL
  Future<void> loadFromLocal() async {
    final prefs = await SharedPreferences.getInstance();

    final savedToken = prefs.getString(_tokenKey);
    final savedUser = prefs.getString(_userKey);

    if (savedToken != null && savedUser != null) {
      token.value = savedToken;
      user.value = UserModel.fromJson(jsonDecode(savedUser));
    }
  }

  /// 🚪 LOGOUT
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    token.value = '';
    user.value = null;
  }
}
