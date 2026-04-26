import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:simapala/app/modules/peminjaman/views/tambah_peminjaman_view.dart';

import '../../../style/app_color.dart';
import '../controllers/peminjaman_controller.dart';

class PeminjamanView extends GetView<PeminjamanController> {
  const PeminjamanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColor.secondary,
            AppColor.secondary.withValues(alpha: 0.8),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Peminjaman Alat',
                    style: TextStyle(
                      color: AppColor.primary,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      final result = await Get.to(() => const TambahPeminjamanView());
                      if (result == true) {
                        controller.fetchPinjaman();
                      }
                    },
                    icon: Icon(
                      Icons.add_circle,
                      color: AppColor.primary,
                      size: 32.sp,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.pinjamanList.isEmpty) {
                  return Center(
                    child: Text(
                      'Belum ada riwayat peminjaman',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async => controller.fetchPinjaman(),
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: controller.pinjamanList.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final pinjaman = controller.pinjamanList[index];

                      return _buildPeminjamanCard(
                        id: pinjaman.id,
                        jumlahAlat: pinjaman.jumlahAlat ?? 0,
                        tanggalPinjam: _formatDate(pinjaman.tanggalPinjam),
                        tanggalKembali: _formatDate(pinjaman.tanggalKembali),
                        status: pinjaman.status,
                        statusColor: _getStatusColor(pinjaman.status),
                        totalBiaya: pinjaman.totalBiaya,
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}-${date.month}-${date.year}';
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'disetujui':
      case 'selesai':
        return Colors.green;
      case 'dipinjam':
        return Colors.orange;
      case 'ditolak':
        return Colors.red;
      case 'menunggu':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Widget _buildPeminjamanCard({
    required int id,
    required int jumlahAlat,
    required String tanggalPinjam,
    required String tanggalKembali,
    required String status,
    required Color statusColor,
    required String totalBiaya,
  }) {
    return InkWell(
      onTap: () {
        // Show detail bottom sheet or navigate to detail page
        _showDetailBottomSheet(Get.context!, id);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ID Transaksi: #$id',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$jumlahAlat Alat dipinjam',
                      style: TextStyle(
                        color: AppColor.primary,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor),
                  ),
                  child: Text(
                    status.capitalizeFirst!,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24, color: Colors.white12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tgl Pinjam', style: TextStyle(color: Colors.white54, fontSize: 11.sp)),
                      Text(tanggalPinjam, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tgl Kembali', style: TextStyle(color: Colors.white54, fontSize: 11.sp)),
                      Text(tanggalKembali, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDetailBottomSheet(BuildContext context, int id) async {
    // Show loading dialog
    Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
    
    try {
      final detail = await controller.peminjamanService.fetchPeminjamanDetail(id);
      Get.back(); // close loading

      showModalBottomSheet(
        context: context,
        backgroundColor: AppColor.secondary,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (context) => Container(
          padding: const EdgeInsets.all(24),
          height: Get.height * 0.7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Detail Peminjaman #$id',
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              
              // Pembayaran info if exists
              if (detail.pembayaran != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.payment, color: Colors.green),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Order ID: ${detail.pembayaran!['order_id']}',
                              style: const TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                            // Text(
                            //   'Status Midtrans: ${detail.pembayaran!['transaction_status']}',
                            //   style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              Text('Daftar Alat', style: TextStyle(color: AppColor.primary, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  itemCount: detail.alats?.length ?? 0,
                  separatorBuilder: (_, __) => const Divider(color: Colors.white12),
                  itemBuilder: (context, i) {
                    final alat = detail.alats![i];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColor.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.backpack, color: AppColor.primary),
                      ),
                      title: Text(alat.namaAlat, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                      subtitle: Text(alat.kodeAlat, style: const TextStyle(color: Colors.white54)),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            alat.statusAlat.capitalizeFirst!,
                            style: TextStyle(color: _getStatusColor(alat.statusAlat), fontWeight: FontWeight.bold),
                          ),
                          if (alat.totalDenda > 0)
                            Text('Denda: Rp ${alat.totalDenda}', style: const TextStyle(color: Colors.red, fontSize: 10)),
                        ],
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    foregroundColor: AppColor.secondary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Tutup', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      Get.back(); // close loading
      Get.snackbar('Error', e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
