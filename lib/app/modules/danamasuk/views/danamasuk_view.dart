import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simapala/app/style/app_color.dart';
import 'package:simapala/app/style/app_font.dart';

import '../controllers/danamasuk_controller.dart';

class DanamasukView extends GetView<DanamasukController> {
  const DanamasukView({super.key});

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
            _buildHeader(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => controller.fetchAll(),
                color: AppColor.primary,
                backgroundColor: AppColor.secondary,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      _buildMainCard(),
                      _buildSummaryGrid(),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(20.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Dana Masuk',
            style: AppFont.bold(24.sp, color: AppColor.primary),
          ),
          Obx(() => controller.isLoading.value
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColor.primary),
                )
              : const SizedBox.shrink()),
        ],
      ),
    );
  }

  Widget _buildMainCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      padding: EdgeInsets.all(24.sp),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: AppColor.primary.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Keseluruhan',
            style: AppFont.regular(14.sp, color: Colors.white70),
          ),
          SizedBox(height: 8.h),
          Obx(() => Text(
                controller.formatRupiah(controller.grandTotal.value),
                style: AppFont.bold(32.sp, color: AppColor.primary),
              )),
          SizedBox(height: 16.h),
          Row(
            children: [
              Icon(Icons.trending_up, color: Colors.green, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                'Saldo Organisasi Aktif',
                style: AppFont.medium(12.sp, color: Colors.white54),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryGrid() {
    return Obx(() {
      if (controller.summaryList.isEmpty) return const SizedBox.shrink();
      
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Text(
              'Rincian per Kategori',
              style: AppFont.semiBold(16.sp, color: Colors.white),
            ),
            SizedBox(height: 16.h),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.summaryList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
                childAspectRatio: 1.5,
              ),
              itemBuilder: (context, index) {
                final item = controller.summaryList[index];
                return Container(
                  padding: EdgeInsets.all(12.sp),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(_jenisIcon(item.jenis), color: AppColor.primary, size: 20.sp),
                          Text(
                            '${item.count}',
                            style: AppFont.medium(11.sp, color: Colors.white38),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.jenisLabel,
                            style: AppFont.regular(11.sp, color: Colors.white70),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            controller.formatRupiah(item.total),
                            style: AppFont.semiBold(13.sp, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      );
    });
  }

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
