import 'package:get/get.dart';

import '../controllers/setting_scren_controller.dart';

class SettingScrenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingScrenController>(
      () => SettingScrenController(),
    );
  }
}
