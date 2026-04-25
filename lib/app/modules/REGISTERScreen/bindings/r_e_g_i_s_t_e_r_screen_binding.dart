import 'package:get/get.dart';

import '../controllers/r_e_g_i_s_t_e_r_screen_controller.dart';

class REGISTERScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<REGISTERScreenController>(
      () => REGISTERScreenController(),
    );
  }
}
