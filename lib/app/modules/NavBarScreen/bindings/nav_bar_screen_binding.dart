import 'package:get/get.dart';
import 'package:kickchain/app/modules/InviteFriendsScreen/controllers/invite_friends_screen_controller.dart';
import 'package:kickchain/app/modules/ProfileSCreen/controllers/profile_s_creen_controller.dart';
import 'package:kickchain/app/modules/SettingScren/controllers/setting_scren_controller.dart';
import 'package:kickchain/app/modules/WalletScreen/controllers/wallet_screen_controller.dart';
import 'package:kickchain/app/modules/home/controllers/home_controller.dart';

import '../../profile_screen/controllers/profile_screen_controller.dart';
import '../controllers/nav_bar_screen_controller.dart';

class NavBarScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavBarScreenController>(() => NavBarScreenController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<InviteFriendsController>(
      () => InviteFriendsController(),
    );
    Get.lazyPut<WalletScreenController>(() => WalletScreenController());
    Get.lazyPut<SettingScrenController>(() => SettingScrenController());
    Get.lazyPut<ProfileScreenController2>(() => ProfileScreenController2());
  }
}
