import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:simapala/app/data/providers/profile_provider.dart';
import 'package:simapala/app/data/utils/api_guard.dart';

class EditPasswordController extends GetxController {
  final ProfileProvider _provider = ProfileProvider();

  final TextEditingController nowPassword = TextEditingController();
  final TextEditingController newPassword = TextEditingController();
  final TextEditingController confirmNewPassword = TextEditingController();

  final RxBool isLoading = false.obs;

  @override
  void onClose() {
    nowPassword.dispose();
    newPassword.dispose();
    confirmNewPassword.dispose();
    super.onClose();
  }

  Future<void> changePassword() async {
    final current = nowPassword.text.trim();
    final next = newPassword.text.trim();
    final confirm = confirmNewPassword.text.trim();

    if (current.isEmpty || next.isEmpty || confirm.isEmpty) {
      Get.snackbar('Gagal', 'Semua field wajib diisi',
          snackPosition: SnackPosition.TOP);
      return;
    }

    if (next.length < 6) {
      Get.snackbar('Gagal', 'Password baru minimal 6 karakter',
          snackPosition: SnackPosition.TOP);
      return;
    }

    if (next != confirm) {
      Get.snackbar('Gagal', 'Konfirmasi password tidak cocok',
          snackPosition: SnackPosition.TOP);
      return;
    }

    try {
      isLoading.value = true;
      final token = await ApiGuard.getToken();

      final response = await _provider.changePassword(
        token: token,
        currentPassword: current,
        newPassword: next,
        newPasswordConfirmation: confirm,
      );
      ApiGuard.checkResponse(response);

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['success'] == true) {
        nowPassword.clear();
        newPassword.clear();
        confirmNewPassword.clear();
        Get.back();
        Get.snackbar('Berhasil', 'Password berhasil diubah',
            snackPosition: SnackPosition.TOP);
      } else if (response.statusCode == 422) {
        final errors = body['errors'];
        final msg = errors != null
            ? (errors as Map).values.first[0]
            : body['message'] ?? 'Password lama tidak sesuai';
        Get.snackbar('Gagal', msg, snackPosition: SnackPosition.TOP);
      } else {
        throw body['message'] ?? 'Gagal mengubah password';
      }
    } catch (e) {
      Get.snackbar('Gagal', e.toString(), snackPosition: SnackPosition.TOP);
    } finally {
      isLoading.value = false;
    }
  }
}
