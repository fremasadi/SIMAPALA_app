import 'dart:convert';

import 'package:get/get.dart';
import 'package:simapala/app/data/model/pinjaman_model.dart';

import '../providers/pinjam_provider.dart';
import '../utils/api_guard.dart';

class PeminjamanService extends GetxService {
  final PeminjamanProvider _provider = Get.find();

  final RxList<Pinjaman> pinjamanList = <Pinjaman>[].obs;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isSuccess = false.obs;

  Future<void> fetchPinjaman() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final token = await ApiGuard.getToken();

      final response = await _provider.getPinjmana(token: token);
      ApiGuard.checkResponse(response);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final List data = body['data'];
        pinjamanList.assignAll(data.map((e) => Pinjaman.fromJson(e)).toList());
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

  /// 📤 AJUKAN PEMINJAMAN
  Future<void> postPinjam({
    required String tanggalPinjam,
    required String tanggalKembali,
    required List<int> alatIds,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      isSuccess.value = false;

      final token = await ApiGuard.getToken();

      final response = await _provider.postPinjam(
        token: token,
        tanggalPinjam: tanggalPinjam,
        tanggalKembali: tanggalKembali,
        alatIds: alatIds,
      );
      ApiGuard.checkResponse(response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        isSuccess.value = true;
      } else {
        final body = jsonDecode(response.body);
        throw body['message'] ?? 'Gagal mengajukan peminjaman';
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
