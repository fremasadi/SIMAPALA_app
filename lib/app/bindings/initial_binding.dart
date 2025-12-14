import 'package:get/get.dart';
import '../data/providers/auth_provider.dart';
import '../data/services/auth_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthProvider>(AuthProvider(), permanent: true);
    Get.put<AuthService>(AuthService(), permanent: true);
  }
}
