import 'package:get/get.dart';

import '../controllers/invite_friends_screen_controller.dart';

class InviteFriendsScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InviteFriendsController>(
      () => InviteFriendsController(),
    );
  }
}
