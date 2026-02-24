import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simapala/app/data/model/pinjaman_model.dart';

import '../providers/pinjam_provider.dart';

class PeminjamanService extends GetxService {
  final PeminjamanProvider _provider = Get.find();

  static const _tokenKey = 'token';
  final RxList<Pinjaman> pinjamanList = <Pinjaman>[].obs;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isSuccess = false.obs;

  Future<void> fetchPinjaman() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);

      if (token == null || token.isEmpty) {
        throw 'Token tidak ditemukan, silakan login ulang';
      }

      final response = await _provider.getPinjmana(token: token);

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

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);

      if (token == null || token.isEmpty) {
        throw 'Token tidak ditemukan, silakan login ulang';
      }

      final response = await _provider.postPinjam(
        token: token,
        tanggalPinjam: tanggalPinjam,
        tanggalKembali: tanggalKembali,
        alatIds: alatIds,
      );

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
