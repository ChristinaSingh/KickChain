import 'package:get/get.dart';

import '../controllers/withdraw_screen_controller.dart';

class WithdrawScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WithdrawController>(
      () => WithdrawController(),
    );
  }
}
