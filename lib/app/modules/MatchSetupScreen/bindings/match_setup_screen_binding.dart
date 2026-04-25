import 'package:get/get.dart';

import '../controllers/match_setup_screen_controller.dart';

class MatchSetupScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MatchSetupScreenController>(
      () => MatchSetupScreenController(),
    );
  }
}
