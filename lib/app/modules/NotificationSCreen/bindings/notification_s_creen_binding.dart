import 'package:get/get.dart';

import '../controllers/notification_s_creen_controller.dart';

class NotificationSCreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationScreenController>(
      () => NotificationScreenController(),
    );
  }
}
