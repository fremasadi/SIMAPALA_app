import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import '../model/dana_masuk_model.dart';
import '../providers/dana_masuk_provider.dart';
import '../utils/api_guard.dart';

class DanaMasukService extends GetxService {
  final DanaMasukProvider _provider = Get.find();

  final RxList<DanaMasuk> danaMasukList = <DanaMasuk>[].obs;
  final RxList<DanaMasukSummaryItem> summaryList =
      <DanaMasukSummaryItem>[].obs;
  final RxDouble grandTotal = 0.0.obs;
  final RxDouble totalFiltered = 0.0.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  Future<void> fetchDanaMasuk({
    String? status,
    String? jenis,
    int? tahun,
    int? bulan,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final token = await ApiGuard.getToken();

      final response = await _provider.getDanaMasuk(
        token: token,
        status: status,
        jenis: jenis,
        tahun: tahun,
        bulan: bulan,
      );
      ApiGuard.checkResponse(response);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final List data = body['data'];
        danaMasukList
            .assignAll(data.map((e) => DanaMasuk.fromJson(e)).toList());
        totalFiltered.value = (body['total'] as num).toDouble();
      } else {
        throw jsonDecode(response.body)['message'] ?? 'Gagal mengambil data';
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchSummary({int? tahun, int? bulan}) async {
    try {
      final token = await ApiGuard.getToken();

      final response = await _provider.getSummary(
        token: token,
        tahun: tahun,
        bulan: bulan,
      );
      ApiGuard.checkResponse(response);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final List data = body['data'];
        summaryList.assignAll(
            data.map((e) => DanaMasukSummaryItem.fromJson(e)).toList());
        grandTotal.value = (body['grand_total'] as num).toDouble();
      } else {
        throw jsonDecode(response.body)['message'] ?? 'Gagal mengambil summary';
      }
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }

  Future<void> submitSumbangan({
    required String nominal,
    String? keterangan,
    File? buktiFile,
    String? tanggal,
  }) async {
    final token = await ApiGuard.getToken();

    final response = await _provider.postSumbangan(
      token: token,
      nominal: nominal,
      keterangan: keterangan,
      buktiFile: buktiFile,
      tanggal: tanggal,
    );
    ApiGuard.checkResponse(response);

    final body = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (body['success'] != true) {
        throw body['message'] ?? 'Gagal mengirim sumbangan';
      }
    } else {
      throw body['message'] ?? 'Gagal mengirim sumbangan';
    }
  }
}
