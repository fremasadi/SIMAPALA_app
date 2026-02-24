import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/model/user_model.dart';

class EditProfileController extends GetxController {
  final Rxn<UserModel> user = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    _loadUserFromLocal();
  }

  Future<void> _loadUserFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('user');

    if (userString != null) {
      user.value = UserModel.fromJson(jsonDecode(userString));
    }
  }
}
