import 'package:get/get.dart';

class NotificationController extends GetxController {
  RxBool on = false.obs;
  RxBool onKas = false.obs;

  void toggle() => on.value = on.value ? false : true;

  void toggleKas() => onKas.value = onKas.value ? false : true;
}
