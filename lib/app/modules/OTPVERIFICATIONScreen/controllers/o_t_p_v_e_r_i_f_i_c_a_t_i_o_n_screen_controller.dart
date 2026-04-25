import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/apis/api_methods/auth_service.dart';
import '../../../routes/app_pages.dart';

class OTPVERIFICATIONScreenController extends GetxController {
  final _authService = AuthService();

  final otpCtrl = TextEditingController();

  final RxBool   isLoading   = false.obs;
  final RxBool   isResending = false.obs;
  final RxString errorMsg    = ''.obs;
  final RxString email       = ''.obs;
  final RxInt    resendTimer = 0.obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    email.value = args?['email'] ?? '';
    _startResendTimer();
  }

  void _startResendTimer() {
    resendTimer.value = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (resendTimer.value <= 0) {
        t.cancel();
      } else {
        resendTimer.value--;
      }
    });
  }

  Future<void> verifyOtp() async {
    if (otpCtrl.text.trim().length < 4) {
      errorMsg.value = 'Please enter the complete OTP';
      return;
    }

    errorMsg.value = '';
    isLoading.value = true;

    try {
      final result = await _authService.verifyOtp(
        email: email.value,
        otp: otpCtrl.text.trim(),
      );

      if (result.success == true) {
        Get.snackbar(
          'Verified!',
          'Your account is verified. Please login.',
          backgroundColor: Colors.green.shade700,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        Get.offAllNamed(Routes.L_O_G_I_N_SCREEN);
      } else {
        errorMsg.value =
            result.message ?? 'Verification failed. Try again.';
      }
    } catch (e) {
      errorMsg.value = _extractErrorMessage(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOtp() async {
    if (resendTimer.value > 0) return;

    isResending.value = true;
    errorMsg.value = '';

    try {
      await _authService.resendOtp(email: email.value);
      Get.snackbar(
        'OTP Sent',
        'A new OTP has been sent to your email.',
        backgroundColor: Colors.green.shade700,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      _startResendTimer();
    } catch (e) {
      errorMsg.value = _extractErrorMessage(e);
    } finally {
      isResending.value = false;
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
    otpCtrl.dispose();
    _timer?.cancel();
    super.onClose();
  }
}