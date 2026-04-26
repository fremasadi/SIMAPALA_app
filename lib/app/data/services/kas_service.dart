import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:simapala/app/data/model/kas_bulanan_model.dart';

import 'package:simapala/app/data/providers/kas_provider.dart';
import '../utils/api_guard.dart';

class KasService extends GetxService {
  final KasProvider _provider = Get.find();

  final RxList<KasBulanan> kasBulananList = <KasBulanan>[].obs;
  final RxList<KasBulananOption> kasOptionList = <KasBulananOption>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  /// ✅ TOTAL KAS
  final RxInt totalKas = 0.obs;
  final RxString totalKasFormatted = 'Rp 0'.obs;

  Future<void> fetchKasBulanan() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final token = await ApiGuard.getToken();

      final response = await _provider.getKasBulanan(token: token);
      ApiGuard.checkResponse(response);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final List data = body['data'];

        kasBulananList.assignAll(
          data.map((e) => KasBulanan.fromJson(e)).toList(),
        );
      } else {
        final body = jsonDecode(response.body);
        throw body['message'] ?? 'Gagal mengambil data kas';
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
      final token = await ApiGuard.getToken();
      final response = await _provider.getKasOption(token: token);
      ApiGuard.checkResponse(response);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final List data = body['data'];

        kasOptionList.assignAll(
          data.map((e) => KasBulananOption.fromJson(e)).toList(),
        );
      } else {
        throw jsonDecode(response.body)['message'] ?? 'Gagal mengambil opsi kas';
      }
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }

  /// ================= SUBMIT KAS PEMBAYARAN =================
  Future<Map<String, dynamic>> submitKasPembayaran({
    required String kasBulananId,
    required String nominal,
    String keterangan = '',
  }) async {
    final token = await ApiGuard.getToken();

    final response = await _provider.postKasPembayaran(
      token: token,
      kasBulananId: kasBulananId,
      nominal: nominal,
      keterangan: keterangan,
    );
    ApiGuard.checkResponse(response);

    final body = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (body['success'] == true) {
        return body;
      } else {
        throw body['message'] ?? 'Gagal membuat pembayaran';
      }
    } else {
      throw body['message'] ?? 'Gagal membuat pembayaran';
    }
  }

  /// ================= CEK STATUS PEMBAYARAN =================
  Future<Map<String, dynamic>> checkPaymentStatus(int id) async {
    final token = await ApiGuard.getToken();
    final response = await _provider.getStatusPembayaran(token: token, id: id);
    ApiGuard.checkResponse(response);

    final body = jsonDecode(response.body);
    if (body['success'] == true) {
      return body;
    } else {
      throw body['message'] ?? 'Gagal mengecek status';
    }
  }

  /// ================= TOTAL KAS =================
  Future<void> fetchTotalKas() async {
    try {
      final token = await ApiGuard.getToken();

      final response = await _provider.getTotalKas(token: token);
      ApiGuard.checkResponse(response);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        totalKas.value = int.parse(body['total_kas'].toString());
        totalKasFormatted.value = body['formatted'];
      } else {
        throw jsonDecode(response.body)['message'];
      }
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }
}
