import 'package:get/get.dart';

import '../controllers/setting_notification_controller.dart';

class SettingNotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingNotificationController>(
      () => SettingNotificationController(),
    );
  }
}
