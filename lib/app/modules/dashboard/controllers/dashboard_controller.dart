import 'package:get/get.dart';
import 'package:simapala/app/data/services/dashboard_service.dart';

class DashboardController extends GetxController {
  final DashboardService _dashboardService = Get.find();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboard();
  }

  // =========================
  // FETCH DATA
  // =========================
  Future<void> fetchDashboard() async {
    try {
      isLoading.value = true;
      await _dashboardService.fetchDashboard();
    } finally {
      isLoading.value = false;
    }
  }

  // =========================
  // GETTER (UNTUK UI)
  // =========================

  int get totalDipinjam =>
      _dashboardService.dashboard.value?.stats.dipinjam ?? 0;

  String get saldoKasFormatted =>
      _dashboardService.dashboard.value?.stats.saldoKasFormatted ?? 'Rp 0';

  List get aktivitas => _dashboardService.dashboard.value?.aktivitas ?? [];

  // =========================
  // GREETING
  // =========================
  String getGreting() {
    final hour = DateTime.now().hour;
    if (hour < 11) return "Pagi";
    if (hour < 15) return "Siang";
    if (hour < 18) return "Sore";
    return "Malam";
  }
}
