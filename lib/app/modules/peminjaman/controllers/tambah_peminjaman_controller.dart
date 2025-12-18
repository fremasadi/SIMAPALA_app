import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/model/alat_model.dart';
import '../../../data/services/alat_service.dart';

class TambahPeminjamanController extends GetxController {
  final AlatService _alatService = Get.find();

  RxList<Alat> alatList = <Alat>[].obs;
  var selectedAlat = Rx<Alat?>(null);
  var tanggalPinjam = Rx<DateTime?>(null);
  var tanggalKembali = Rx<DateTime?>(null);

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAlat();
  }

  void fetchAlat() async {
    isLoading.value = true;
    await _alatService.fetchAlat();
    alatList.assignAll(_alatService.alatList);
    isLoading.value = false;
  }

  // Set selected alat
  void setSelectedAlat(Alat alat) {
    if (alat.status.toLowerCase() == 'tersedia') {
      selectedAlat.value = alat;
      // Reset tanggal saat ganti alat
      tanggalPinjam.value = null;
      tanggalKembali.value = null;
    } else {
      Get.snackbar(
        'Tidak Tersedia',
        'Alat ini sedang dipinjam',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  // Set tanggal pinjam
  void setTanggalPinjam(DateTime date) {
    tanggalPinjam.value = date;
    // Reset tanggal kembali jika lebih kecil dari tanggal pinjam
    if (tanggalKembali.value != null && tanggalKembali.value!.isBefore(date)) {
      tanggalKembali.value = null;
    }
  }

  // Set tanggal kembali
  void setTanggalKembali(DateTime date) {
    if (tanggalPinjam.value == null) {
      Get.snackbar(
        'Peringatan',
        'Pilih tanggal pinjam terlebih dahulu',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    if (date.isBefore(tanggalPinjam.value!)) {
      Get.snackbar(
        'Error',
        'Tanggal kembali tidak boleh sebelum tanggal pinjam',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    tanggalKembali.value = date;
  }

  // Get durasi peminjaman
  String getDurasi() {
    if (tanggalPinjam.value == null || tanggalKembali.value == null) {
      return '-';
    }

    final durasi = tanggalKembali.value!
        .difference(tanggalPinjam.value!)
        .inDays;
    return '$durasi hari';
  }

  // Validate form
  bool isValid() {
    return selectedAlat.value != null &&
        tanggalPinjam.value != null &&
        tanggalKembali.value != null;
  }

  // Submit peminjaman
  Future<void> submitPeminjaman() async {
    if (!isValid()) {
      Get.snackbar(
        'Error',
        'Mohon lengkapi semua data',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      // Show loading
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Simulasi API call - ganti dengan actual API call
      await Future.delayed(const Duration(seconds: 2));

      // Close loading
      Get.back();

      // Show success message
      Get.snackbar(
        'Berhasil',
        'Peminjaman berhasil diajukan',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      // Navigate back
      await Future.delayed(const Duration(seconds: 1));
      Get.back();
    } catch (e) {
      // Close loading if still showing
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      Get.snackbar(
        'Error',
        'Gagal mengajukan peminjaman: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Reset form
  void resetForm() {
    selectedAlat.value = null;
    tanggalPinjam.value = null;
    tanggalKembali.value = null;
  }
}
