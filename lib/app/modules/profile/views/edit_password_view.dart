import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:simapala/app/modules/profile/controllers/edit_password_controller.dart';
import 'package:simapala/app/modules/widgets/input_text_form_field.dart';
import 'package:simapala/app/style/app_color.dart';
import 'package:simapala/app/style/app_font.dart';

class EditPasswordView extends GetView<EditPasswordController> {
  const EditPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.secondary,
      body: SafeArea(
        child: SingleChildScrollView(
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
                    'Edit Password ',
                    style: AppFont.semiBold(20.sp, color: AppColor.primary),
                  ),
                ],
              ),

              Container(
                padding: EdgeInsets.all(16.sp),
                margin: EdgeInsets.all(16.sp),
                width: ScreenUtil().screenWidth,
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Buat Password Baru', style: AppFont.bold(16.sp)),
                    SizedBox(height: 6.h),
                    Text(
                      'Masukan Password Sekarang',
                      style: AppFont.medium(14.sp),
                    ),
                    SizedBox(height: 6.h),
                    InputTextFormField(
                      controller: controller.nowPassword,
                      isSecureField: true,
                      borderColor: AppColor.secondary,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'Buat password baru pastikan memiliki kombinasi angka dan huruf besar dan kecil',
                      style: AppFont.bold(14.sp),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'Masukan Password Sekarang',
                      style: AppFont.medium(14.sp),
                    ),
                    SizedBox(height: 6.h),
                    InputTextFormField(
                      controller: controller.newPassword,
                      borderColor: AppColor.secondary,
                      isSecureField: true,
                    ),
                    SizedBox(height: 6.h),
                    Text('Ulangi Password Baru', style: AppFont.medium(14.sp)),
                    SizedBox(height: 6.h),
                    InputTextFormField(
                      controller: controller.confirmNewPassword,
                      isSecureField: true,
                      borderColor: AppColor.secondary,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.sp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Get.back();
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColor.primary, width: 2.w),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                        ),
                        child: Text(
                          'Kembali',
                          style: AppFont.semiBold(
                            16.sp,
                            color: AppColor.primary,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle simpan
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                        ),
                        child: Text(
                          'Simpan',
                          style: AppFont.semiBold(16.sp, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
