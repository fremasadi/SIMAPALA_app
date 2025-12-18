import 'package:http/http.dart' as http;
import '../utils/base_url.dart';

class AlatProvider {
  Future<http.Response> getAlat({required String token}) {
    return http.get(
      Uri.parse(AppUrl.alat),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
  }
}
