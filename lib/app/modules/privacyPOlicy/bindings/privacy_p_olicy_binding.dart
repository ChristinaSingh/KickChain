import 'package:get/get.dart';

import '../controllers/privacy_p_olicy_controller.dart';

class PrivacyPOlicyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PrivacyPOlicyController>(
      () => PrivacyPOlicyController(),
    );
  }
}
