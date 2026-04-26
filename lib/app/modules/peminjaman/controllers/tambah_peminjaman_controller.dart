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
  
  // Map of Alat Name to quantity
  var selectedItems = <String, int>{}.obs; 
  // Map of Alat Name to one of its representative Alat object
  var nameToAlat = <String, Alat>{};

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
    
    // Initialize nameToAlat mapping for quick lookup
    nameToAlat.clear();
    for (var alat in alatList) {
      if (!nameToAlat.containsKey(alat.namaAlat)) {
        nameToAlat[alat.namaAlat] = alat;
      }
    }
    
    isLoading.value = false;
  }

  int getStockCount(String namaAlat) {
    return alatList.where((a) => a.namaAlat == namaAlat && a.status.toLowerCase() == 'tersedia').length;
  }

  void incrementItem(String namaAlat) {
    int current = selectedItems[namaAlat] ?? 0;
    int stock = getStockCount(namaAlat);
    
    if (current < stock) {
      selectedItems[namaAlat] = current + 1;
    } else {
      Get.snackbar(
        'Stok Terbatas',
        'Stok $namaAlat yang tersedia hanya $stock unit',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }

  void decrementItem(String namaAlat) {
    int current = selectedItems[namaAlat] ?? 0;
    if (current > 0) {
      if (current == 1) {
        selectedItems.remove(namaAlat);
      } else {
        selectedItems[namaAlat] = current - 1;
      }
    }
  }

  int getQuantity(String namaAlat) => selectedItems[namaAlat] ?? 0;

  void clearAllSelections() {
    selectedItems.clear();
  }

  void setTanggalPinjam(DateTime date) {
    tanggalPinjam.value = date;
    if (tanggalKembali.value != null && tanggalKembali.value!.isBefore(date)) {
      tanggalKembali.value = null;
    }
  }

  void setTanggalKembali(DateTime date) {
    if (tanggalPinjam.value == null) {
      Get.snackbar('Perhatian', 'Pilih tanggal pinjam terlebih dahulu');
      return;
    }
    if (date.isBefore(tanggalPinjam.value!)) {
      Get.snackbar('Perhatian', 'Tanggal kembali tidak boleh sebelum tanggal pinjam');
      return;
    }
    tanggalKembali.value = date;
  }

  String getDurasi() {
    if (tanggalPinjam.value == null || tanggalKembali.value == null) return '-';
    final durasi = tanggalKembali.value!.difference(tanggalPinjam.value!).inDays + 1;
    return '$durasi hari';
  }

  String getTotalBiaya() {
    if (selectedItems.isEmpty || tanggalPinjam.value == null || tanggalKembali.value == null) {
      return 'Rp 0';
    }

    final durasi = tanggalKembali.value!.difference(tanggalPinjam.value!).inDays + 1;
    int total = 0;

    selectedItems.forEach((name, qty) {
      final alat = nameToAlat[name];
      if (alat != null) {
        total += (durasi * alat.hargaSewa * qty);
      }
    });

    return 'Rp ${_formatCurrency(total)}';
  }

  String _formatCurrency(int value) {
    return value.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  bool isValid() {
    return selectedItems.isNotEmpty &&
        tanggalPinjam.value != null &&
        tanggalKembali.value != null;
  }

  Future<void> submitPeminjaman() async {
    if (!isValid()) return;
    
    try {
      isLoading.value = true;
      
      List<Map<String, dynamic>> items = [];
      selectedItems.forEach((name, qty) {
        final alat = nameToAlat[name];
        if (alat != null) {
          items.add({
            'alat_id': alat.id,
            'jumlah': qty,
          });
        }
      });

      final dateFormat = DateFormat('yyyy-MM-dd');
      final tanggalPinjamStr = dateFormat.format(tanggalPinjam.value!);
      final tanggalKembaliStr = dateFormat.format(tanggalKembali.value!);

      await peminjamanService.postPinjam(
        tanggalPinjam: tanggalPinjamStr,
        tanggalKembali: tanggalKembaliStr,
        items: items, 
      );

      if (peminjamanService.isSuccess.value == true) {
        Get.back(result: true);
        Get.snackbar('Berhasil', 'Permintaan pinjam alat berhasil dibuat', backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        throw peminjamanService.errorMessage.value;
      }
    } catch (e) {
      Get.snackbar('Gagal', e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  String getSelectedCountText() {
    int totalQty = 0;
    selectedItems.values.forEach((qty) => totalQty += qty);
    return totalQty > 0 ? '$totalQty item dipilih' : 'Belum ada alat dipilih';
  }

  List<Alat> getDistinctAlatList() {
    return nameToAlat.values.toList();
  }
}
