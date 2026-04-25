import 'package:get/get.dart';

import '../controllers/l_o_g_i_n_screen_controller.dart';

class LOGINScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LOGINScreenController>(
      () => LOGINScreenController(),
    );
  }
}
