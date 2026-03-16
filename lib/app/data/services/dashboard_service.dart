import 'dart:convert';
import 'package:get/get.dart';

import '../model/dashboard_model.dart';
import '../providers/dashboard_provider.dart';
import '../utils/api_guard.dart';

class DashboardService extends GetxService {
  final DashboardProvider _provider = Get.find();

  final Rxn<DashboardModel> dashboard = Rxn<DashboardModel>();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  Future<void> fetchDashboard() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final token = await ApiGuard.getToken();

      final response = await _provider.getDashboard(token: token);
      ApiGuard.checkResponse(response);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        dashboard.value = DashboardModel.fromJson(body);
      } else {
        final body = jsonDecode(response.body);
        throw body['message'] ?? 'Gagal mengambil data dashboard';
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
