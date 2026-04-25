import 'package:get/get.dart';

// ─────────────────────────────────────────────
//  NAV BAR CONTROLLER  –  KickChain Soccer Clash
// ─────────────────────────────────────────────

class NavBarScreenController extends GetxController {
  /// Currently selected bottom-nav index
  final RxInt selectedIndex = 0.obs;

  /// Legacy counter kept for any existing observers
  final RxInt count = 0.obs;

  void onNavTap(int index) {
    selectedIndex.value = index;
    count.value         = index;
  }
}