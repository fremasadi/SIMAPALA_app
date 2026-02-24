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

  // Data
  RxList<KasBulananOption> get kasBulananList => _kasService.kasOptionList;

  @override
  void onInit() {
    super.onInit();
    fetchKasBulananList();
  }

  Future<void> fetchKasBulananList() async {
    isLoadingOptions.value = true;
    await _kasService.fetchKasOption();
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

    if (selectedKasBulanan.value.isEmpty) {
      kasBulananError.value = 'Pilih kas bulanan';
      isValid = false;
    }

    if (selectedNominal.value.isEmpty) {
      nominalError.value = 'Nominal harus diisi';
      isValid = false;
    } else {
      double? nominal = double.tryParse(selectedNominal.value);
      if (nominal == null || nominal < 1000) {
        nominalError.value = 'Nominal minimal Rp 1.000';
        isValid = false;
      }
    }

    if (selectedMetode.value.isEmpty) {
      metodeError.value = 'Pilih metode pembayaran';
      isValid = false;
    }

    return isValid;
  }

  Future<void> submitKas() async {
    if (!validate()) return;

    isLoading.value = true;

    try {
      // TODO: Submit ke API
      await Future.delayed(Duration(seconds: 2)); // Simulasi

      Get.back(result: true);
      Get.snackbar(
        'Berhasil',
        'Kas berhasil ditambahkan',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menambahkan kas: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
