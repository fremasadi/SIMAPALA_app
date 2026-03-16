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
                      Get.back(result: true); // ← trigger refresh
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
                    if (controller.selectedAlatList.isEmpty) {
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
                      const SizedBox(height: 4),
                      Text(
                        'Tap untuk memilih, tap lagi untuk membatalkan',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 11.sp,
                        ),
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
                                      color: Colors.white.withValues(
                                        alpha: 0.7,
                                      ),
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
                            final isSelected = controller.isAlatSelected(alat);
                            final isAvailable =
                                alat.status.toLowerCase() == 'tersedia';

                            return GestureDetector(
                              onTap: () => controller.toggleSelectAlat(alat),
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
                                    // Icon & Checkbox
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
                                        AnimatedContainer(
                                          duration: const Duration(
                                            milliseconds: 200,
                                          ),
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? AppColor.primary
                                                : Colors.white.withValues(
                                                    alpha: 0.2,
                                                  ),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: isSelected
                                                  ? AppColor.primary
                                                  : Colors.white.withValues(
                                                      alpha: 0.5,
                                                    ),
                                              width: 2,
                                            ),
                                          ),
                                          child: Icon(
                                            isSelected
                                                ? Icons.check
                                                : Icons.add,
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
                                        Expanded(
                                          child: Text(
                                            'Rp ${alat.hargaSewa}/hari',
                                            style: TextStyle(
                                              color: AppColor.primary,
                                              fontSize: 11.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
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
                                            ? Colors.green.withValues(
                                                alpha: 0.2,
                                              )
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

                      const SizedBox(height: 24),

                      // SELECTED ITEMS CHIPS
                      Obx(() {
                        if (controller.selectedAlatList.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.shopping_basket_outlined,
                                  color: AppColor.primary,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Alat Dipilih',
                                  style: TextStyle(
                                    color: AppColor.primary,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: controller.selectedAlatList.map((alat) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColor.primary.withValues(
                                      alpha: 0.2,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppColor.primary.withValues(
                                        alpha: 0.5,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.backpack,
                                        size: 16,
                                        color: AppColor.primary,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        alat.namaAlat,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      GestureDetector(
                                        onTap: () =>
                                            controller.removeSelectedAlat(alat),
                                        child: Icon(
                                          Icons.close,
                                          size: 16,
                                          color: Colors.red.shade300,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 24),
                          ],
                        );
                      }),

                      // SECTION: FORM TANGGAL
                      Obx(() {
                        if (controller.selectedAlatList.isEmpty) {
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

                            // Summary Card
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColor.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppColor.primary.withValues(
                                    alpha: 0.3,
                                  ),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.receipt_long_outlined,
                                        color: AppColor.primary,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Ringkasan Peminjaman',
                                        style: TextStyle(
                                          color: AppColor.primary,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  _buildSummaryRow(
                                    'Jumlah Alat',
                                    '${controller.selectedAlatList.length} item',
                                  ),
                                  const SizedBox(height: 8),
                                  _buildSummaryRow(
                                    'Durasi',
                                    controller.getDurasi(),
                                  ),
                                  const Divider(
                                    color: Colors.white24,
                                    height: 24,
                                  ),
                                  // _buildSummaryRow(
                                  //   'Total Biaya',
                                  //   controller.getTotalBiaya(),
                                  //   isTotal: true,
                                  // ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 32),

                            // Submit Button
                            Obx(
                              () => SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton.icon(
                                  onPressed:
                                      controller.isValid() &&
                                          !controller
                                              .peminjamanService
                                              .isLoading
                                              .value
                                      ? () => controller.submitPeminjaman()
                                      : null,
                                  icon:
                                      controller
                                          .peminjamanService
                                          .isLoading
                                          .value
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                          ),
                                        )
                                      : const Icon(Icons.send_outlined),
                                  label: Text(
                                    controller.peminjamanService.isLoading.value
                                        ? 'Mengajukan...'
                                        : 'Ajukan Peminjaman',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.primary,
                                    foregroundColor: AppColor.secondary,
                                    disabledBackgroundColor: Colors.grey
                                        .withValues(alpha: 0.3),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 8,
                                    shadowColor: AppColor.primary.withValues(
                                      alpha: 0.5,
                                    ),
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
    final DateTime effectiveFirstDate = firstDate ?? DateTime.now();
    final DateTime effectiveInitialDate =
        (initialDate != null && !initialDate.isBefore(effectiveFirstDate))
            ? initialDate
            : effectiveFirstDate;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: effectiveInitialDate,
      firstDate: effectiveFirstDate,
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
