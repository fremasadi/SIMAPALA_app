import 'dart:convert';

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

  Future<http.Response> postKasPembayaran({
    required String token,
    required String kasBulananId,
    required String nominal,
    String keterangan = '',
  }) async {
    return http.post(
      Uri.parse(AppUrl.kasPembayaran),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'kas_bulanan_id': int.parse(kasBulananId),
        'nominal': int.parse(nominal),
        'keterangan': keterangan,
      }),
    );
  }

  Future<http.Response> getKasOption({required String token}) async {
    final response = await http.get(
      Uri.parse(AppUrl.kasOption),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    return response;
  }

  Future<http.Response> getStatusPembayaran({
    required String token,
    required int id,
  }) async {
    return http.get(
      Uri.parse('${AppUrl.kasPembayaran}/$id/status'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
  }

  Future<http.Response> getListPembayaran({required String token}) async {
    return http.get(
      Uri.parse(AppUrl.kasPembayaran),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
  }
}
