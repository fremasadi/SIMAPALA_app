import 'package:get/get.dart';
import 'package:simapala/app/data/model/pinjaman_model.dart';

import '../../../data/services/pinjam_service.dart';

class PeminjamanController extends GetxController {
  final PeminjamanService peminjamanService = Get.find();

  // Observable variables
  var isLoading = false.obs;
  var pinjamanList = <Pinjaman>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPinjaman();
  }

  void fetchPinjaman() async {
    isLoading.value = true;
    await peminjamanService.fetchPinjaman();
    pinjamanList.assignAll(peminjamanService.pinjamanList);

    isLoading.value = false;
  }
}
