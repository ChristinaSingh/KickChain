import 'package:get/get.dart';
import 'package:kickchain/app/routes/app_pages.dart';

import '../../../common/storage_service.dart';



class SettingScrenController extends GetxController {
  final StorageService _storageService = StorageService();

  final count = 0.obs;
  final isLoggingOut = false.obs;

  void increment() => count.value++;

  Future<void> logout() async {
    if (isLoggingOut.value) return;

    try {
      isLoggingOut.value = true;

      await _storageService.clearSession();

      // Optional: remove old controllers if needed
      // Get.deleteAll(force: true);

      Get.offAllNamed(Routes.L_O_G_I_N_SCREEN);
      // replace LOGIN_SCREEN with your actual login route
    } catch (e) {
      Get.snackbar(
        'Logout Failed',
        'Something went wrong while logging out.',
      );
    } finally {
      isLoggingOut.value = false;
    }
  }
}