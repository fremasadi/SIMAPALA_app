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
    controller.fetchAlat();

    return Scaffold(
      backgroundColor: AppColor.secondary,
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(
                      Icons.arrow_back,
                      color: AppColor.primary,
                      size: 28,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'Ajukan Peminjaman',
                    style: TextStyle(
                      color: AppColor.primary,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // CONTENT
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SECTION: PILIH ALAT
                    Text(
                      'Pilih Alat',
                      style: TextStyle(
                        color: AppColor.primary,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Obx(() {
                      if (controller.isLoading.value) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(40),
                            child: Container(),
                          ),
                        );
                      }

                      if (controller.alatList.isEmpty) {
                        return Center(
                          child: Container(
                            padding: const EdgeInsets.all(40),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.inventory_2_outlined,
                                  size: 64,
                                  color: Colors.white.withValues(alpha: 0.3),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Tidak ada alat tersedia',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.7),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: controller.alatList.map((alat) {
                          final isSelected =
                              controller.selectedAlat.value?.id == alat.id;
                          final isAvailable =
                              alat.status.toLowerCase() == 'tersedia';

                          return GestureDetector(
                            onTap: isAvailable
                                ? () => controller.setSelectedAlat(alat)
                                : null,
                            child: Container(
                              width: (Get.width - 52) / 2,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColor.primary.withValues(alpha: 0.2)
                                    : Colors.white.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColor.primary
                                      : Colors.white.withValues(alpha: 0.1),
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Icon & Status Badge
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: isAvailable
                                              ? Colors.green.withValues(
                                                  alpha: 0.2,
                                                )
                                              : Colors.orange.withValues(
                                                  alpha: 0.2,
                                                ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.backpack,
                                          color: isAvailable
                                              ? Colors.green
                                              : Colors.orange,
                                          size: 24,
                                        ),
                                      ),
                                      if (isSelected)
                                        Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: AppColor.primary,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),

                                  // Nama Alat
                                  Text(
                                    alat.namaAlat,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),

                                  // Harga
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.payments_outlined,
                                        size: 14,
                                        color: AppColor.primary,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Rp ${alat.hargaSewa}',
                                        style: TextStyle(
                                          color: AppColor.primary,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),

                                  // Status
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isAvailable
                                          ? Colors.green.withValues(alpha: 0.2)
                                          : Colors.orange.withValues(
                                              alpha: 0.2,
                                            ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      alat.status,
                                      style: TextStyle(
                                        color: isAvailable
                                            ? Colors.green
                                            : Colors.orange,
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }),

                    const SizedBox(height: 32),

                    // SECTION: FORM TANGGAL
                    Obx(() {
                      if (controller.selectedAlat.value == null) {
                        return const SizedBox.shrink();
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Detail Peminjaman',
                            style: TextStyle(
                              color: AppColor.primary,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Tanggal Pinjam
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

                          // Tanggal Kembali
                          _buildDateField(
                            label: 'Tanggal Kembali',
                            icon: Icons.event_available_outlined,
                            selectedDate: controller.tanggalKembali.value,
                            onTap: () => _selectDate(
                              context,
                              controller.tanggalKembali.value,
                              (date) => controller.setTanggalKembali(date),
                              firstDate:
                                  controller.tanggalPinjam.value ??
                                  DateTime.now(),
                            ),
                          ),
                          const SizedBox(height: 16),

                          const SizedBox(height: 24),

                          // Summary Card
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColor.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColor.primary.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ringkasan Peminjaman',
                                  style: TextStyle(
                                    color: AppColor.primary,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _buildSummaryRow(
                                  'Alat',
                                  controller.selectedAlat.value!.namaAlat,
                                ),

                                const SizedBox(height: 8),
                                _buildSummaryRow(
                                  'Durasi',
                                  controller.getDurasi(),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Submit Button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: controller.isValid()
                                  ? () => controller.submitPeminjaman()
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.primary,
                                foregroundColor: AppColor.secondary,
                                disabledBackgroundColor: Colors.grey.withValues(
                                  alpha: 0.3,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 8,
                                shadowColor: AppColor.primary.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                              child: const Text(
                                'Ajukan Peminjaman',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
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
          ],
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
          border: Border.all(
            color: AppColor.primary.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColor.primary, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: AppColor.primary.withValues(alpha: 0.7),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    selectedDate != null
                        ? DateFormat(
                            'EEEE, dd MMMM yyyy',
                            'id_ID',
                          ).format(selectedDate)
                        : 'Pilih tanggal',
                    style: TextStyle(
                      color: selectedDate != null
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.5),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.calendar_today,
              color: AppColor.primary.withValues(alpha: 0.5),
              size: 20,
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
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: isTotal ? 14.sp : 13.sp,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isTotal ? AppColor.primary : Colors.white,
            fontSize: isTotal ? 16.sp : 13.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(
    BuildContext context,
    DateTime? initialDate,
    Function(DateTime) onDateSelected, {
    DateTime? firstDate,
  }) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColor.primary,
              onPrimary: AppColor.secondary,
              surface: AppColor.secondary,
              onSurface: Colors.white,
            ),
            dialogTheme: DialogThemeData(backgroundColor: AppColor.secondary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onDateSelected(picked);
    }
  }
}
