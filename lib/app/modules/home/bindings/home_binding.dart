import 'package:get/get.dart';
import 'package:simapala/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:simapala/app/modules/kas/controllers/kas_controller.dart';
import 'package:simapala/app/modules/kas/controllers/tambah_kas_controller.dart';
import 'package:simapala/app/modules/peminjaman/controllers/peminjaman_controller.dart';
import 'package:simapala/app/modules/peminjaman/controllers/tambah_peminjaman_controller.dart';
import 'package:simapala/app/modules/profile/controllers/edit_password_controller.dart';
import 'package:simapala/app/modules/profile/controllers/notification_controller.dart';
import 'package:simapala/app/modules/profile/controllers/profile_controller.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController());
    Get.put(ProfileController());
    Get.put(TambahPeminjamanController());
    Get.put(PeminjamanController());
    Get.put(DashboardController());
    Get.put(EditPasswordController());
    Get.put(NotificationController());
    Get.put(KasController());
    Get.put(DashboardController());
    Get.put(TambahKasController());
  }
}
