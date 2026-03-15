import 'package:get/get.dart';

import '../controllers/danamasuk_controller.dart';

class DanamasukBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DanamasukController>(
      () => DanamasukController(),
    );
  }
}
