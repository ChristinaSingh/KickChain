import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/PushNotificationService.dart';
import '../../../common/storage_service.dart';
import '../../../data/apis/api_methods/auth_service.dart';
import '../../../routes/app_pages.dart';

class LOGINScreenController extends GetxController {
  final _authService = AuthService();
  final _storage = StorageService();
  String? deviceToken;
  final formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool obscurePass = true.obs;
  final RxString errorMsg = ''.obs;

  void togglePassword() => obscurePass.toggle();

  String? validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    if (!GetUtils.isEmail(v.trim())) return 'Enter a valid email';
    return null;
  }

  @override
  void onInit() {
    super.onInit();
    getDeviceToken();
  }

  Future<void> getDeviceToken() async {
    if (kIsWeb) {
      deviceToken = await PushNotificationService.getToken();
      return;
    }

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    try {
      if (GetPlatform.isAndroid) {
        deviceToken = await messaging.getToken();
        print('Android Device Token: $deviceToken');

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('device_token', deviceToken ?? '');
      } else if (GetPlatform.isIOS) {
        String? apnsToken;
        while (apnsToken == null) {
          apnsToken = await messaging.getAPNSToken();
          if (apnsToken == null) {
            await Future.delayed(const Duration(seconds: 1));
          }
        }
        print("APNS Token: $apnsToken");
        deviceToken = await messaging.getToken();
        print("iOS Firebase Token: $deviceToken");

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('device_token', deviceToken ?? '');
      }
    } catch (e) {
      print("Error getting device token: $e");
    }
  }

  String? validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    if (v.length < 6) return 'Minimum 6 characters';
    return null;
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    errorMsg.value = '';
    isLoading.value = true;

    try {
      final result = await _authService.login(
        email: emailCtrl.text.trim(),
        password: passwordCtrl.text,
        fcmToken: deviceToken,
      );

      if (result.success == true && result.data != null) {
        // Save to StorageService
        await _storage.saveToken(result.data!.token ?? '');
        await _storage.saveUserId(result.data!.user?.id ?? '');
        await _storage.saveUserName(result.data!.user?.name ?? '');
        await _storage.saveUserEmail(result.data!.user?.email ?? '');
        await _storage.saveIsLoggedIn(true);

        Get.snackbar(
          'Welcome!',
          'Logged in as ${result.data!.user?.name ?? "Player"}',
          backgroundColor: Colors.green.shade700,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );

        Get.offAllNamed(Routes.NAV_BAR_SCREEN);
      } else {
        errorMsg.value = result.message ?? 'Login failed. Please try again.';
      }
    } catch (e) {
      errorMsg.value = _extractErrorMessage(e);
    } finally {
      isLoading.value = false;
    }
  }

  String _extractErrorMessage(dynamic e) {
    final msg = e.toString();
    if (msg.contains('Exception: ')) {
      return msg.replaceFirst('Exception: ', '');
    }
    return 'Something went wrong. Please try again.';
  }

  @override
  void onClose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.onClose();
  }
}
