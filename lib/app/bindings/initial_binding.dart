import 'package:get/get.dart';
import 'package:simapala/app/data/providers/alat_provider.dart';
import 'package:simapala/app/data/providers/dashboard_provider.dart';
import 'package:simapala/app/data/providers/kas_provider.dart';
import 'package:simapala/app/data/providers/pinjam_provider.dart';
import 'package:simapala/app/data/services/alat_service.dart';
import 'package:simapala/app/data/services/dashboard_service.dart';
import 'package:simapala/app/data/services/kas_service.dart';
import 'package:simapala/app/data/services/pinjam_service.dart';
import '../data/providers/auth_provider.dart';
import '../data/services/auth_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthProvider>(AuthProvider(), permanent: true);
    Get.put<AuthService>(AuthService(), permanent: true);
    Get.put<AlatProvider>(AlatProvider(), permanent: true);
    Get.put<AlatService>(AlatService(), permanent: true);
    Get.put<PeminjamanProvider>(PeminjamanProvider(), permanent: true);
    Get.put<PeminjamanService>(PeminjamanService(), permanent: true);
    Get.put<KasProvider>(KasProvider(), permanent: true);
    Get.put<KasService>(KasService(), permanent: true);
    Get.put<DashboardProvider>(DashboardProvider(), permanent: true);
    Get.put<DashboardService>(DashboardService(), permanent: true);
  }
}
