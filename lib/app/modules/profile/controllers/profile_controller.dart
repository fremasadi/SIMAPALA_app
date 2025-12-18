import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/model/user_model.dart';

class ProfileController extends GetxController {
  static const _userKey = 'user';

  final Rxn<UserModel> user = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    _loadUserFromLocal();
  }

  Future<void> _loadUserFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(_userKey);

    if (userString != null) {
      final json = jsonDecode(userString);
      user.value = UserModel.fromJson(json);
    }
  }
}
