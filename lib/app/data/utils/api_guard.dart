import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiGuard {
  static const _tokenKey = 'token';

  /// Ambil token dari SharedPreferences.
  /// Jika kosong/null, auto logout dan throw exception.
  static Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    if (token == null || token.isEmpty) {
      _doLogout();
      throw 'Sesi telah berakhir, silakan login ulang';
    }
    return token;
  }

  /// Periksa response HTTP.
  /// Jika 401 atau 403, auto logout.
  static void checkResponse(http.Response response) {
    if (response.statusCode == 401 || response.statusCode == 403) {
      _doLogout();
      throw 'Sesi telah berakhir, silakan login ulang';
    }
  }

  static void _doLogout() {
    SharedPreferences.getInstance().then((prefs) => prefs.clear());
    Get.offAllNamed('/login');
  }
}
