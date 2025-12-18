import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/alat_model.dart';
import '../providers/alat_provider.dart';

class AlatService extends GetxService {
  final AlatProvider _provider = Get.find();

  final RxList<Alat> alatList = <Alat>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  static const _tokenKey = 'token';

  /// 📦 AMBIL DATA ALAT (PAKAI TOKEN LOCAL)
  Future<void> fetchAlat() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);

      if (token == null || token.isEmpty) {
        throw 'Token tidak ditemukan, silakan login ulang';
      }

      final response = await _provider.getAlat(token: token);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final List data = body['data'];

        alatList.assignAll(data.map((e) => Alat.fromJson(e)).toList());
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
}
