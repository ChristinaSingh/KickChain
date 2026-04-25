import 'package:get/get.dart';

import '../controllers/faq_screen_controller.dart';

class FaqScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FaqController>(
      () => FaqController(),
    );
  }
}
