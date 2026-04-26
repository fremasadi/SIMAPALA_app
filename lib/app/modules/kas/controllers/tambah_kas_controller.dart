import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simapala/app/data/model/kas_bulanan_model.dart';
import 'package:simapala/app/data/services/kas_service.dart';
import 'package:url_launcher/url_launcher.dart';

class TambahKasController extends GetxController {
  // Observables
  final selectedKasBulanan = ''.obs;
  final selectedNominal = ''.obs;
  final isLoading = false.obs;
  final isLoadingOptions = false.obs;

  // Error messages
  final kasBulananError = ''.obs;
  final nominalError = ''.obs;

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
    isLoadingOptions.value = false;
  }

  bool validate() {
    bool isValid = true;

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
      final nominalClean = selectedNominal.value.replaceAll('.', '');
      final nominal = double.tryParse(nominalClean);
      if (nominal == null || nominal < 1000) {
        nominalError.value = 'Nominal minimal Rp 1.000';
        isValid = false;
      } else {
        nominalError.value = '';
      }
    }

    return isValid;
  }

  Future<void> submitKas() async {
    if (!validate()) return;

    isLoading.value = true;

    try {
      final nominalStr = selectedNominal.value.replaceAll('.', '');
      
      final result = await _kasService.submitKasPembayaran(
        kasBulananId: selectedKasBulanan.value,
        nominal: nominalStr,
        keterangan: "Pembayaran Kas",
      );

      final paymentUrl = result['payment_url'];
      if (paymentUrl != null) {
        final uri = Uri.parse(paymentUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          
          Get.back(result: true);
          Get.snackbar(
            'Berhasil',
            'Selesaikan pembayaran di browser Anda',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          throw 'Tidak dapat membuka browser';
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memproses pembayaran: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
