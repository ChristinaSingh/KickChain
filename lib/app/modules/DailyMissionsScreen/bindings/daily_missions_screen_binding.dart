import 'package:get/get.dart';

import '../controllers/daily_missions_screen_controller.dart';

class DailyMissionsScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DailyMissionsController>(
      () => DailyMissionsController(),
    );
  }
}
