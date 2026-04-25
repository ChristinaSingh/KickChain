import 'package:get/get.dart';

import '../controllers/profile_s_creen_controller.dart';

class ProfileSCreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileScreenController>(
      () => ProfileScreenController(),
    );
  }
}
