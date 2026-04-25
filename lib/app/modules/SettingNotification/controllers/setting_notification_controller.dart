// lib/app/modules/setting_notification/controllers/setting_notification_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/apis/api_methods/notification_settings_model.dart';
import '../../../data/apis/api_methods/notification_settings_service.dart';

class SettingNotificationController extends GetxController {
  final _service = NotificationSettingsService();

  // ── Observable state ──────────────────────────────────────────────────────
  final isLoading = false.obs;
  final isUpdating = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  // ── Notification toggles ──────────────────────────────────────────────────
  final matchInvites = true.obs;
  final matchResults = true.obs;
  final payouts = true.obs;
  final referralRewards = true.obs;
  final systemUpdates = true.obs;

  // ── Debounce timer tracker ────────────────────────────────────────────────
  Worker? _debounceWorker;

  @override
  void onInit() {
    super.onInit();
    fetchNotificationSettings();
  }

  @override
  void onClose() {
    _debounceWorker?.dispose();
    super.onClose();
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  FETCH
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> fetchNotificationSettings() async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try {
      final settings = await _service.getNotificationSettings();
      _applySettings(settings);
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      _showErrorSnackbar('Failed to load settings', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  TOGGLE HANDLERS  (each toggle calls update immediately)
  // ─────────────────────────────────────────────────────────────────────────

  void onMatchInvitesChanged(bool value) {
    matchInvites.value = value;
    _updateSettings();
  }

  void onMatchResultsChanged(bool value) {
    matchResults.value = value;
    _updateSettings();
  }

  void onPayoutsChanged(bool value) {
    payouts.value = value;
    _updateSettings();
  }

  void onReferralRewardsChanged(bool value) {
    referralRewards.value = value;
    _updateSettings();
  }

  void onSystemUpdatesChanged(bool value) {
    systemUpdates.value = value;
    _updateSettings();
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  UPDATE  (called after every toggle)
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> _updateSettings() async {
    isUpdating.value = true;

    try {
      final updated = await _service.updateNotificationSettings(
        matchInvites: matchInvites.value,
        matchResults: matchResults.value,
        payouts: payouts.value,
        referralRewards: referralRewards.value,
        systemUpdates: systemUpdates.value,
      );

      // Sync local state with server response
      _applySettings(updated);

      _showSuccessSnackbar('Settings Updated', 'Your preferences were saved.');
    } catch (e) {
      _showErrorSnackbar(
        'Update Failed',
        e.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      isUpdating.value = false;
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  HELPERS
  // ─────────────────────────────────────────────────────────────────────────

  void _applySettings(NotificationSettingsModel settings) {
    matchInvites.value = settings.matchInvites;
    matchResults.value = settings.matchResults;
    payouts.value = settings.payouts;
    referralRewards.value = settings.referralRewards;
    systemUpdates.value = settings.systemUpdates;
  }

  void _showSuccessSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade900,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
      icon: const Icon(Icons.check_circle_outline, color: Colors.green),
    );
  }

  void _showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.red.shade100,
      colorText: Colors.red.shade900,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.error_outline, color: Colors.red),
    );
  }
}