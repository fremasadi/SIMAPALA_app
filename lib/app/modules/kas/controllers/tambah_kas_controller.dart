import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simapala/app/data/model/kas_bulanan_model.dart';
import 'package:simapala/app/data/services/kas_service.dart';

class TambahKasController extends GetxController {
  // Observables
  final selectedKasBulanan = ''.obs;
  final selectedMetode = ''.obs;
  final selectedNominal = ''.obs;
  final Rx<File?> selectedImage = Rx<File?>(null);
  final isLoading = false.obs;
  final isLoadingOptions = false.obs;

  // Error messages
  final kasBulananError = ''.obs;
  final nominalError = ''.obs;
  final metodeError = ''.obs;
  final buktiBayarError = ''.obs;

  final _kasService = Get.find<KasService>();

  // Data — local copy agar Obx tracking reliable
  final kasBulananList = <KasBulananOption>[].obs;

  @override
  void onReady() {
    super.onReady();
    fetchKasBulananList();
  }

  Future<void> fetchKasBulananList() async {
    isLoadingOptions.value = true;
    await _kasService.fetchKasOption();
    kasBulananList.assignAll(_kasService.kasOptionList);
    debugPrint('[TAMBAH KAS CTRL] kasBulananList.length = ${kasBulananList.length}');
    isLoadingOptions.value = false;
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 85,
    );

    if (image != null) {
      File file = File(image.path);
      int sizeInBytes = await file.length();
      int maxSize = 2 * 1024 * 1024; // 2MB

      if (sizeInBytes > maxSize) {
        buktiBayarError.value = 'Ukuran gambar maksimal 2MB';
        return;
      }

      selectedImage.value = file;
      buktiBayarError.value = '';
    }
  }

  void removeImage() {
    selectedImage.value = null;
  }

  bool validate() {
    bool isValid = true;

    debugPrint('[SUBMIT] validate => kasBulananId: ${selectedKasBulanan.value}, nominal: ${selectedNominal.value}, metode: ${selectedMetode.value}');

    if (selectedKasBulanan.value.isEmpty) {
      kasBulananError.value = 'Pilih kas bulanan';
      isValid = false;
    } else {
      kasBulananError.value = '';
    }

    if (selectedNominal.value.isEmpty) {
      nominalError.value = 'Nominal harus diisi';
      isValid = false;
    } else {
      // nominal format '10.000' → strip titik → '10000' baru parse
      final nominalClean = selectedNominal.value.replaceAll('.', '');
      final nominal = double.tryParse(nominalClean);
      debugPrint('[SUBMIT] nominalClean: $nominalClean, parsed: $nominal');
      if (nominal == null || nominal < 1000) {
        nominalError.value = 'Nominal minimal Rp 1.000';
        isValid = false;
      } else {
        nominalError.value = '';
      }
    }

    if (selectedMetode.value.isEmpty) {
      metodeError.value = 'Pilih metode pembayaran';
      isValid = false;
    } else {
      metodeError.value = '';
    }

    debugPrint('[SUBMIT] validate result: $isValid');
    return isValid;
  }

  Future<void> submitKas() async {
    debugPrint('[SUBMIT] submitKas called');

    if (!validate()) {
      debugPrint('[SUBMIT] validate FAILED, abort');
      return;
    }

    isLoading.value = true;

    try {
      final nominalStr = selectedNominal.value.replaceAll('.', '');
      debugPrint('[SUBMIT] sending => kasBulananId: ${selectedKasBulanan.value}, nominal: $nominalStr, metode: ${selectedMetode.value}, hasFoto: ${selectedImage.value != null}');

      await _kasService.submitKasPembayaran(
        kasBulananId: selectedKasBulanan.value,
        nominal: nominalStr,
        metode: selectedMetode.value,
        buktiFile: selectedImage.value,
      );

      debugPrint('[SUBMIT] SUCCESS');
      Get.back(result: true);
      Get.snackbar(
        'Berhasil',
        'Pembayaran kas berhasil dikirim, menunggu verifikasi',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      debugPrint('[SUBMIT] ERROR: $e');
      Get.snackbar(
        'Error',
        'Gagal mengirim pembayaran: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
