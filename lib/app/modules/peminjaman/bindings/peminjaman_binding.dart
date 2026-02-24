import 'package:get/get.dart';

import 'package:simapala/app/modules/peminjaman/controllers/tambah_peminjaman_controller.dart';

import '../controllers/peminjaman_controller.dart';

class PeminjamanBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(TambahPeminjamanController());
    Get.put(PeminjamanController());
  }
}
