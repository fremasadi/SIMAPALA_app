import 'dart:convert';
import 'package:http/http.dart' as http;

import '../utils/base_url.dart';

class PeminjamanProvider {
  Future<http.Response> getPinjmana({required String token}) {
    return http.get(
      Uri.parse(AppUrl.pinjam),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
  }

  Future<http.Response> postPinjam({
    required String token,
    required String tanggalPinjam,
    required String tanggalKembali,
    required List<int> alatIds,
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
        'alat_ids': alatIds,
      }),
    );
  }
}
