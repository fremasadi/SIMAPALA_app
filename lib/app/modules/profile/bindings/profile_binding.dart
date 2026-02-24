import 'package:get/get.dart';

import 'package:simapala/app/modules/profile/controllers/edit_password_controller.dart';
import 'package:simapala/app/modules/profile/controllers/edit_profile_controller.dart';
import 'package:simapala/app/modules/profile/controllers/notification_controller.dart';

import '../controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditProfileController>(
      () => EditProfileController(),
    );
    Get.lazyPut<NotificationController>(
      () => NotificationController(),
    );
    Get.lazyPut<EditPasswordController>(
      () => EditPasswordController(),
    );
    Get.lazyPut<ProfileController>(
      () => ProfileController(),
    );
  }
}
