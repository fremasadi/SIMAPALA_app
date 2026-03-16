import 'dart:convert';

import 'package:get/get.dart';

import '../model/alat_model.dart';
import '../providers/alat_provider.dart';
import '../utils/api_guard.dart';

class AlatService extends GetxService {
  final AlatProvider _provider = Get.find();

  final RxList<Alat> alatList = <Alat>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  Future<void> fetchAlat() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final token = await ApiGuard.getToken();
      final response = await _provider.getAlat(token: token);
      ApiGuard.checkResponse(response);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final List data = body['data'];
        alatList.assignAll(data.map((e) => Alat.fromJson(e)).toList());
      } else {
        throw jsonDecode(response.body)['message'] ?? 'Gagal mengambil data alat';
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
