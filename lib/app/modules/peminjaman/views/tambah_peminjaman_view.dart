import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simapala/app/modules/peminjaman/controllers/tambah_peminjaman_controller.dart';
import 'package:simapala/app/style/app_color.dart';
import 'package:intl/intl.dart';

class TambahPeminjamanView extends GetView<TambahPeminjamanController> {
  const TambahPeminjamanView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        backgroundColor: AppColor.secondary,
        body: SafeArea(
          child: Column(
            children: [
              // HEADER
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Get.back(result: true);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: AppColor.primary,
                      size: 28,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ajukan Peminjaman',
                          style: TextStyle(
                            color: AppColor.primary,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Obx(
                          () => Text(
                            controller.getSelectedCountText(),
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Obx(() {
                    if (controller.selectedItems.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return TextButton.icon(
                      onPressed: () => controller.clearAllSelections(),
                      icon: const Icon(Icons.clear_all, size: 18),
                      label: const Text('Bersihkan'),
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                    );
                  }),
                ],
              ),

              // CONTENT
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async => controller.fetchAlat(),
                  color: AppColor.primary,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // SECTION: PILIH ALAT
                        Row(
                          children: [
                            Icon(
                              Icons.inventory_2_outlined,
                              color: AppColor.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Pilih Alat',
                              style: TextStyle(
                                color: AppColor.primary,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        Obx(() {
                          if (controller.isLoading.value) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(40),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          final distinctAlats = controller.getDistinctAlatList();

                          if (distinctAlats.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(40),
                                child: Text(
                                  'Tidak ada alat tersedia',
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ),
                            );
                          }

                          return ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: distinctAlats.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final alat = distinctAlats[index];
                              final totalStock = controller.getStockCount(alat.namaAlat);

                              return Obx(() {
                                final currentQty = controller.getQuantity(alat.namaAlat);
                                return Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.05),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: currentQty > 0
                                          ? AppColor.primary
                                          : Colors.white.withValues(alpha: 0.1),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: totalStock > 0 
                                              ? AppColor.primary.withValues(alpha: 0.1)
                                              : Colors.grey.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Icon(
                                          Icons.backpack, 
                                          color: totalStock > 0 ? AppColor.primary : Colors.grey
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              alat.namaAlat,
                                              style: TextStyle(
                                                color: totalStock > 0 ? Colors.white : Colors.white54,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              totalStock > 0 ? 'Stok: $totalStock' : 'Stok Habis',
                                              style: TextStyle(
                                                color: totalStock > 0 ? AppColor.primary : Colors.red,
                                                fontSize: 12.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (totalStock > 0)
                                        Row(
                                          children: [
                                            IconButton(
                                              onPressed: () => controller.decrementItem(alat.namaAlat),
                                              icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                                            ),
                                            Text(
                                              '$currentQty',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () => controller.incrementItem(alat.namaAlat),
                                              icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                                            ),
                                          ],
                                        )
                                      else
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                          decoration: BoxDecoration(
                                            color: Colors.red.withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(8.r),
                                            border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                                          ),
                                          child: Text(
                                            'HABIS',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              });
                            },
                          );
                        }),

                        const SizedBox(height: 24),

                        // SECTION: FORM TANGGAL
                        Obx(() {
                          if (controller.selectedItems.isEmpty) {
                            return const SizedBox.shrink();
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_month_outlined,
                                    color: AppColor.primary,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Periode Peminjaman',
                                    style: TextStyle(
                                      color: AppColor.primary,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              _buildDateField(
                                label: 'Tanggal Pinjam',
                                icon: Icons.event_outlined,
                                selectedDate: controller.tanggalPinjam.value,
                                onTap: () => _selectDate(
                                  context,
                                  controller.tanggalPinjam.value,
                                  (date) => controller.setTanggalPinjam(date),
                                  firstDate: DateTime.now(),
                                ),
                              ),
                              const SizedBox(height: 16),

                              _buildDateField(
                                label: 'Tanggal Kembali',
                                icon: Icons.event_available_outlined,
                                selectedDate: controller.tanggalKembali.value,
                                onTap: () => _selectDate(
                                  context,
                                  controller.tanggalKembali.value,
                                  (date) => controller.setTanggalKembali(date),
                                  firstDate: controller.tanggalPinjam.value ?? DateTime.now(),
                                ),
                              ),
                              const SizedBox(height: 24),

                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColor.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: AppColor.primary.withValues(alpha: 0.3)),
                                ),
                                child: Column(
                                  children: [
                                    _buildSummaryRow('Durasi', controller.getDurasi()),
                                    const Divider(color: Colors.white24, height: 24),
                                    _buildSummaryRow('Total Biaya', controller.getTotalBiaya(), isTotal: true),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 32),

                              SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: controller.isValid() && !controller.isLoading.value
                                      ? () => controller.submitPeminjaman()
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.primary,
                                    foregroundColor: AppColor.secondary,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  ),
                                  child: controller.isLoading.value
                                      ? const CircularProgressIndicator(color: Colors.white)
                                      : const Text('Ajukan Peminjaman', style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                              ),
                              const SizedBox(height: 32),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required IconData icon,
    required DateTime? selectedDate,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColor.primary.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColor.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(color: Colors.white70, fontSize: 12)),
                  Text(
                    selectedDate != null
                        ? DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(selectedDate)
                        : 'Pilih tanggal',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.white70, fontSize: isTotal ? 16 : 14)),
        Text(value, style: TextStyle(color: isTotal ? AppColor.primary : Colors.white, fontWeight: FontWeight.bold, fontSize: isTotal ? 18 : 14)),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context, DateTime? initialDate, Function(DateTime) onDateSelected, {required DateTime firstDate}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: (initialDate != null && !initialDate.isBefore(firstDate)) ? initialDate : firstDate,
      firstDate: firstDate,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) onDateSelected(picked);
  }
}
