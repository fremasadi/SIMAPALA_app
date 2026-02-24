import 'package:get/get.dart';
import 'package:simapala/app/data/model/kas_bulanan_model.dart';
import 'package:simapala/app/data/services/kas_service.dart';

class KasController extends GetxController {
  final KasService _kasService = Get.find();

  // Observable variables
  var isLoading = false.obs;
  var kasBulananList = <KasBulanan>[].obs;

  /// ✅ TOTAL KAS
  RxString totalKasFormatted = 'Rp 0'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchKas();
  }

  void fetchKas() async {
    isLoading.value = true;
    await _kasService.fetchKasBulanan();
    await _kasService.fetchTotalKas();

    kasBulananList.assignAll(_kasService.kasBulananList);
    totalKasFormatted.value = _kasService.totalKasFormatted.value;

    isLoading.value = false;
  }
}
