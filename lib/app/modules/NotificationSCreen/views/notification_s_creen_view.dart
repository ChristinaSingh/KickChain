// lib/app/modules/notifications/views/notifications_screen.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kickchain/app/common/colors.dart';
import 'package:kickchain/app/routes/app_pages.dart';

import '../../../data/apis/api_models/notification_model.dart';
import '../controllers/notification_s_creen_controller.dart';

// ── Design constants ──────────────────────────────────────────────────────────
const Color _accentGreen = Color(0xFF5DCF00);
const Color _textPrimary = Color(0xFFFFFFFF);
const Color _textSecondary = Color(0xFFB2DFDB);
const Color _acceptGreen = Color(0xFF4CD137);
const Color _declineRed = Color(0xFFE53935);
const _radius = BorderRadius.all(Radius.circular(20));

// ─────────────────────────────────────────────────────────────────────────────
//  Background gradient
// ─────────────────────────────────────────────────────────────────────────────
class _BackgroundGradient extends StatelessWidget {
  const _BackgroundGradient();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0.3, -0.7),
          radius: 1.3,
          colors: [Color(0xFF1DB800), Color(0xFF0A6400), Color(0xFF053300)],
          stops: [0.0, 0.45, 1.0],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  NotificationsScreen
// ─────────────────────────────────────────────────────────────────────────────
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationScreenController>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          const _BackgroundGradient(),

          // Top-right glow
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    _accentGreen.withValues(alpha: 0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // ── Top bar ────────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: _buildTopBar(context, controller),
                ),

                // ── Action buttons row ─────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildActionRow(controller),
                ),

                const SizedBox(height: 16),

                // ── Content ────────────────────────────────────────────────
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const _LoadingWidget();
                    }

                    if (controller.errorMessage.value.isNotEmpty &&
                        controller.notifications.isEmpty) {
                      return _ErrorWidget(
                        message: controller.errorMessage.value,
                        onRetry: controller.fetchNotifications,
                      );
                    }

                    if (controller.notifications.isEmpty) {
                      return const _EmptyWidget();
                    }

                    return RefreshIndicator(
                      color: _accentGreen,
                      backgroundColor: const Color(0xFF0A2A10),
                      onRefresh: controller.fetchNotifications,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: controller.notifications.length + 1,
                        itemBuilder: (context, index) {
                          if (index == controller.notifications.length) {
                            return const SizedBox(height: 32);
                          }
                          final item = controller.notifications[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: _NotifCard(
                              item: item,
                              controller: controller,
                            ),
                          );
                        },
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Top bar ───────────────────────────────────────────────────────────────
  Widget _buildTopBar(
    BuildContext context,
    NotificationScreenController controller,
  ) {
    return Row(
      children: [
        // Back button
        GestureDetector(
          onTap: () => Navigator.of(context).maybePop(),
          child: _CircleButton(
            child: const Icon(
              Icons.chevron_left_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
        ),
        const SizedBox(width: 14),

        // Title
        const Expanded(
          child: Text(
            'Notifications',
            style: TextStyle(
              color: _textPrimary,
              fontSize: 26,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.3,
            ),
          ),
        ),

        // Unread badge
        Obx(() {
          if (controller.unreadCount == 0) return const SizedBox.shrink();
          return Container(
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _declineRed,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Text(
              '${controller.unreadCount}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          );
        }),

        // Settings gear
        GestureDetector(
          onTap: () => Get.toNamed(Routes.SETTING_NOTIFICATION),
          child: _CircleButton(
            child: const Icon(
              Icons.settings_outlined,
              color: Colors.white,
              size: 22,
            ),
          ),
        ),
      ],
    );
  }

  // ── Action row ────────────────────────────────────────────────────────────
  Widget _buildActionRow(NotificationScreenController controller) {
    return Obx(
      () => Row(
        children: [
          // Mark all read
          Expanded(
            child: _ActionChip(
              label: 'Mark All Read',
              icon: Icons.done_all_rounded,
              isLoading: controller.isMarkingAllRead.value,
              color: textWhite,
              onTap: controller.markAllAsRead,
            ),
          ),
          const SizedBox(width: 10),

          // Delete all
          Expanded(
            child: _ActionChip(
              label: 'Clear All',
              icon: Icons.delete_sweep_rounded,
              isLoading: controller.isDeletingAll.value,
              color: _declineRed,
              onTap: controller.deleteMyNotifications,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Notification Card
// ─────────────────────────────────────────────────────────────────────────────
class _NotifCard extends StatelessWidget {
  final NotificationModel item;
  final NotificationScreenController controller;

  const _NotifCard({required this.item, required this.controller});

  String get _emoji {
    switch (item.type) {
      case 'matchInvitation':
        return '🏆';
      case 'matchWinPayout':
        return '💰';
      case 'referralReward':
        return '🥇';
      case 'newItemAvailable':
        return '⚙️';
      case 'matchCompleted':
        return '🏆';
      case 'withdrawalProcessed':
        return '⏰';
      case 'friendRequest':
        return '🤝';
      case 'payment':
        return '💳';
      case 'system':
        return '🔔';
      default:
        return '📢';
    }
  }

  Color get _glowColor {
    switch (item.type) {
      case 'matchInvitation':
      case 'matchCompleted':
      case 'referralReward':
        return const Color(0xFFEFB000);
      case 'matchWinPayout':
      case 'withdrawalProcessed':
        return const Color(0xFF4CD137);
      case 'newItemAvailable':
        return const Color(0xFFAC45FF);
      case 'friendRequest':
        return const Color(0xFF2196F3);
      default:
        return _accentGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.markAsRead(item.id),
      child: Obx(
        () => _GradientBorderBox(
          borderRadius: _radius,
          borderColor: item.isRead ? null : _accentGreen, // highlight unread
          child: ClipRRect(
            borderRadius: _radius,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: _radius,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: item.isRead
                        ? [
                            Colors.black87.withValues(alpha: 0.10),
                            Colors.black87.withValues(alpha: 0.04),
                          ]
                        : [
                            _accentGreen.withValues(alpha: 0.10),
                            Colors.black87.withValues(alpha: 0.04),
                          ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Icon bubble
                      _NotifIconBubble(emoji: _emoji, glowColor: _glowColor),
                      const SizedBox(width: 14),

                      // Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item.title,
                                    style: const TextStyle(
                                      color: _textPrimary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.1,
                                    ),
                                  ),
                                ),
                                // Unread dot
                                if (!item.isRead)
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: _accentGreen,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Text(
                              item.message,
                              style: const TextStyle(
                                color: _textSecondary,
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                height: 1.4,
                              ),
                            ),

                            // Timestamp
                            const SizedBox(height: 6),
                            Text(
                              _formatTime(item.createdAt),
                              style: TextStyle(
                                color: _textSecondary.withValues(alpha: 0.60),
                                fontSize: 11,
                              ),
                            ),

                            // Match invitation actions
                            if (item.type == 'matchInvitation' &&
                                !item.isRead) ...[
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  _ActionButton(
                                    label: 'Accept',
                                    color: _acceptGreen,
                                    onTap: () => controller.markAsRead(item.id),
                                  ),
                                  const SizedBox(width: 10),
                                  _ActionButton(
                                    label: 'Decline',
                                    color: _declineRed,
                                    onTap: () {},
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),

                      // Loading indicator for this item
                      if (controller.isNotificationLoading(item.id))
                        const Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: _accentGreen,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Supporting widgets
// ─────────────────────────────────────────────────────────────────────────────
class _CircleButton extends StatelessWidget {
  final Widget child;

  const _CircleButton({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xFF5DCF00), Color(0xFF0B826F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: _accentGreen.withValues(alpha: 0.40),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _ActionChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isLoading;
  final Color color;
  final VoidCallback onTap;

  const _ActionChip({
    required this.label,
    required this.icon,
    required this.isLoading,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.50)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(strokeWidth: 2, color: color),
              )
            else
              Icon(icon, color: color, size: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotifIconBubble extends StatelessWidget {
  final String emoji;
  final Color glowColor;

  const _NotifIconBubble({required this.emoji, required this.glowColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: glowColor.withValues(alpha: 0.15),
        border: Border.all(
          color: glowColor.withValues(alpha: 0.30),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: glowColor.withValues(alpha: 0.25),
            blurRadius: 14,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Center(child: Text(emoji, style: const TextStyle(fontSize: 26))),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.40),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────
class _EmptyWidget extends StatelessWidget {
  const _EmptyWidget();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _accentGreen.withValues(alpha: 0.10),
              border: Border.all(color: _accentGreen.withValues(alpha: 0.30)),
            ),
            child: const Center(
              child: Text('🔔', style: TextStyle(fontSize: 40)),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No Notifications',
            style: TextStyle(
              color: _textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "You're all caught up!\nCheck back later.",
            textAlign: TextAlign.center,
            style: TextStyle(color: _textSecondary, fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }
}

// ── Loading state ─────────────────────────────────────────────────────────────
class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: 5,
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: _SkeletonCard(),
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _GradientBorderBox(
      borderRadius: _radius,
      child: Container(
        height: 88,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: _radius,
          color: Colors.white.withValues(alpha: 0.04),
        ),
        child: Row(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 14,
                    width: 140,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 12,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Error state ───────────────────────────────────────────────────────────────
class _ErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorWidget({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded, color: _declineRed, size: 60),
            const SizedBox(height: 16),
            const Text(
              'Something went wrong',
              style: TextStyle(
                color: _textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: _textSecondary,
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: onRetry,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF5DCF00), Color(0xFF0B826F)],
                  ),
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: _accentGreen.withValues(alpha: 0.40),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Text(
                  'Try Again',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Gradient Border Box
// ─────────────────────────────────────────────────────────────────────────────
class _GradientBorderBox extends StatelessWidget {
  final Widget child;
  final BorderRadius borderRadius;
  final Color? borderColor;

  const _GradientBorderBox({
    required this.child,
    required this.borderRadius,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GradientBorderPainter(
        borderRadius: borderRadius,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF5DCF00), Color(0xFF0B826F)],
        ),
        strokeWidth: 1.5,
      ),
      child: child,
    );
  }
}

class _GradientBorderPainter extends CustomPainter {
  final BorderRadius borderRadius;
  final LinearGradient gradient;
  final double strokeWidth;

  const _GradientBorderPainter({
    required this.borderRadius,
    required this.gradient,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rRect = borderRadius.toRRect(rect);
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawRRect(rRect, paint);
  }

  @override
  bool shouldRepaint(_GradientBorderPainter old) =>
      old.gradient != gradient || old.strokeWidth != strokeWidth;
}
