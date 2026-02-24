import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:simapala/app/modules/profile/controllers/notification_controller.dart';
import 'package:simapala/app/style/app_color.dart';
import 'package:simapala/app/style/app_font.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.secondary,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    size: 22.sp,
                    color: AppColor.primary,
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  'Notifikasi',
                  style: AppFont.semiBold(20.sp, color: AppColor.primary),
                ),
              ],
            ),

            Obx(
              () => Padding(
                padding: EdgeInsets.all(16.sp),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.sp),
                  decoration: BoxDecoration(
                    color: AppColor.secondary,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColor.primary),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Notifikasi Aplikasi',
                        style: AppFont.medium(16.sp, color: AppColor.white),
                      ),
                      Switch(
                        onChanged: (val) => controller.toggle(),
                        activeColor: AppColor.primary,
                        value: controller.on.value,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Obx(
              () => Padding(
                padding: EdgeInsets.all(16.sp),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.sp),
                  decoration: BoxDecoration(
                    color: AppColor.secondary,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColor.primary),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Notifikasi Kas Anggota',
                        style: AppFont.medium(16.sp, color: AppColor.white),
                      ),
                      Switch(
                        onChanged: (val) => controller.toggleKas(),
                        activeColor: AppColor.primary,
                        value: controller.onKas.value,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.sp),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.sp,
                  vertical: 12.sp,
                ),
                decoration: BoxDecoration(
                  color: AppColor.secondary,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColor.primary),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Notifikasi Aplikasi',
                      style: AppFont.medium(16.sp, color: AppColor.white),
                    ),
                    Spacer(),
                    Text(
                      'Default',
                      style: AppFont.medium(14.sp, color: AppColor.white),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16.sp,
                      color: AppColor.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
