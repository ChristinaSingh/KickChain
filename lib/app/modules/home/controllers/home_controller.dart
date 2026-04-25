import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/colors.dart';
import '../../../common/glass_container.dart';
import '../../../common/text_styles.dart';
import '../../../data/apis/api_methods/auth_service.dart';
import '../../../data/apis/api_methods/storage_service.dart';
import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  final _storage     = StorageService();
  final _authService = AuthService();

  // ── User state ───────────────────────────────
  final RxString userName   = 'Anonymous'.obs;
  final RxString userAvatar = ''.obs;
  final RxBool   isLoggedIn = false.obs;
  final RxInt    coinBalance = 0.obs;

  // ── Bottom nav ───────────────────────────────
  final RxInt selectedIndex = 0.obs;

  void onNavTap(int index) => selectedIndex.value = index;

  @override
  void onInit() {
    super.onInit();
    _loadUserState();
  }

  void _loadUserState() {
    final token = _storage.getToken();
    if (token != null && token.isNotEmpty) {
      isLoggedIn.value  = true;
      userName.value    = _storage.getUserName() ?? 'Player';
      userAvatar.value  = _storage.getUserAvatar() ?? '';
      coinBalance.value = 0; // Placeholder, ideally should be fetched from profile
      _fetchProfile();
    } else {
      isLoggedIn.value  = false;
      userName.value    = 'Anonymous';
      userAvatar.value  = '';
      coinBalance.value = 0;
    }
  }

  Future<void> _fetchProfile() async {
    try {
      final result = await _authService.getProfile();
      if (result.success == true && result.data != null) {
        userName.value   = result.data!.name ?? 'Player';
        userAvatar.value = result.data!.avatar ?? '';
        await _storage.saveUserName(userName.value);
        await _storage.saveUserAvatar(userAvatar.value);
      }
    } catch (_) {}
  }

  /// Called after returning from login/register
  void refreshUserState() => _loadUserState();

  // ── Action buttons ───────────────────────────

  void onPlayMatch() {
    if (!isLoggedIn.value) {
      _showProfileSetupSheet();
      return;
    }
    Get.toNamed(Routes.MATCH_SETUP_SCREEN);
  }

  void onShop() {
    if (!isLoggedIn.value) {
      _showProfileSetupSheet();
      return;
    }
    Get.toNamed(Routes.SHOP_SCREEN);
  }

  void onLeaderboard() {
    Get.toNamed(Routes.LEADER_BOARD_SCREEN);
  }

  void onDailyMissions() {
    if (!isLoggedIn.value) {
      _showProfileSetupSheet();
      return;
    }
    Get.toNamed(Routes.DAILY_MISSIONS_SCREEN);
  }

  void onNotificationTap() {
    Get.toNamed(Routes.NOTIFICATION_S_CREEN);
  }

  void onProfileTap() {
    if (isLoggedIn.value) {
      Get.toNamed(Routes.PROFILE_SCREEN);
    } else {
      _showProfileSetupSheet();
    }
  }

  void logout() {
    _storage.clearAll();
    isLoggedIn.value  = false;
    userName.value    = 'Anonymous';
    userAvatar.value  = '';
    coinBalance.value = 0;
    Get.snackbar(
      'Logged Out',
      'You are now browsing as Anonymous',
      backgroundColor: Colors.black54,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // ── Profile Setup Bottom Sheet ───────────────
  void _showProfileSetupSheet() {
    Get.bottomSheet(
      _ProfileSetupSheet(),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }
}

// ═══════════════════════════════════════════════
//  Profile Setup Bottom Sheet (glassmorphic)
// ═══════════════════════════════════════════════

class _ProfileSetupSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius:
      const BorderRadius.vertical(top: Radius.circular(28)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 36),
          decoration: BoxDecoration(
            color: const Color(0xFF0A6400).withOpacity(0.92),
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(color: glassBorder),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white38,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Icon
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor.withOpacity(0.2),
                  border: Border.all(color: primaryColor, width: 2),
                ),
                child: const Icon(
                  Icons.person_add_rounded,
                  color: primaryColor,
                  size: 34,
                ),
              ),
              const SizedBox(height: 20),

              Text('Setup Your Profile',
                  style: MyTextStyle.dialogTitle),
              const SizedBox(height: 10),

              Text(
                'Create a profile to save your progress,\n'
                    'track scores, and compete with friends!',
                textAlign: TextAlign.center,
                style: MyTextStyle.dialogBody,
              ),
              const SizedBox(height: 28),

              // Login button
              GradientButton(
                label: 'Login',
                colors: const [playMatchStart, playMatchEnd],
                onTap: () {
                  Get.back();
                  Get.toNamed(Routes.L_O_G_I_N_SCREEN);
                },
              ),
              const SizedBox(height: 12),

              // Register button
              GradientButton(
                label: 'Create Account',
                colors: const [shopStart, shopEnd],
                onTap: () {
                  Get.back();
                  Get.toNamed(Routes.R_E_G_I_S_T_E_R_SCREEN);
                },
              ),
              const SizedBox(height: 14),

              // Skip
              TextButton(
                onPressed: () => Get.back(),
                child: const Text(
                  'Maybe Later',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}