import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simapala/app/data/utils/api_guard.dart';

import '../../../data/model/user_model.dart';
import '../../../data/providers/profile_provider.dart';
import '../../../data/services/auth_service.dart';

class ProfileController extends GetxController {
  final AuthService _authService = Get.find();
  final ProfileProvider _profileProvider = ProfileProvider();
  final ImagePicker _picker = ImagePicker();

  final Rxn<UserModel> user = Rxn<UserModel>();
  final RxnString imageUrl = RxnString();
  final RxBool isImageLoading = false.obs;
  final RxBool isUploading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserFromLocal();
    fetchProfileImage();
  }

  Future<void> _loadUserFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('user');
    if (userString != null) {
      user.value = UserModel.fromJson(jsonDecode(userString));
    }
  }

  Future<void> fetchProfileImage() async {
    try {
      isImageLoading.value = true;
      final token = await ApiGuard.getToken();

      final response =
          await _profileProvider.getProfileImage(token: token);
      ApiGuard.checkResponse(response);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['success'] == true) {
          imageUrl.value = body['data']['image_url'];
        }
      }
    } catch (_) {
      // gagal fetch image, tidak perlu tampilkan error
    } finally {
      isImageLoading.value = false;
    }
  }

  Future<void> pickAndUploadImage() async {
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    if (picked == null) return;

    final file = File(picked.path);
    final sizeInBytes = await file.length();
    if (sizeInBytes > 2 * 1024 * 1024) {
      Get.snackbar(
        'Ukuran file terlalu besar',
        'Maksimal 2MB',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    try {
      isUploading.value = true;
      final token = await ApiGuard.getToken();

      final response = await _profileProvider.uploadProfileImage(
        token: token,
        imageFile: file,
      );
      ApiGuard.checkResponse(response);

      final body = jsonDecode(response.body);

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          body['success'] == true) {
        imageUrl.value = body['data']['image_url'];
        Get.snackbar(
          'Berhasil',
          'Foto profil diperbarui',
          snackPosition: SnackPosition.TOP,
        );
      } else {
        throw body['message'] ?? 'Gagal upload foto';
      }
    } catch (e) {
      Get.snackbar(
        'Gagal',
        e.toString(),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isUploading.value = false;
    }
  }

  /// 🚪 LOGOUT
  Future<void> logout() async {
    await _authService.logout();
    Get.offAllNamed('/login');
  }
}
