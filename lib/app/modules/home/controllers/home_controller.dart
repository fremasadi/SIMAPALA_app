import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simapala/app/modules/kas/views/kas_view.dart';
import 'package:simapala/app/modules/profile/views/profile_view.dart';
import '../../dashboard/views/dashboard_view.dart';
import '../../peminjaman/views/peminjaman_view.dart';
import '../views/home_view.dart';

class HomeController extends GetxController {
  var currentIndex = 0.obs;

  final List<Widget> pages = [
    const DashboardView(),
    const PeminjamanView(),
    const KasView(),
    const ProfileView(),
  ];

  void changePage(int index) {
    currentIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    // Initialize any data needed on startup
  }

  @override
  void onReady() {
    super.onReady();
    // Called after the widget is rendered
  }

  @override
  void onClose() {
    super.onClose();
    // Clean up resources
  }
}
