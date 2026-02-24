import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:simapala/app/modules/kas/controllers/tambah_kas_controller.dart';
import 'package:simapala/app/style/app_color.dart';
import 'package:simapala/app/style/app_font.dart';

class TambahKasView extends GetView<TambahKasController> {
  const TambahKasView({super.key});

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
                    color: AppColor.primary,
                    size: 28.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  'Tambah Kas Anggota',
                  style: AppFont.semiBold(20.sp, color: AppColor.primary),
                ),
              ],
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Kas Bulanan Dropdown
                    Text(
                      'Kas Bulanan',
                      style: AppFont.semiBold(14.sp, color: AppColor.white),
                    ),
                    SizedBox(height: 8.h),
                    Obx(
                      () => Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: controller.kasBulananError.value.isNotEmpty
                                ? Colors.red
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: controller.isLoadingOptions.value
                            ? SizedBox(
                                height: 48.h,
                                child: Center(
                                  child: SizedBox(
                                    width: 20.w,
                                    height: 20.h,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              )
                            : DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value:
                                      controller
                                          .selectedKasBulanan
                                          .value
                                          .isEmpty
                                      ? null
                                      : controller.selectedKasBulanan.value,
                                  hint: Text(
                                    'Pilih Kas Bulanan',
                                    style: AppFont.regular(
                                      14.sp,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  items: () {
                                    final list = controller.kasBulananList;
                                    debugPrint('[KAS DROP] count: ${list.length}, isLoading: ${controller.isLoadingOptions.value}');
                                    for (final item in list) {
                                      debugPrint('[KAS DROP] => id:${item.id} | nama:${item.nama} | status:${item.status}');
                                    }
                                    return list.map((item) {
                                      return DropdownMenuItem<String>(
                                        value: item.id.toString(),
                                        child: Text(
                                          item.nama,
                                          style: AppFont.regular(
                                            14.sp,
                                            color: Colors.black,
                                          ),
                                        ),
                                      );
                                    }).toList();
                                  }(),
                                  onChanged: (value) {
                                    debugPrint('[KAS DROP] onChanged => $value');
                                    controller.selectedKasBulanan.value =
                                        value ?? '';
                                    controller.kasBulananError.value = '';
                                  },
                                ),
                              ),
                      ),
                    ),
                    Obx(
                      () => controller.kasBulananError.value.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.only(top: 4.h, left: 4.w),
                              child: Text(
                                controller.kasBulananError.value,
                                style: AppFont.regular(
                                  12.sp,
                                  color: Colors.red,
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                    ),
                    SizedBox(height: 16.h),

                    // Nominal Input
                    Text(
                      'Nominal',
                      style: AppFont.semiBold(14.sp, color: AppColor.white),
                    ),
                    SizedBox(height: 8.h),
                    //nominal
                    Obx(
                      () => Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: controller.nominalError.value.isNotEmpty
                                ? Colors.red
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: controller.selectedNominal.value.isEmpty
                                ? null
                                : controller.selectedNominal.value,
                            hint: Text(
                              'Pilih Jumlah Kas Anda',
                              style: AppFont.regular(14.sp, color: Colors.grey),
                            ),
                            items: [
                              DropdownMenuItem(
                                value: '10.000',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.money,
                                      color: AppColor.primary,
                                      size: 20.sp,
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      'Rp.10.000(Lunas)',
                                      style: AppFont.regular(
                                        14.sp,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              DropdownMenuItem(
                                value: '5.000',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.money,
                                      color: Colors.green,
                                      size: 20.sp,
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      'Rp.5.000(Cicil)',
                                      style: AppFont.regular(
                                        14.sp,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              controller.selectedNominal.value = value ?? '';
                              controller.nominalError.value = '';
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Metode Pembayaran Dropdown
                    Text(
                      'Metode Pembayaran',
                      style: AppFont.semiBold(14.sp, color: AppColor.white),
                    ),
                    SizedBox(height: 8.h),
                    Obx(
                      () => Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: controller.metodeError.value.isNotEmpty
                                ? Colors.red
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: controller.selectedMetode.value.isEmpty
                                ? null
                                : controller.selectedMetode.value,
                            hint: Text(
                              'Pilih Metode Pembayaran',
                              style: AppFont.regular(14.sp, color: Colors.grey),
                            ),
                            items: [
                              DropdownMenuItem(
                                value: 'dana',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.account_balance_wallet,
                                      color: AppColor.primary,
                                      size: 20.sp,
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      'DANA',
                                      style: AppFont.regular(
                                        14.sp,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'cash',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.money,
                                      color: Colors.green,
                                      size: 20.sp,
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      'Cash',
                                      style: AppFont.regular(
                                        14.sp,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              controller.selectedMetode.value = value ?? '';
                              controller.metodeError.value = '';
                            },
                          ),
                        ),
                      ),
                    ),
                    Obx(
                      () => controller.metodeError.value.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.only(top: 4.h, left: 4.w),
                              child: Text(
                                controller.metodeError.value,
                                style: AppFont.regular(
                                  12.sp,
                                  color: Colors.red,
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                    ),
                    SizedBox(height: 16.h),

                    // Bukti Bayar Upload
                    Text(
                      'Bukti Pembayaran (Opsional)',
                      style: AppFont.semiBold(14.sp, color: AppColor.white),
                    ),
                    SizedBox(height: 8.h),
                    Obx(
                      () => InkWell(
                        onTap: () => controller.pickImage(),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(16.sp),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: controller.buktiBayarError.value.isNotEmpty
                                  ? Colors.red
                                  : Colors.grey.shade300,
                            ),
                          ),
                          child: controller.selectedImage.value == null
                              ? Column(
                                  children: [
                                    Icon(
                                      Icons.cloud_upload_outlined,
                                      size: 48.sp,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      'Tap untuk upload gambar',
                                      style: AppFont.regular(
                                        12.sp,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      'Max 2MB',
                                      style: AppFont.regular(
                                        10.sp,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.r),
                                      child: Image.file(
                                        controller.selectedImage.value!,
                                        height: 150.h,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    TextButton.icon(
                                      onPressed: () => controller.removeImage(),
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      label: Text(
                                        'Hapus Gambar',
                                        style: AppFont.regular(
                                          12.sp,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                    Obx(
                      () => controller.buktiBayarError.value.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.only(top: 4.h, left: 4.w),
                              child: Text(
                                controller.buktiBayarError.value,
                                style: AppFont.regular(
                                  12.sp,
                                  color: Colors.red,
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),

            // Button Submit
            Container(
              padding: EdgeInsets.all(16.sp),
              decoration: BoxDecoration(
                color: AppColor.secondary,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Obx(
                () => ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () => controller.submitKas(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    minimumSize: Size(double.infinity, 50.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    disabledBackgroundColor: Colors.grey,
                  ),
                  child: controller.isLoading.value
                      ? SizedBox(
                          height: 20.h,
                          width: 20.h,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Simpan Kas',
                          style: AppFont.semiBold(16.sp, color: Colors.white),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
