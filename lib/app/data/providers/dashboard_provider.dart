import 'package:http/http.dart' as http;
import '../utils/base_url.dart';

class DashboardProvider {
  Future<http.Response> getDashboard({required String token}) {
    return http.get(
      Uri.parse(AppUrl.dashboard),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token', // ⚠️ PENTING: Bearer bukan Baarer
      },
    );
  }
}
