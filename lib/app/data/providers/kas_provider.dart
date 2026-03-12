import 'dart:convert';
import 'dart:io';

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
    required String metode,
    File? buktiFile,
    String keterangan = '',
  }) async {
    if (buktiFile != null) {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(AppUrl.kasPembayaran),
      );
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      request.fields['kas_bulanan_id'] = kasBulananId;
      request.fields['nominal'] = nominal;
      request.fields['metode'] = metode;
      request.fields['keterangan'] = keterangan;
      request.files.add(
        await http.MultipartFile.fromPath('bukti_bayar', buktiFile.path),
      );
      final streamed = await request.send();
      return http.Response.fromStream(streamed);
    } else {
      return http.post(
        Uri.parse(AppUrl.kasPembayaran),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'kas_bulanan_id': kasBulananId,
          'nominal': nominal,
          'metode': metode,
          'bukti_bayar': '',
          'keterangan': keterangan,
        }),
      );
    }
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
