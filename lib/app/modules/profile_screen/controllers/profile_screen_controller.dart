import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../common/storage_service.dart';
import '../../../data/apis/api_methods/auth_service.dart';
import '../../../data/apis/api_models/user_model.dart';
import '../../../routes/app_pages.dart';
import '../views/profile_screen_view.dart';

class ProfileScreenController2 extends GetxController {
  final _authService = AuthService();
  final _storage = StorageService();

  // API state
  final RxBool isLoading = true.obs;
  final RxBool isUpdating = false.obs;
  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxString errorMsg = ''.obs;

  // Edit fields
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final RxString gender = 'male'.obs;
  final Rx<File?> pickedAvatar = Rx<File?>(null);

  // ── (Optional) keep your fancy UI stats demo values ─────────────
  final RxInt level = 6.obs;
  final RxInt currentXP = 340.obs;
  final RxInt maxXP = 500.obs;

  final RxInt totalMatches = 124.obs;
  final RxInt totalWins = 68.obs;
  final RxString winRate = '55%'.obs;
  final RxString totalEarnings = '0'.obs;

  final RxList<AchievementModel> achievements = <AchievementModel>[
    AchievementModel(label: 'First Win', emoji: '🏆', unlocked: true),
    AchievementModel(label: '10 Matches', emoji: '🎯', unlocked: true),
    AchievementModel(label: 'Crypto Player', emoji: '🦊', unlocked: false),
    AchievementModel(label: 'Win Streak 5', emoji: '🔥', unlocked: false),
    AchievementModel(label: '100 Wins', emoji: '⭐', unlocked: false),
    AchievementModel(label: 'Legendary', emoji: '👑', unlocked: false),
  ].obs;

  final RxList<MatchModel> recentMatches = <MatchModel>[
    MatchModel(won: true, timeAgo: '2 Hours Ago', score: '3-2', coins: 450),
    MatchModel(won: false, timeAgo: '2 Hours Ago', score: '4-1', coins: -100),
    MatchModel(won: false, timeAgo: '3 Hours Ago', score: '4-1', coins: -100),
    MatchModel(won: true, timeAgo: '5 Hours Ago', score: '1-2', coins: 800),
    MatchModel(won: true, timeAgo: '6 Hours Ago', score: '3-2', coins: 450),
  ].obs;

  double get xpProgress => maxXP.value == 0 ? 0 : currentXP.value / maxXP.value;

  @override
  void onInit() {
    super.onInit();
    final String? userToken = _storage.getToken();
    if (userToken == null || userToken.isEmpty) {
      // _error('User not authenticated. Please log in again.');
      return;
    }
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    isLoading.value = true;
    errorMsg.value = '';

    try {
      final result = await _authService.getProfile();
      if (result.success == true && result.data != null) {
        user.value = result.data;

        // Update local storage
        await _storage.saveUserName(result.data!.name ?? '');
        await _storage.saveUserAvatar(result.data!.avatar ?? '');
      } else {
        errorMsg.value = result.message ?? 'Failed to load profile';
      }
    } catch (e) {
      errorMsg.value = _extractErrorMessage(e);
    } finally {
      isLoading.value = false;
    }
  }

  // Open edit screen
  void onEditProfile() {
    final u = user.value;
    nameCtrl.text = u?.name ?? '';
    emailCtrl.text = u?.email ?? '';
    phoneCtrl.text = u?.phoneNumber ?? '';
    gender.value = (u?.gender?.isNotEmpty == true) ? u!.gender! : 'male';
    pickedAvatar.value = null;

    Get.to(() => const EditProfileView());
  }

  Future<void> pickAvatarFromGallery() async {
    final picker = ImagePicker();
    final xFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (xFile != null) {
      pickedAvatar.value = File(xFile.path);
    }
  }

  Future<void> updateProfile() async {
    isUpdating.value = true;
    try {
      final res = await _authService.updateProfile(
        name: nameCtrl.text.trim(),
        email: emailCtrl.text.trim(),
        phoneNumber: phoneCtrl.text.trim(),
        gender: gender.value.trim(),
        avatarFile: pickedAvatar.value,
      );

      if (res.success == true) {
        Get.back(); // close edit screen
        Get.snackbar(
          'Success',
          res.message ?? 'Profile updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black54,
          colorText: Colors.white,
        );
        await fetchProfile(); // refresh UI
      } else {
        Get.snackbar(
          'Failed',
          res.message ?? 'Failed to update profile',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black54,
          colorText: Colors.white,
        );
      }
    } finally {
      isUpdating.value = false;
    }
  }

  void logout() {
    _storage.clearAll();
    Get.offAllNamed(Routes.NAV_BAR_SCREEN);
    Get.snackbar(
      'Logged Out',
      'See you next time!',
      backgroundColor: Colors.black54,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
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
    super.onClose();
  }
}

// ── Data models used by fancy UI ────────────────────────────────────────────
class AchievementModel {
  final String label;
  final String emoji;
  final bool unlocked;

  AchievementModel({
    required this.label,
    required this.emoji,
    required this.unlocked,
  });
}

class MatchModel {
  final bool won;
  final String timeAgo;
  final String score;
  final int coins;

  MatchModel({
    required this.won,
    required this.timeAgo,
    required this.score,
    required this.coins,
  });
}
