import 'package:get/get.dart';
import 'package:simapala/app/modules/peminjaman/controllers/tambah_peminjaman_controller.dart';
import 'package:simapala/app/modules/profile/controllers/profile_controller.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.put(ProfileController());
    Get.put(TambahPeminjamanController());
  }
}
