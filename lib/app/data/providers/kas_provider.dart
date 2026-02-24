import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../utils/base_url.dart';

class KasProvider {
  Future<http.Response> getKasBulanan({required String token}) {
    return http.get(
      Uri.parse(AppUrl.kas),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
  }

  Future<http.Response> getTotalKas({required String token}) {
    return http.get(
      Uri.parse(AppUrl.totalKas),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
  }

  Future<http.Response> getKasOption({required String token}) async {
    debugPrint('[KAS PROVIDER] GET ${AppUrl.kasOption}');
    debugPrint('[KAS PROVIDER] token: ${token.substring(0, token.length.clamp(0, 20))}...');
    final response = await http.get(
      Uri.parse(AppUrl.kasOption),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    debugPrint('[KAS PROVIDER] statusCode: ${response.statusCode}');
    debugPrint('[KAS PROVIDER] body: ${response.body}');
    return response;
  }
}
