// lib/app/modules/notifications/controllers/notification_screen_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/apis/api_methods/notification_service.dart';
import '../../../data/apis/api_models/notification_model.dart';


class NotificationScreenController extends GetxController {
  final NotificationService _notificationService = NotificationService();

  // ── State ─────────────────────────────────────────────────────────────────
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isMarkingAllRead = false.obs;
  final RxBool isDeletingAll = false.obs;
  final RxString errorMessage = ''.obs;
  final RxSet<String> loadingIds = <String>{}.obs;

  // ── Computed ──────────────────────────────────────────────────────────────
  int get unreadCount => notifications.where((n) => !n.isRead).length;
  bool get hasUnread => unreadCount > 0;
  bool get hasNotifications => notifications.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  // ── Fetch Notifications ───────────────────────────────────────────────────
  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _notificationService.getMyNotifications();

      // result will be empty list for both 200 empty and 404
      notifications.assignAll(result);
    } catch (e) {
      // Only set error for real failures (network, server 5xx, etc.)
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      _showErrorSnackbar(
        'Failed to load notifications',
        errorMessage.value,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ── Mark Single as Read ───────────────────────────────────────────────────
  Future<void> markAsRead(String notificationId) async {
    final index = notifications.indexWhere((n) => n.id == notificationId);
    if (index == -1 || notifications[index].isRead) return;

    try {
      loadingIds.add(notificationId);

      final updated =
      await _notificationService.markNotificationAsRead(notificationId);

      if (updated != null) {
        notifications[index] = updated;
      } else {
        // Optimistic local update when server returns 404/null
        notifications[index] = notifications[index].copyWith(isRead: true);
      }
      notifications.refresh();
    } catch (e) {
      _showErrorSnackbar('Error', e.toString().replaceAll('Exception: ', ''));
    } finally {
      loadingIds.remove(notificationId);
    }
  }

  // ── Mark All as Read ──────────────────────────────────────────────────────
  Future<void> markAllAsRead() async {
    if (!hasUnread) {
      _showInfoSnackbar('Info', 'All notifications are already read.');
      return;
    }

    try {
      isMarkingAllRead.value = true;

      await _notificationService.markAllNotificationsAsRead();

      // Update all locally
      final updated =
      notifications.map((n) => n.copyWith(isRead: true)).toList();
      notifications.assignAll(updated);

      _showSuccessSnackbar('Success', 'All notifications marked as read.');
    } catch (e) {
      _showErrorSnackbar('Error', e.toString().replaceAll('Exception: ', ''));
    } finally {
      isMarkingAllRead.value = false;
    }
  }

  // ── Delete My Notifications ───────────────────────────────────────────────
  Future<void> deleteMyNotifications() async {
    if (!hasNotifications) {
      _showInfoSnackbar('Info', 'No notifications to delete.');
      return;
    }

    final confirmed = await _showConfirmDialog(
      title: 'Clear Notifications',
      message: 'Are you sure you want to clear all your notifications?',
    );
    if (!confirmed) return;

    try {
      isDeletingAll.value = true;

      await _notificationService.deleteAllNotifications();
      notifications.clear();

      _showSuccessSnackbar('Success', 'Notifications cleared.');
    } catch (e) {
      _showErrorSnackbar('Error', e.toString().replaceAll('Exception: ', ''));
    } finally {
      isDeletingAll.value = false;
    }
  }

  // ── Delete All Notifications ──────────────────────────────────────────────
  Future<void> deleteAllNotifications() async {
    if (!hasNotifications) {
      _showInfoSnackbar('Info', 'No notifications to delete.');
      return;
    }

    final confirmed = await _showConfirmDialog(
      title: 'Delete All',
      message: 'Are you sure you want to delete all notifications?',
    );
    if (!confirmed) return;

    try {
      isDeletingAll.value = true;

      await _notificationService.deleteAllNotifications();
      notifications.clear();

      _showSuccessSnackbar('Success', 'All notifications deleted.');
    } catch (e) {
      _showErrorSnackbar('Error', e.toString().replaceAll('Exception: ', ''));
    } finally {
      isDeletingAll.value = false;
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  bool isNotificationLoading(String id) => loadingIds.contains(id);

  Future<bool> _showConfirmDialog({
    required String title,
    required String message,
  }) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: const Color(0xFF0A2A10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF5DCF00), width: 1),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          message,
          style: const TextStyle(color: Color(0xFFB2DFDB)),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFFB2DFDB)),
            ),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Confirm',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  void _showSuccessSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: const Color(0xFF5DCF00).withValues(alpha: 0.9),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.check_circle, color: Colors.white),
    );
  }

  void _showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: const Color(0xFFE53935).withValues(alpha: 0.9),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 4),
      icon: const Icon(Icons.error_outline, color: Colors.white),
    );
  }

  void _showInfoSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: const Color(0xFF0B826F).withValues(alpha: 0.9),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
      icon: const Icon(Icons.info_outline, color: Colors.white),
    );
  }
}