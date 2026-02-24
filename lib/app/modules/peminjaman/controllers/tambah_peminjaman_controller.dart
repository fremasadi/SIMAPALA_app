import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/model/alat_model.dart';
import '../../../data/services/alat_service.dart';
import '../../../data/services/pinjam_service.dart';

class TambahPeminjamanController extends GetxController {
  final AlatService _alatService = Get.find();
  final PeminjamanService peminjamanService = Get.find();

  // Observable variables
  var isLoading = false.obs;
  var alatList = <Alat>[].obs;
  var selectedAlatList = <Alat>[].obs;
  var tanggalPinjam = Rx<DateTime?>(null);
  var tanggalKembali = Rx<DateTime?>(null);

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

  // Toggle select/unselect alat (multi-select)
  void toggleSelectAlat(Alat alat) {
    if (alat.status.toLowerCase() != 'tersedia') {
      Get.snackbar(
        'Tidak Tersedia',
        'Alat ${alat.namaAlat} sedang dipinjam',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    final index = selectedAlatList.indexWhere((a) => a.id == alat.id);

    if (index >= 0) {
      selectedAlatList.removeAt(index);
    } else {
      selectedAlatList.add(alat);
    }
  }

  // Check if alat is selected
  bool isAlatSelected(Alat alat) {
    return selectedAlatList.any((a) => a.id == alat.id);
  }

  // Remove alat from selection
  void removeSelectedAlat(Alat alat) {
    selectedAlatList.removeWhere((a) => a.id == alat.id);
  }

  // Clear all selections
  void clearAllSelections() {
    selectedAlatList.clear();
  }

  // Set tanggal pinjam
  void setTanggalPinjam(DateTime date) {
    tanggalPinjam.value = date;
    if (tanggalKembali.value != null && tanggalKembali.value!.isBefore(date)) {
      tanggalKembali.value = null;
    }
  }

  // Set tanggal kembali
  void setTanggalKembali(DateTime date) {
    if (tanggalPinjam.value == null) {
      Get.snackbar(
        'Perhatian',
        'Pilih tanggal pinjam terlebih dahulu',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    if (date.isBefore(tanggalPinjam.value!)) {
      Get.snackbar(
        'Perhatian',
        'Tanggal kembali tidak boleh sebelum tanggal pinjam',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 2),
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

    final durasi =
        tanggalKembali.value!.difference(tanggalPinjam.value!).inDays + 1;
    return '$durasi hari';
  }

  // Get total biaya
  String getTotalBiaya() {
    if (selectedAlatList.isEmpty ||
        tanggalPinjam.value == null ||
        tanggalKembali.value == null) {
      return 'Rp 0';
    }

    final durasi =
        tanggalKembali.value!.difference(tanggalPinjam.value!).inDays + 1;
    int total = 0;

    for (var alat in selectedAlatList) {
      final hargaPerHari = int.parse(alat.hargaSewa.toString());
      total += durasi * hargaPerHari;
    }

    return 'Rp ${_formatCurrency(total)}';
  }

  // Format currency
  String _formatCurrency(int value) {
    return value.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  // Validate form
  bool isValid() {
    return selectedAlatList.isNotEmpty &&
        tanggalPinjam.value != null &&
        tanggalKembali.value != null;
  }

  // Submit peminjaman
  Future<void> submitPeminjaman() async {
    try {
      // Get alat IDs
      final alatIds = selectedAlatList.map((alat) => alat.id).toList();

      // Format dates
      final dateFormat = DateFormat('yyyy-MM-dd');
      final tanggalPinjamStr = dateFormat.format(tanggalPinjam.value!);
      final tanggalKembaliStr = dateFormat.format(tanggalKembali.value!);

      // Call service
      await peminjamanService.postPinjam(
        tanggalPinjam: tanggalPinjamStr,
        tanggalKembali: tanggalKembaliStr,
        alatIds: alatIds,
      );

      // Check if success
      if (peminjamanService.isSuccess.value == true) {
        Get.snackbar(
          '✓ Berhasil',
          'Peminjaman berhasil diajukan',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          duration: const Duration(seconds: 3),
          icon: const Icon(Icons.check_circle, color: Colors.white),
        );

        // ⏱️ TUNGGU 1 FRAME UI
        await Future.delayed(const Duration(milliseconds: 300));
        resetForm();
        fetchAlat();
      } else {
        // Show error message
        final errorMsg = peminjamanService.errorMessage.value.isNotEmpty
            ? peminjamanService.errorMessage.value
            : 'Gagal mengajukan peminjaman';

        Get.snackbar(
          'Gagal',
          errorMsg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          duration: const Duration(seconds: 3),
          icon: const Icon(Icons.error_outline, color: Colors.white),
        );
      }
    } catch (e) {
      // Show error message
      Get.snackbar(
        'Error',
        'Gagal mengajukan peminjaman: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.error_outline, color: Colors.white),
      );
    }
  }

  // Reset form
  void resetForm() {
    selectedAlatList.clear();
    tanggalPinjam.value = null;
    tanggalKembali.value = null;
  }

  // Get selected count text
  String getSelectedCountText() {
    final count = selectedAlatList.length;
    return count > 0 ? '$count alat dipilih' : 'Belum ada alat dipilih';
  }
}
