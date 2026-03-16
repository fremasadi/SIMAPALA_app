import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simapala/app/data/model/dana_masuk_model.dart';
import 'package:simapala/app/data/services/dana_masuk_service.dart';

class DanamasukController extends GetxController {
  final _service = Get.find<DanaMasukService>();

  // State
  final isLoading = false.obs;
  final isSubmitting = false.obs;

  // Data (local copy for reliable Obx tracking)
  final danaMasukList = <DanaMasuk>[].obs;
  final summaryList = <DanaMasukSummaryItem>[].obs;
  final grandTotal = 0.0.obs;
  final totalFiltered = 0.0.obs;

  // Filters
  final selectedStatus = Rxn<String>();
  final selectedJenis = Rxn<String>();
  final selectedTahun = Rxn<int>();
  final selectedBulan = Rxn<int>();

  // Submit sumbangan form
  final nominalController = TextEditingController();
  final keteranganController = TextEditingController();
  final selectedImage = Rx<File?>(null);
  final nominalError = ''.obs;

  static const Map<String, String> jenisOptions = {
    'penyewaan': 'Penyewaan Alat',
    'denda_telat': 'Denda Telat',
    'denda_rusak': 'Denda Rusak',
    'kas': 'Kas',
    'sumbangan': 'Sumbangan',
    'dana_kampus': 'Dana Kampus',
  };

  static const List<int> tahunOptions = [2024, 2025, 2026, 2027];

  @override
  void onReady() {
    super.onReady();
    fetchAll();
  }

  @override
  void onClose() {
    nominalController.dispose();
    keteranganController.dispose();
    super.onClose();
  }

  Future<void> fetchAll() async {
    isLoading.value = true;
    await Future.wait([
      _service.fetchDanaMasuk(
        status: selectedStatus.value,
        jenis: selectedJenis.value,
        tahun: selectedTahun.value,
        bulan: selectedBulan.value,
      ),
      _service.fetchSummary(
        tahun: selectedTahun.value,
        bulan: selectedBulan.value,
      ),
    ]);
    danaMasukList.assignAll(_service.danaMasukList);
    summaryList.assignAll(_service.summaryList);
    grandTotal.value = _service.grandTotal.value;
    totalFiltered.value = _service.totalFiltered.value;
    isLoading.value = false;
  }

  void applyFilter() => fetchAll();

  void resetFilter() {
    selectedStatus.value = null;
    selectedJenis.value = null;
    selectedTahun.value = null;
    selectedBulan.value = null;
    fetchAll();
  }

  bool get hasActiveFilter =>
      selectedStatus.value != null ||
      selectedJenis.value != null ||
      selectedTahun.value != null ||
      selectedBulan.value != null;

  String formatRupiah(double nominal) {
    final str = nominal.toStringAsFixed(0);
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
      count++;
    }
    return 'Rp ${buffer.toString().split('').reversed.join('')}';
  }

  String _todayStr() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 85,
    );
    if (image != null) {
      final file = File(image.path);
      if (await file.length() > 2 * 1024 * 1024) {
        Get.snackbar('Error', 'Ukuran gambar maksimal 2MB',
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }
      selectedImage.value = file;
    }
  }

  void removeImage() => selectedImage.value = null;

  bool validateSubmit() {
    final raw = nominalController.text.trim();
    if (raw.isEmpty) {
      nominalError.value = 'Nominal harus diisi';
      return false;
    }
    final nominal =
        double.tryParse(raw.replaceAll('.', '').replaceAll(',', ''));
    if (nominal == null || nominal < 1000) {
      nominalError.value = 'Nominal minimal Rp 1.000';
      return false;
    }
    nominalError.value = '';
    return true;
  }

  Future<void> submitSumbangan() async {
    if (!validateSubmit()) return;
    isSubmitting.value = true;
    try {
      final nominal = nominalController.text
          .trim()
          .replaceAll('.', '')
          .replaceAll(',', '');

      await _service.submitSumbangan(
        nominal: nominal,
        keterangan: keteranganController.text.trim().isEmpty
            ? null
            : keteranganController.text.trim(),
        buktiFile: selectedImage.value,
        tanggal: _todayStr(),
      );

      nominalController.clear();
      keteranganController.clear();
      selectedImage.value = null;
      nominalError.value = '';

      Get.back();
      Get.snackbar(
        'Berhasil',
        'Sumbangan berhasil dikirim, menunggu verifikasi admin',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      fetchAll();
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengirim sumbangan: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isSubmitting.value = false;
    }
  }
}
