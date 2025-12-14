import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../dashboard/views/dashboard_view.dart';
import '../../peminjaman/views/peminjaman_view.dart';
import '../views/home_view.dart';

class HomeController extends GetxController {
  var currentIndex = 0.obs;

  final List<Widget> pages = [
    const DashboardView(),
    const PeminjamanView(),
    const KasPage(),
    const ProfilePage(),
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