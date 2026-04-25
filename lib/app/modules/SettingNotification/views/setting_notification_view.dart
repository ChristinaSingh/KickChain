// lib/app/modules/setting_notification/views/setting_notification_view.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/colors.dart';
import '../../../common/common_widgets.dart';
import '../../../data/constants/icons_constant.dart';
import '../controllers/setting_notification_controller.dart';

// ── Color constants ───────────────────────────────────────────────────────────
const Color _accentGreen = Color(0xFF5DCF00);
const Color _gradBorderTop = Color(0xFF5DCF00);
const Color _gradBorderBottom = Color(0xFF0B826F);
const Color _textPrimary = Color(0xFFFFFFFF);
const Color _divider = Color(0x1AFFFFFF);

// ─────────────────────────────────────────────────────────────────────────────
//  NotificationSettingsScreen
// ─────────────────────────────────────────────────────────────────────────────
class NotificationSettingsScreen extends GetView<SettingNotificationController> {
  const NotificationSettingsScreen({super.key});

  static const _radius = BorderRadius.all(Radius.circular(20));

  @override
  Widget build(BuildContext context) {
    // Ensure controller is registered
    Get.put(SettingNotificationController());

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // ── Gradient background ────────────────────────────────────────────
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.0, -0.3),
                radius: 1.2,
                colors: [
                  Color(0xFF2E7D00),
                  Color(0xFF145200),
                  Color(0xFF061A00),
                ],
                stops: [0.0, 0.55, 1.0],
              ),
            ),
          ),

          // ── Subtle radial glow top-right ───────────────────────────────────
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

          // ── Safe-area scrollable content ───────────────────────────────────
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const SizedBox(height: 12),

                      // ── Top bar ──────────────────────────────────────────
                      _buildTopBar(context),
                      const SizedBox(height: 28),

                      // ── Loading / Error / Content ────────────────────────
                      Obx(() {
                        if (controller.isLoading.value) {
                          return _buildLoadingState();
                        }

                        if (controller.hasError.value) {
                          return _buildErrorState();
                        }

                        return _buildContent();
                      }),

                      const SizedBox(height: 32),
                    ]),
                  ),
                ),
              ],
            ),
          ),

          // ── Updating overlay indicator ─────────────────────────────────────
          Obx(() {
            if (!controller.isUpdating.value) return const SizedBox.shrink();
            return Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.75),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _accentGreen.withValues(alpha: 0.4),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: _accentGreen,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Saving changes…',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // ── Top bar ─────────────────────────────────────────────────────────────────
  Widget _buildTopBar(BuildContext context) {
    return Row(
      children: [
        // Back button
        GestureDetector(
          onTap: () => Navigator.of(context).maybePop(),
          child: Container(
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
            child: const Icon(
              Icons.chevron_left_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
        ),
        const SizedBox(width: 14),

        // Title
        const Text(
          'Notification Settings',
          style: TextStyle(
            color: _textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.3,
          ),
        ),

        const Spacer(),

        // Refresh icon
        GestureDetector(
          onTap: controller.fetchNotificationSettings,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.08),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.15),
                width: 1,
              ),
            ),
            child: const Icon(
              Icons.refresh_rounded,
              color: Colors.white70,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  // ── Loading State ───────────────────────────────────────────────────────────
  Widget _buildLoadingState() {
    return _glassCard(
      child: Column(
        children: List.generate(5, (index) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Row(
                  children: [
                    // Shimmer text placeholder
                    Expanded(
                      child: Container(
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Shimmer toggle placeholder
                    Container(
                      width: 56,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ],
                ),
              ),
              if (index < 4)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(color: _divider, height: 1, thickness: 1),
                ),
            ],
          );
        }),
      ),
    );
  }

  // ── Error State ─────────────────────────────────────────────────────────────
  Widget _buildErrorState() {
    return _glassCard(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.wifi_off_rounded,
              color: Colors.red.shade300,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load settings',
              style: TextStyle(
                color: Colors.red.shade300,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Obx(() => Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.55),
                fontSize: 13,
              ),
            )),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: controller.fetchNotificationSettings,
              style: ElevatedButton.styleFrom(
                backgroundColor: _accentGreen,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text(
                'Retry',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Main Content ────────────────────────────────────────────────────────────
  Widget _buildContent() {
    return _glassCard(
      child: Obx(
            () => Column(
          children: [
            _toggleRow(
              icon: Icons.sports_soccer_rounded,
              title: 'Match Invites',
              subtitle: 'Get notified when invited to a match',
              value: controller.matchInvites.value,
              onChanged: controller.onMatchInvitesChanged,
            ),
            _dividerWidget(),
            _toggleRow(
              icon: Icons.emoji_events_rounded,
              title: 'Match Results',
              subtitle: 'Receive results after each match ends',
              value: controller.matchResults.value,
              onChanged: controller.onMatchResultsChanged,
            ),
            _dividerWidget(),
            _toggleRow(
              icon: Icons.account_balance_wallet_rounded,
              title: 'Payouts',
              subtitle: 'Alerts for earnings and withdrawals',
              value: controller.payouts.value,
              onChanged: controller.onPayoutsChanged,
            ),
            _dividerWidget(),
            _toggleRow(
              icon: Icons.card_giftcard_rounded,
              title: 'Referral Rewards',
              subtitle: 'Track your referral bonuses',
              value: controller.referralRewards.value,
              onChanged: controller.onReferralRewardsChanged,
            ),
            _dividerWidget(),
            _toggleRow(
              icon: Icons.system_update_alt_rounded,
              title: 'System Updates',
              subtitle: 'App updates and announcements',
              value: controller.systemUpdates.value,
              onChanged: controller.onSystemUpdatesChanged,
            ),
          ],
        ),
      ),
    );
  }

  // ── Toggle Row ──────────────────────────────────────────────────────────────
  Widget _toggleRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          // Icon badge
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  _accentGreen.withValues(alpha: 0.25),
                  const Color(0xFF0B826F).withValues(alpha: 0.25),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: _accentGreen.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Icon(icon, color: _accentGreen, size: 20),
          ),
          const SizedBox(width: 14),

          // Labels
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.1,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.50),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Football toggle
          FootballToggle(
            value: value,
            onChanged: onChanged,
            customIcon: CommonWidgets.appIcons(
              assetName: IconConstants.icFootball,
            ),
          ),
        ],
      ),
    );
  }

  // ── Glass card wrapper ───────────────────────────────────────────────────────
  Widget _glassCard({required Widget child}) {
    return _GradientBorderBox(
      borderRadius: _radius,
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
                colors: [
                  Colors.black87.withValues(alpha: 0.10),
                  Colors.black87.withValues(alpha: 0.04),
                ],
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  // ── Divider ──────────────────────────────────────────────────────────────────
  Widget _dividerWidget() => const Padding(
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: Divider(color: _divider, height: 1, thickness: 1),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
//  FootballToggle
// ─────────────────────────────────────────────────────────────────────────────
class FootballToggle extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Widget? customIcon;
  final double trackWidth;
  final double trackHeight;

  const FootballToggle({
    super.key,
    required this.value,
    this.onChanged,
    this.customIcon,
    this.trackWidth = 56,
    this.trackHeight = 30,
  });

  @override
  State<FootballToggle> createState() => _FootballToggleState();
}

class _FootballToggleState extends State<FootballToggle>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _slideAnim;
  late Animation<Color?> _colorAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
      value: widget.value ? 1.0 : 0.0,
    );
    _slideAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
    _colorAnim = ColorTween(
      begin: toggleInactiveTrack,
      end: primaryColor,
    ).animate(_ctrl);
  }

  @override
  void didUpdateWidget(FootballToggle old) {
    super.didUpdateWidget(old);
    if (widget.value != old.value) {
      widget.value ? _ctrl.forward() : _ctrl.reverse();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _handleTap() => widget.onChanged?.call(!widget.value);

  @override
  Widget build(BuildContext context) {
    final double thumbSize = widget.trackHeight - 4;
    final double travelDist = widget.trackWidth - thumbSize - 4;

    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) {
          return Container(
            width: widget.trackWidth,
            height: widget.trackHeight,
            decoration: BoxDecoration(
              color: _colorAnim.value,
              borderRadius: BorderRadius.circular(widget.trackHeight / 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                  spreadRadius: -1,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Stack(
                children: [
                  Positioned(
                    left: 2 + _slideAnim.value * travelDist,
                    top: 0,
                    bottom: 0,
                    child: _ThumbWidget(
                      size: thumbSize,
                      customIcon: widget.customIcon,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ThumbWidget extends StatelessWidget {
  final double size;
  final Widget? customIcon;

  const _ThumbWidget({required this.size, this.customIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.30),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: customIcon ??
            Text('⚽', style: TextStyle(fontSize: size * 0.62)),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  GradientBorderBox & Painter
// ─────────────────────────────────────────────────────────────────────────────
class _GradientBorderBox extends StatelessWidget {
  final Widget child;
  final BorderRadius borderRadius;

  const _GradientBorderBox({
    required this.child,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GradientBorderPainter(
        borderRadius: borderRadius,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_gradBorderTop, _gradBorderBottom],
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