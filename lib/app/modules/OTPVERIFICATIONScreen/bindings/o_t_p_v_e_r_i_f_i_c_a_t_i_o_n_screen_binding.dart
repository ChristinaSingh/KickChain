import 'package:get/get.dart';

import '../controllers/o_t_p_v_e_r_i_f_i_c_a_t_i_o_n_screen_controller.dart';

class OTPVERIFICATIONScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OTPVERIFICATIONScreenController>(
      () => OTPVERIFICATIONScreenController(),
    );
  }
}
