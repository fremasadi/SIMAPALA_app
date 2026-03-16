import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simapala/app/style/app_color.dart';
import 'package:simapala/app/style/app_font.dart';

import 'package:simapala/app/data/model/dana_masuk_model.dart';
import '../controllers/danamasuk_controller.dart';

class DanamasukView extends GetView<DanamasukController> {
  const DanamasukView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.secondary,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSummaryCard(),
            _buildFilterSection(),
            _buildList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showSubmitBottomSheet(context),
        backgroundColor: AppColor.primary,
        icon: const Icon(Icons.volunteer_activism, color: Colors.white),
        label: Text(
          'Kirim Sumbangan',
          style: AppFont.semiBold(14.sp, color: Colors.white),
        ),
      ),
    );
  }

  // ─── Header ────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.arrow_back, color: AppColor.primary, size: 26.sp),
          ),
          SizedBox(width: 4.w),
          Text(
            'Dana Masuk',
            style: AppFont.semiBold(20.sp, color: AppColor.primary),
          ),
          const Spacer(),
          Obx(
            () => controller.isLoading.value
                ? Padding(
                    padding: EdgeInsets.only(right: 16.w),
                    child: SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColor.primary,
                      ),
                    ),
                  )
                : IconButton(
                    onPressed: () => controller.fetchAll(),
                    icon: Icon(Icons.refresh,
                        color: AppColor.primary, size: 24.sp),
                    tooltip: 'Refresh',
                  ),
          ),
        ],
      ),
    );
  }

  // ─── Summary Card ──────────────────────────────────────────────────────────

  Widget _buildSummaryCard() {
    return Obx(() {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        padding: EdgeInsets.all(16.sp),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColor.primary.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            // Grand total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Dana Masuk',
                    style: AppFont.semiBold(14.sp, color: AppColor.primary)),
                Text(
                  controller.formatRupiah(controller.grandTotal.value),
                  style: AppFont.semiBold(18.sp, color: AppColor.primary),
                ),
              ],
            ),
            if (controller.summaryList.isNotEmpty) ...[
              Divider(color: AppColor.primary.withValues(alpha: 0.3), height: 20.h),
              ...controller.summaryList.map(
                (item) => Padding(
                  padding: EdgeInsets.only(bottom: 6.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(_jenisIcon(item.jenis),
                              size: 16.sp,
                              color: Colors.white.withValues(alpha: 0.8)),
                          SizedBox(width: 6.w),
                          Text(item.jenisLabel,
                              style: AppFont.regular(13.sp,
                                  color: Colors.white.withValues(alpha: 0.9))),
                          SizedBox(width: 4.w),
                          Text('(${item.count})',
                              style: AppFont.regular(11.sp,
                                  color: Colors.white.withValues(alpha: 0.6))),
                        ],
                      ),
                      Text(
                        controller.formatRupiah(item.total),
                        style: AppFont.semiBold(13.sp, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  // ─── Filter ────────────────────────────────────────────────────────────────

  Widget _buildFilterSection() {
    return Obx(() {
      return Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
            child: Row(
              children: [
                // Status filter
                _filterChip(
                  label: controller.selectedStatus.value == null
                      ? 'Semua Status'
                      : controller.selectedStatus.value == 'approved'
                          ? 'Approved'
                          : 'Pending',
                  active: controller.selectedStatus.value != null,
                  onTap: () => _showStatusFilter(),
                ),
                SizedBox(width: 8.w),
                // Jenis filter
                _filterChip(
                  label: controller.selectedJenis.value == null
                      ? 'Semua Jenis'
                      : DanamasukController
                          .jenisOptions[controller.selectedJenis.value]!,
                  active: controller.selectedJenis.value != null,
                  onTap: () => _showJenisFilter(),
                ),
                SizedBox(width: 8.w),
                // Tahun filter
                _filterChip(
                  label: controller.selectedTahun.value == null
                      ? 'Semua Tahun'
                      : '${controller.selectedTahun.value}',
                  active: controller.selectedTahun.value != null,
                  onTap: () => _showTahunFilter(),
                ),
                SizedBox(width: 8.w),
                // Reset
                if (controller.hasActiveFilter)
                  _filterChip(
                    label: 'Reset',
                    active: false,
                    icon: Icons.close,
                    onTap: () => controller.resetFilter(),
                  ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _filterChip({
    required String label,
    required bool active,
    required VoidCallback onTap,
    IconData? icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: active
              ? AppColor.primary
              : Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: active ? AppColor.primary : Colors.white.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14.sp, color: Colors.white),
              SizedBox(width: 4.w),
            ],
            Text(
              label,
              style: AppFont.regular(
                12.sp,
                color: active ? Colors.white : Colors.white.withValues(alpha: 0.85),
              ),
            ),
            if (!active && icon == null) ...[
              SizedBox(width: 4.w),
              Icon(Icons.arrow_drop_down,
                  size: 16.sp, color: Colors.white.withValues(alpha: 0.7)),
            ],
          ],
        ),
      ),
    );
  }

  // ─── List ──────────────────────────────────────────────────────────────────

  Widget _buildList() {
    return Expanded(
      child: Obx(() {
        if (controller.isLoading.value && controller.danaMasukList.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        if (controller.danaMasukList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox_outlined,
                    size: 64.sp, color: Colors.white.withValues(alpha: 0.4)),
                SizedBox(height: 12.h),
                Text(
                  'Belum ada data dana masuk',
                  style: AppFont.regular(14.sp,
                      color: Colors.white.withValues(alpha: 0.6)),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 100.h),
          itemCount: controller.danaMasukList.length,
          itemBuilder: (_, i) =>
              _buildCard(controller.danaMasukList[i]),
        );
      }),
    );
  }

  Widget _buildCard(DanaMasuk item) {
    final statusColor = item.status == 'approved' ? Colors.green : Colors.orange;

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(14.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon jenis
          Container(
            width: 44.w,
            height: 44.h,
            decoration: BoxDecoration(
              color: AppColor.secondary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              _jenisIcon(item.jenis),
              color: AppColor.secondary,
              size: 22.sp,
            ),
          ),
          SizedBox(width: 12.w),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.jenisLabel,
                  style: AppFont.semiBold(13.sp, color: Colors.black87),
                ),
                SizedBox(height: 2.h),
                if (item.keterangan.isNotEmpty)
                  Text(
                    item.keterangan,
                    style: AppFont.regular(11.sp, color: Colors.grey.shade600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Icon(Icons.calendar_today_outlined,
                        size: 10.sp, color: Colors.grey),
                    SizedBox(width: 3.w),
                    Text(
                      item.tanggal,
                      style: AppFont.regular(11.sp, color: Colors.grey),
                    ),
                    if (item.user != null) ...[
                      SizedBox(width: 8.w),
                      Icon(Icons.person_outline,
                          size: 10.sp, color: Colors.grey),
                      SizedBox(width: 3.w),
                      Flexible(
                        child: Text(
                          item.user!.name,
                          style: AppFont.regular(11.sp, color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          // Nominal + status
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                controller.formatRupiah(item.nominal),
                style: AppFont.semiBold(13.sp, color: AppColor.secondary),
              ),
              SizedBox(height: 4.h),
              if (item.status != null)
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: statusColor.withValues(alpha: 0.5)),
                  ),
                  child: Text(
                    item.status == 'approved' ? 'Approved' : 'Pending',
                    style: AppFont.semiBold(10.sp, color: statusColor),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Bottom Sheet: Submit Sumbangan ────────────────────────────────────────

  void _showSubmitBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _SubmitSumbanganSheet(controller: controller),
    );
  }

  // ─── Filter Dialogs ────────────────────────────────────────────────────────

  void _showStatusFilter() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        padding: EdgeInsets.all(20.sp),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Filter Status',
                style: AppFont.semiBold(16.sp, color: Colors.black87)),
            SizedBox(height: 16.h),
            _filterOption('Semua', null, controller.selectedStatus,
                () => controller.applyFilter()),
            _filterOption('Approved', 'approved', controller.selectedStatus,
                () => controller.applyFilter()),
            _filterOption('Pending', 'pending', controller.selectedStatus,
                () => controller.applyFilter()),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }

  void _showJenisFilter() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        padding: EdgeInsets.all(20.sp),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Filter Jenis',
                style: AppFont.semiBold(16.sp, color: Colors.black87)),
            SizedBox(height: 16.h),
            _filterOption('Semua Jenis', null, controller.selectedJenis,
                () => controller.applyFilter()),
            ...DanamasukController.jenisOptions.entries.map(
              (e) => _filterOption(e.value, e.key, controller.selectedJenis,
                  () => controller.applyFilter()),
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }

  void _showTahunFilter() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        padding: EdgeInsets.all(20.sp),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Filter Tahun',
                style: AppFont.semiBold(16.sp, color: Colors.black87)),
            SizedBox(height: 16.h),
            _filterOption('Semua Tahun', null, controller.selectedTahun,
                () => controller.applyFilter()),
            ...DanamasukController.tahunOptions.map(
              (y) => _filterOption('$y', y, controller.selectedTahun,
                  () => controller.applyFilter()),
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }

  Widget _filterOption<T>(
    String label,
    T? value,
    Rxn<T> selected,
    VoidCallback onApply,
  ) {
    return Obx(() => ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(label,
              style: AppFont.regular(14.sp, color: Colors.black87)),
          trailing: selected.value == value
              ? Icon(Icons.check_circle, color: AppColor.secondary, size: 20.sp)
              : null,
          onTap: () {
            selected.value = value;
            Get.back();
            onApply();
          },
        ));
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────

  IconData _jenisIcon(String jenis) {
    switch (jenis) {
      case 'penyewaan':
        return Icons.backpack_outlined;
      case 'denda_telat':
        return Icons.timer_off_outlined;
      case 'denda_rusak':
        return Icons.handyman_outlined;
      case 'kas':
        return Icons.account_balance_wallet_outlined;
      case 'sumbangan':
        return Icons.volunteer_activism_outlined;
      case 'dana_kampus':
        return Icons.school_outlined;
      default:
        return Icons.attach_money;
    }
  }
}

// ─── Bottom Sheet Widget ────────────────────────────────────────────────────

class _SubmitSumbanganSheet extends StatelessWidget {
  final DanamasukController controller;

  const _SubmitSumbanganSheet({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        padding: EdgeInsets.all(20.sp),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  margin: EdgeInsets.only(bottom: 16.h),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              Text('Kirim Sumbangan',
                  style: AppFont.semiBold(18.sp, color: Colors.black87)),
              SizedBox(height: 20.h),

              // Nominal
              Text('Nominal *',
                  style: AppFont.semiBold(13.sp, color: Colors.black87)),
              SizedBox(height: 6.h),
              Obx(() => TextField(
                    controller: controller.nominalController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Contoh: 50000',
                      prefixText: 'Rp ',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r)),
                      errorText: controller.nominalError.value.isEmpty
                          ? null
                          : controller.nominalError.value,
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 14.h),
                    ),
                    onChanged: (_) => controller.nominalError.value = '',
                  )),
              SizedBox(height: 16.h),

              // Keterangan
              Text('Keterangan (opsional)',
                  style: AppFont.semiBold(13.sp, color: Colors.black87)),
              SizedBox(height: 6.h),
              TextField(
                controller: controller.keteranganController,
                maxLines: 3,
                maxLength: 500,
                decoration: InputDecoration(
                  hintText: 'Keterangan sumbangan...',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r)),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
                ),
              ),
              SizedBox(height: 8.h),

              // Bukti foto
              Text('Bukti Pembayaran (opsional)',
                  style: AppFont.semiBold(13.sp, color: Colors.black87)),
              SizedBox(height: 6.h),
              Obx(() => controller.selectedImage.value == null
                  ? GestureDetector(
                      onTap: () => controller.pickImage(),
                      child: Container(
                        width: double.infinity,
                        height: 80.h,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cloud_upload_outlined,
                                size: 28.sp, color: Colors.grey),
                            SizedBox(height: 4.h),
                            Text('Tap untuk upload',
                                style: AppFont.regular(12.sp,
                                    color: Colors.grey)),
                          ],
                        ),
                      ),
                    )
                  : Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: Image.file(
                            controller.selectedImage.value!,
                            height: 120.h,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 6,
                          right: 6,
                          child: GestureDetector(
                            onTap: () => controller.removeImage(),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              padding: EdgeInsets.all(4.sp),
                              child: Icon(Icons.close,
                                  size: 16.sp, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    )),

              SizedBox(height: 24.h),

              // Submit button
              Obx(() => SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      onPressed: controller.isSubmitting.value
                          ? null
                          : () => controller.submitSumbangan(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.secondary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r)),
                        disabledBackgroundColor: Colors.grey,
                      ),
                      child: controller.isSubmitting.value
                          ? SizedBox(
                              width: 20.w,
                              height: 20.h,
                              child: const CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : Text('Kirim Sumbangan',
                              style:
                                  AppFont.semiBold(15.sp, color: Colors.white)),
                    ),
                  )),
              SizedBox(height: 8.h),
            ],
          ),
        ),
      ),
    );
  }
}
