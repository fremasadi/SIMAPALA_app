import 'dart:convert';
import 'package:http/http.dart' as http;

import '../utils/base_url.dart';

class PeminjamanProvider {
  Future<http.Response> getPinjam({required String token}) {
    return http.get(
      Uri.parse(AppUrl.pinjam),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
  }

  Future<http.Response> getPinjamDetail({required String token, required int id}) {
    return http.get(
      Uri.parse('${AppUrl.pinjam}/$id'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
  }

  Future<http.Response> postPinjam({
    required String token,
    required String tanggalPinjam,
    required String tanggalKembali,
    required List<Map<String, dynamic>> items,
  }) {
    return http.post(
      Uri.parse(AppUrl.pinjam),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'tanggal_pinjam': tanggalPinjam,
        'tanggal_kembali': tanggalKembali,
        'items': items,
      }),
    );
  }
}
