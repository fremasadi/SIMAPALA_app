import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simapala/app/modules/danamasuk/views/danamasuk_view.dart';
import 'package:simapala/app/modules/kas/views/kas_view.dart';
import 'package:simapala/app/modules/profile/views/profile_view.dart';
import '../../dashboard/views/dashboard_view.dart';
import '../../peminjaman/views/peminjaman_view.dart';

class HomeController extends GetxController {
  var currentIndex = 0.obs;

  final List<Widget> pages = [
    const DashboardView(),
    PeminjamanView(),
    const KasView(),
    const DanamasukView(),
    const ProfileView(),
  ];

  void changePage(int index) {
    currentIndex.value = index;
  }
}
