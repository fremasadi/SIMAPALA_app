import 'dart:ui';

import 'package:get/get.dart';

import '../../../data/services/auth_service.dart';

class LoginController extends GetxController {
  // Observable variables
  var isPasswordHidden = true.obs;
  var isLoading = false.obs;

  final AuthService _authService = Get.find();


  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  // Login function
  void login(String email, String password) async {
    try {
      isLoading(true);
      await _authService.login(email, password);
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }


}