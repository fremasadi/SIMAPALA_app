import 'package:get/get.dart';
import 'package:simapala/app/data/providers/alat_provider.dart';
import 'package:simapala/app/data/services/alat_service.dart';
import '../data/providers/auth_provider.dart';
import '../data/services/auth_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthProvider>(AuthProvider(), permanent: true);
    Get.put<AuthService>(AuthService(), permanent: true);
    Get.put<AlatProvider>(AlatProvider(), permanent: true);
    Get.put<AlatService>(AlatService(), permanent: true);
  }
}
