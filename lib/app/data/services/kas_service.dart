import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simapala/app/data/model/kas_bulanan_model.dart';

import 'package:simapala/app/data/providers/kas_provider.dart';

class KasService extends GetxService {
  final KasProvider _provider = Get.find();

  final RxList<KasBulanan> kasBulananList = <KasBulanan>[].obs;
  final RxList<KasBulananOption> kasOptionList = <KasBulananOption>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  /// ✅ TOTAL KAS
  final RxInt totalKas = 0.obs;
  final RxString totalKasFormatted = 'Rp 0'.obs;

  static const _tokenKey = 'token';

  Future<void> fetchKasBulanan() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);

      if (token == null || token.isEmpty) {
        throw 'Token tidak ditemukan, silakan login ulang';
      }

      final response = await _provider.getKasBulanan(token: token);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final List data = body['data'];

        kasBulananList.assignAll(
          data.map((e) => KasBulanan.fromJson(e)).toList(),
        );
      } else {
        final body = jsonDecode(response.body);

        throw body['message'] ?? 'Gagal mengambil data alat';
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// ================= KAS OPTION =================
  Future<void> fetchKasOption() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);
      debugPrint('[KAS SERVICE] token from prefs: ${token == null ? "NULL" : "ada (${token.length} chars)"}');

      if (token == null || token.isEmpty) {
        throw 'Token tidak ditemukan';
      }

      final response = await _provider.getKasOption(token: token);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        debugPrint('[KAS SERVICE] success key: ${body['success']}');
        final List data = body['data'];
        debugPrint('[KAS SERVICE] data.length: ${data.length}');

        kasOptionList.assignAll(
          data.map((e) => KasBulananOption.fromJson(e)).toList(),
        );
        debugPrint('[KAS SERVICE] kasOptionList.length after assign: ${kasOptionList.length}');
      } else {
        throw jsonDecode(response.body)['message'] ?? 'Gagal mengambil opsi kas';
      }
    } catch (e) {
      debugPrint('[KAS SERVICE] ERROR: $e');
      errorMessage.value = e.toString();
    }
  }

  /// ================= TOTAL KAS =================
  Future<void> fetchTotalKas() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);

      if (token == null || token.isEmpty) {
        throw 'Token tidak ditemukan';
      }

      final response = await _provider.getTotalKas(token: token);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        totalKas.value = body['total_kas'];
        totalKasFormatted.value = body['formatted'];
      } else {
        throw jsonDecode(response.body)['message'];
      }
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }
}
