import 'dart:io';

import 'package:http/http.dart' as http;
import '../utils/base_url.dart';

class DanaMasukProvider {
  Map<String, String> _headers(String token) => {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

  Future<http.Response> getDanaMasuk({
    required String token,
    String? status,
    String? jenis,
    int? tahun,
    int? bulan,
  }) {
    final params = <String, String>{};
    if (status != null) params['status'] = status;
    if (jenis != null) params['jenis'] = jenis;
    if (tahun != null) params['tahun'] = tahun.toString();
    if (bulan != null) params['bulan'] = bulan.toString();

    final uri = Uri.parse(AppUrl.danaMasuk)
        .replace(queryParameters: params.isEmpty ? null : params);

    return http.get(uri, headers: _headers(token));
  }

  Future<http.Response> getSummary({
    required String token,
    int? tahun,
    int? bulan,
  }) {
    final params = <String, String>{};
    if (tahun != null) params['tahun'] = tahun.toString();
    if (bulan != null) params['bulan'] = bulan.toString();

    final uri = Uri.parse(AppUrl.danaMasukSummary)
        .replace(queryParameters: params.isEmpty ? null : params);

    return http.get(uri, headers: _headers(token));
  }

  Future<http.Response> postSumbangan({
    required String token,
    required String nominal,
    String? keterangan,
    File? buktiFile,
    String? tanggal,
  }) async {
    final request =
        http.MultipartRequest('POST', Uri.parse(AppUrl.danaMasuk));
    request.headers.addAll(_headers(token));
    request.fields['nominal'] = nominal;
    if (keterangan != null && keterangan.isNotEmpty) {
      request.fields['keterangan'] = keterangan;
    }
    if (tanggal != null) request.fields['tanggal'] = tanggal;
    if (buktiFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('bukti', buktiFile.path),
      );
    }
    final streamed = await request.send();
    return http.Response.fromStream(streamed);
  }
}
