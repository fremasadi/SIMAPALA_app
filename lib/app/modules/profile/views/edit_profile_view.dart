import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simapala/app/style/app_color.dart';
import 'package:simapala/app/style/app_font.dart';

class EditProfileView extends GetView {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.secondary,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    size: 20.sp,
                    color: AppColor.primary,
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  'Edit Profile',
                  style: AppFont.semiBold(22.sp, color: AppColor.primary),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // Content yang bisa di-scroll
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Informasi Data Diri',
                    style: AppFont.semiBold(
                      16.sp,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Form Fields
                  _buildTextField('Nama Lengkap', 'Fremas'),
                  SizedBox(height: 12.h),
                  _buildTextField(
                    'NIK/Username',
                    'akfisa_client_test',
                  ),
                  SizedBox(height: 12.h),
                  _buildTextField(
                    'Email',
                    'akfisa_client_test@gmail.com',
                  ),
                  SizedBox(height: 12.h),
                  _buildTextField(
                    'Alamat',
                    'hahahaha123',
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            // Tombol di bagian bawah
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: AppColor.primary,
                          width: 2.w,
                        ),
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
                        style: AppFont.semiBold(
                          16.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String value, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppFont.medium(12.sp, color: Colors.grey)),
        SizedBox(height: 6.h),
        TextFormField(
          initialValue: value,
          maxLines: maxLines,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 12.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
      ],
    );
  }
}
