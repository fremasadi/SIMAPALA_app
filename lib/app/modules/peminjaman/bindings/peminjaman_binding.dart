import 'package:get/get.dart';

import 'package:simapala/app/modules/peminjaman/controllers/tambah_peminjaman_controller.dart';

import '../controllers/peminjaman_controller.dart';

class PeminjamanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TambahPeminjamanController>(
      () => TambahPeminjamanController(),
    );
    Get.lazyPut<PeminjamanController>(
      () => PeminjamanController(),
    );
  }
}
