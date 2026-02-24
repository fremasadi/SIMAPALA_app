import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:simapala/app/modules/peminjaman/views/tambah_peminjaman_view.dart';

import '../../../style/app_color.dart';
import '../controllers/peminjaman_controller.dart';

// Peminjaman Page
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
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      final result = await Get.to(
                        () => const TambahPeminjamanView(),
                      );

                      if (result == true) {
                        controller.fetchPinjaman();
                      }
                    },
                    icon: Icon(
                      Icons.add_circle,
                      color: AppColor.primary,
                      size: 32,
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
                      'Belum ada peminjaman',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async => controller.fetchPinjaman(),
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: controller.pinjamanList.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final pinjaman = controller.pinjamanList[index];

                      return _buildPeminjamanCard(
                        namaAlat: pinjaman.detailTransaksis.isNotEmpty
                            ? pinjaman.detailTransaksis.first.alat.namaAlat
                            : '-',
                        tanggalPinjam: _formatDate(pinjaman.tanggalPinjam),
                        tanggalKembali: _formatDate(pinjaman.tanggalKembali),
                        status: pinjaman.status,
                        statusColor: _getStatusColor(pinjaman.status),
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
      case 'dipinjam':
        return Colors.orange;
      case 'selesai':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Widget _buildPeminjamanCard({
    required String namaAlat,
    required String tanggalPinjam,
    required String tanggalKembali,
    required String status,
    required Color statusColor,
  }) {
    return Container(
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
              Expanded(
                child: Text(
                  namaAlat,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.calendar_today, color: AppColor.primary, size: 16),
              const SizedBox(width: 8),
              Text(
                'Pinjam: $tanggalPinjam',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.event, color: AppColor.primary, size: 16),
              const SizedBox(width: 8),
              Text(
                'Kembali: $tanggalKembali',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
