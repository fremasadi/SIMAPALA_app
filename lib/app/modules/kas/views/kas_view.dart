import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:simapala/app/modules/kas/views/tambah_kas_view.dart';

import '../../../style/app_color.dart';
import '../../widgets/kas_bottom_sheet.dart';
import '../controllers/kas_controller.dart';

class KasView extends GetView<KasController> {
  const KasView({super.key});

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
              child: Column(
                children: [
                  Text(
                    'Kas Anggota',
                    style: TextStyle(
                      color: AppColor.primary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColor.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Semua Kas',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 14.sp,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            controller.totalKasFormatted.value,
                            // ✅ DARI API
                            style: TextStyle(
                              color: AppColor.primary,
                              fontSize: 36.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20.h),
                          ElevatedButton.icon(
                            onPressed: () {
                              Get.to(TambahKasView());
                            },
                            icon: const Icon(Icons.payment),
                            label: const Text('Bayar Kas'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.primary,
                              foregroundColor: AppColor.secondary,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Riwayat Transaksi',
                    style: TextStyle(
                      color: AppColor.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Obx(
                  //   () => controller.isLoading.value
                  //       ? SizedBox(
                  //           width: 20.w,
                  //           height: 20.h,
                  //           child: CircularProgressIndicator(
                  //             strokeWidth: 2,
                  //             color: AppColor.primary,
                  //           ),
                  //         )
                  //       : IconButton(
                  //           onPressed: () => controller.fetchKas(),
                  //           icon: Icon(
                  //             Icons.refresh,
                  //             color: AppColor.primary,
                  //             size: 24.sp,
                  //           ),
                  //           tooltip: 'Refresh',
                  //         ),
                  // ),
                ],
              ),
            ),

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.kasBulananList.isEmpty) {
                  return const Center(child: Text('Belum ada data kas'));
                }

                return RefreshIndicator(
                  onRefresh: () async => controller.fetchKas(),
                  color: AppColor.primary,
                  backgroundColor: AppColor.secondary,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: controller.kasBulananList.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final kas = controller.kasBulananList[index];

                      // ambil pembayaran pertama (biasanya cuma 1)
                      final pembayaran = kas.pembayarans.isNotEmpty
                          ? kas.pembayarans.first
                          : null;

                      return _buildKasCard(
                        jenis: 'Pemasukan',
                        keterangan: ' ${_formatBulan(kas.bulan)} ${kas.tahun}',
                        tanggal: pembayaran != null
                            ? _formatDate(pembayaran.tanggalBayar)
                            : '-',
                        status: kas.status == 'lunas' ? 'Lunas' : 'Belum Lunas',
                        detailClick: () {
                          showPembayaranListBottomSheet(
                            context,
                            kas.pembayarans,
                          );
                        },
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

  String _formatBulan(int bulan) {
    const bulanNama = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return bulanNama[bulan - 1];
  }

  String _formatDate(DateTime date) {
    return '${date.day} ${_formatBulan(date.month)} ${date.year}';
  }

  Widget _buildKasCard({
    required String jenis,
    required String keterangan,
    required String tanggal,
    required String status,
    required VoidCallback detailClick,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.arrow_upward, color: Colors.green, size: 24),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  keterangan,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tanggal,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 12.w),
                decoration: BoxDecoration(
                  color: AppColor.secondary,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColor.white),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: AppColor.primary,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GestureDetector(
                onTap: detailClick,
                child: Icon(
                  Icons.remove_red_eye,
                  size: 29.sp,
                  color: AppColor.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
