import 'package:get/get.dart';
import 'package:simapala/app/modules/peminjaman/controllers/peminjaman_controller.dart';

import '../controllers/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.put(PeminjamanController());
  }
}
