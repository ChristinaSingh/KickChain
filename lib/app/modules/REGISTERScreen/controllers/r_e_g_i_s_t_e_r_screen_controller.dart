// lib/modules/register_screen/controllers/r_e_g_i_s_t_e_r_screen_controller.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/apis/api_methods/auth_service.dart';
import '../../../routes/app_pages.dart';

class REGISTERScreenController extends GetxController {
  final _authService = AuthService();

  final formKey      = GlobalKey<FormState>();
  final nameCtrl     = TextEditingController();
  final emailCtrl    = TextEditingController();
  final phoneCtrl    = TextEditingController();
  final passwordCtrl = TextEditingController();

  final RxBool    isLoading   = false.obs;
  final RxBool    obscurePass = true.obs;
  final RxString  errorMsg    = ''.obs;
  final RxString  gender      = 'male'.obs;
  final Rx<File?> avatarFile  = Rx<File?>(null);

  final _picker = ImagePicker();

  void togglePassword() => obscurePass.toggle();
  void setGender(String g) => gender.value = g;

  Future<void> pickAvatar() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
      maxHeight: 600,
      imageQuality: 80,
    );
    if (picked != null) {
      avatarFile.value = File(picked.path);
    }
  }

  // ── Validators ───────────────────────────────

  String? validateName(String? v) {
    if (v == null || v.trim().isEmpty) return 'Name is required';
    if (v.trim().length < 2) return 'Minimum 2 characters';
    return null;
  }

  String? validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    if (!GetUtils.isEmail(v.trim())) return 'Enter a valid email';
    return null;
  }

  String? validatePhone(String? v) {
    if (v == null || v.trim().isEmpty) return 'Phone number is required';
    if (v.trim().length < 10) return 'Enter a valid phone number';
    return null;
  }

  // ✅ FIXED: Changed from 6 to 8 characters to match API requirement
  String? validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    if (v.length < 8) return 'Password must be at least 8 characters';
    if (!RegExp(r'[A-Z]').hasMatch(v)) {
      return 'Must contain at least one uppercase letter';
    }
    if (!RegExp(r'[a-z]').hasMatch(v)) {
      return 'Must contain at least one lowercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(v)) {
      return 'Must contain at least one digit';
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(v)) {
      return 'Must contain at least one special character';
    }
    return null;
  }

  // ── Register ─────────────────────────────────

  Future<void> register() async {
    // Clear previous error
    errorMsg.value = '';

    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      final result = await _authService.register(
        name: nameCtrl.text.trim(),
        email: emailCtrl.text.trim(),
        phoneNumber: phoneCtrl.text.trim(),
        password: passwordCtrl.text,
        gender: gender.value,
        avatarFile: avatarFile.value,
      );

      print("Registration result: success=${result.success}, message=${result.message}");

      if (result.success == true) {
        Get.snackbar(
          'Account Created!',
          'Please verify your email with the OTP sent.',
          backgroundColor: Colors.green.shade700,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        Get.offNamed(
          Routes.O_T_P_V_E_R_I_F_I_C_A_T_I_O_N_SCREEN,
          arguments: {'email': emailCtrl.text.trim()},
        );
      } else {
        errorMsg.value = result.message ?? 'Registration failed. Please try again.';
        _showErrorSnackbar(errorMsg.value);
      }
    } catch (e) {
      errorMsg.value = _extractErrorMessage(e);
      _showErrorSnackbar(errorMsg.value);
    } finally {
      isLoading.value = false;
    }
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red.shade700,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 4),
      icon: const Icon(Icons.error_outline, color: Colors.white),
    );
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
    nameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    passwordCtrl.dispose();
    super.onClose();
  }
}