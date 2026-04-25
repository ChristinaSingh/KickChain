import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kickchain/app/common/common_widgets.dart';
import 'package:kickchain/app/data/constants/icons_constant.dart';

import '../../../common/colors.dart';
import '../controllers/profile_screen_controller.dart';

// ── Inline color constants ────────────────────────────────────────────────
const Color _bgGradientTop = Color(0xFF1D8C01);
const Color _bgGradientBottom = Color(0xFF041A0B);
const Color _accentGreen = Color(0xFF5DCF00);

const Color _cardBg = Color(0x1AFFFFFF);

const Color _gradBorderTop = Color(0xFF5DCF00);
const Color _gradBorderBottom = Color(0xFF0B826F);
const Color _textWhite = Color(0xFFFFFFFF);
const Color _textGrey = Color(0xFFFFFFFF);

const Color _txPositive = Color(0xFF6EC21B);
const Color _txNegative = Color(0xFFE53935);

// ─────────────────────────────────────────────────────────────────────────────
// ProfileScreenView (Fancy UI + API data)
// ─────────────────────────────────────────────────────────────────────────────
class ProfileScreenView2 extends GetView<ProfileScreenController2> {
  const ProfileScreenView2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // ── Background gradient ──────────────────────────────────────────
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [_bgGradientTop, _bgGradientBottom],
              ),
            ),
          ),

          // ── Radial glow top-left ─────────────────────────────────────────
          Positioned(
            top: -60,
            left: -60,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [_accentGreen.withOpacity(0.20), Colors.transparent],
                ),
              ),
            ),
          ),

          // ── Football decoration — top right ──────────────────────────────
          Positioned(top: -10, right: -18, child: _FootballDecoration()),

          SafeArea(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }

              if (controller.errorMsg.value.isNotEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline,
                            color: Colors.white54, size: 48),
                        const SizedBox(height: 12),
                        Text(
                          controller.errorMsg.value,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 14),
                        GestureDetector(
                          onTap: controller.fetchProfile,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 10),
                            decoration: BoxDecoration(
                              color: glassBg,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: glassBorder),
                            ),
                            child: const Text(
                              'Retry',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        const SizedBox(height: 10),

                        // ── Page title ─────────────────────────────────────
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => Get.back(),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: glassBg,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: glassBorder),
                                ),
                                child: const Icon(Icons.arrow_back_rounded,
                                    color: Colors.white, size: 20),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Profile',
                              style: TextStyle(
                                color: _textWhite,
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // ── Profile card ───────────────────────────────────
                        _ProfileCard(controller: controller),
                        const SizedBox(height: 16),

                        // ── Personal info (from API) ───────────────────────
                        _SectionHeader(title: 'Personal Info'),
                        const SizedBox(height: 12),
                        _PersonalInfoCard(controller: controller),
                        const SizedBox(height: 24),

                        // ── Statistics ─────────────────────────────────────
                        _SectionHeader(title: 'Statistics'),
                        const SizedBox(height: 12),
                        _StatisticsGrid(controller: controller),
                        const SizedBox(height: 24),

                        // ── Achievements ───────────────────────────────────
                        _SectionHeader(title: 'Achievements'),
                        const SizedBox(height: 12),
                        _AchievementsGrid(controller: controller),
                        const SizedBox(height: 24),

                        // ── Recent Matches ─────────────────────────────────
                        _SectionHeader(title: 'Recent Matches'),
                        const SizedBox(height: 12),
                        _MatchList(controller: controller),
                        const SizedBox(height: 24),



                        const SizedBox(height: 32),
                      ]),
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Football decoration
// ─────────────────────────────────────────────────────────────────────────────
class _FootballDecoration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CommonWidgets.appIcons(
      assetName: IconConstants.icBackFoodbal,
      height: 260,
      width: 200,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Profile Card (API linked)
// ─────────────────────────────────────────────────────────────────────────────
class _ProfileCard extends StatelessWidget {
  final ProfileScreenController2 controller;
  const _ProfileCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    final u = controller.user.value;

    return _GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Avatar row ──────────────────────────────────────────────
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: _accentGreen, width: 2),
                    color: const Color(0xFF1A3A00),
                    image: (u?.avatar != null &&
                        u!.avatar!.startsWith('http'))
                        ? DecorationImage(
                      image: NetworkImage(u.avatar!),
                      fit: BoxFit.cover,
                    )
                        : null,
                  ),
                  child: (u?.avatar == null ||
                      (u!.avatar?.startsWith('http') != true))
                      ? const Icon(Icons.person_rounded,
                      color: Colors.white54, size: 30)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        u?.name ?? 'Player',
                        style: const TextStyle(
                          color: _textWhite,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        u?.email ?? '',
                        style: const TextStyle(
                          color: _textWhite,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Edit icon
                GestureDetector(
                  onTap: controller.onEditProfile,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _accentGreen.withOpacity(0.15),
                    ),
                    child: const Icon(
                      Icons.edit_rounded,
                      color: _textWhite,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ── XP row (demo values) ─────────────────────────────────────
            Obx(
                  () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Level ${controller.level.value}',
                    style: const TextStyle(
                      color: _textWhite,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '${controller.currentXP.value} / ${controller.maxXP.value} XP',
                    style: const TextStyle(
                      color: Color(0xFFEFB000),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),

            // ── XP progress bar ──────────────────────────────────────────
            Obx(
                  () => ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: controller.xpProgress,
                  minHeight: 8,
                  backgroundColor: const Color(0xFF1A3A00),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFFEFB000),
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
// Personal Info Card (from API)
// ─────────────────────────────────────────────────────────────────────────────
class _PersonalInfoCard extends StatelessWidget {
  final ProfileScreenController2 controller;
  const _PersonalInfoCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    final u = controller.user.value;

    String joined = '--';
    final iso = u?.createdAt;
    if (iso != null) {
      try {
        final d = DateTime.parse(iso);
        joined = '${d.day}/${d.month}/${d.year}';
      } catch (_) {
        joined = iso;
      }
    }

    return _GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _InfoRow(label: 'Name', value: u?.name ?? '--'),
            const SizedBox(height: 10),
            _InfoRow(label: 'Email', value: u?.email ?? '--'),
            const SizedBox(height: 10),
            _InfoRow(label: 'Phone', value: u?.phoneNumber ?? '--'),
            const SizedBox(height: 10),
            _InfoRow(
              label: 'Gender',
              value: (u?.gender ?? '--').capitalizeFirst ?? '--',
            ),
            const SizedBox(height: 10),
            _InfoRow(
              label: 'Verified',
              value: u?.isVerified == true ? 'Yes' : 'No',
            ),
            const SizedBox(height: 10),
            _InfoRow(label: 'Joined', value: joined),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: const TextStyle(
              color: _textGrey,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: _textWhite,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Section header
// ─────────────────────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: _textWhite,
        fontSize: 22,
        fontWeight: FontWeight.w900,
        letterSpacing: 0.2,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Statistics 2×2 grid
// ─────────────────────────────────────────────────────────────────────────────
class _StatisticsGrid extends StatelessWidget {
  final ProfileScreenController2 controller;
  const _StatisticsGrid({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final stats = [
        _StatItem(
          icon: '🏆',
          label: 'Total Matches',
          value: controller.totalMatches.value.toString(),
        ),
        _StatItem(
          icon: '⚪',
          label: 'Total Wins',
          value: controller.totalWins.value.toString(),
        ),
        _StatItem(
          icon: '📊',
          label: 'Win Rate',
          value: controller.winRate.value,
        ),
        _StatItem(
          icon: '🪙',
          label: 'Total Earnings',
          value: controller.totalEarnings.value,
        ),
      ];

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.25,
        ),
        itemCount: stats.length,
        itemBuilder: (_, i) => _StatCard(item: stats[i]),
      );
    });
  }
}

class _StatItem {
  final String icon, label, value;
  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });
}

class _StatCard extends StatelessWidget {
  final _StatItem item;
  const _StatCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(item.icon, style: const TextStyle(fontSize: 26)),
            const SizedBox(height: 6),
            Text(
              item.label,
              style: const TextStyle(color: _textGrey, fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              item.value,
              style: const TextStyle(
                color: _textWhite,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Achievements grid
// ─────────────────────────────────────────────────────────────────────────────
class _AchievementsGrid extends StatelessWidget {
  final ProfileScreenController2 controller;
  const _AchievementsGrid({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final list = controller.achievements.toList();
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.95,
        ),
        itemCount: list.length,
        itemBuilder: (_, i) => _AchievementCard(model: list[i]),
      );
    });
  }
}

class _AchievementCard extends StatelessWidget {
  final AchievementModel model;
  const _AchievementCard({required this.model});

  @override
  Widget build(BuildContext context) {
    return _GradientBorderBox(
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      gradientColors: model.unlocked
          ? const [_gradBorderTop, _gradBorderBottom]
          : const [Color(0x33FFFFFF), Color(0x11FFFFFF)],
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              color: _cardBg,
            ),
            child: Stack(
              children: [
                if (!model.unlocked)
                  const Positioned(
                    top: 8,
                    right: 8,
                    child: Icon(Icons.lock_rounded,
                        color: _textGrey, size: 14),
                  ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ColorFiltered(
                        colorFilter: model.unlocked
                            ? const ColorFilter.mode(
                          Colors.transparent,
                          BlendMode.multiply,
                        )
                            : const ColorFilter.matrix([
                          0.2126, 0.7152, 0.0722, 0, 0,
                          0.2126, 0.7152, 0.0722, 0, 0,
                          0.2126, 0.7152, 0.0722, 0, 0,
                          0, 0, 0, 1, 0,
                        ]),
                        child: Text(
                          model.emoji,
                          style: const TextStyle(fontSize: 34),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        model.label,
                        style: TextStyle(
                          color: model.unlocked ? _textWhite : _textGrey,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Recent Match list
// ─────────────────────────────────────────────────────────────────────────────
class _MatchList extends StatelessWidget {
  final ProfileScreenController2 controller;
  const _MatchList({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final matches = controller.recentMatches.toList();
      return Column(
        children: matches
            .map(
              (m) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _MatchRow(match: m),
          ),
        )
            .toList(),
      );
    });
  }
}

class _MatchRow extends StatelessWidget {
  final MatchModel match;
  const _MatchRow({required this.match});

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: match.won
                    ? const Color(0xFF2A5A00)
                    : const Color(0xFF5A0000),
              ),
              child: Center(
                child: match.won
                    ? const Text('🏆', style: TextStyle(fontSize: 18))
                    : const Icon(Icons.cancel_rounded,
                    color: _txNegative, size: 22),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    match.won ? 'Won' : 'Lost',
                    style: const TextStyle(
                      color: _textWhite,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    match.timeAgo,
                    style: const TextStyle(color: _textGrey, fontSize: 12),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  match.score,
                  style: const TextStyle(
                    color: _textWhite,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      match.coins >= 0 ? '+${match.coins}' : '${match.coins}',
                      style: TextStyle(
                        color: match.coins >= 0 ? _txPositive : _txNegative,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text('🪙', style: TextStyle(fontSize: 13)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reusable glass card
// ─────────────────────────────────────────────────────────────────────────────
class _GlassCard extends StatelessWidget {
  final Widget child;
  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.all(Radius.circular(20));
    return _GradientBorderBox(
      borderRadius: borderRadius,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.10),
                  Colors.white.withOpacity(0.04),
                ],
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Gradient border box painter
// ─────────────────────────────────────────────────────────────────────────────
class _GradientBorderBox extends StatelessWidget {
  final Widget child;
  final BorderRadius borderRadius;
  final List<Color> gradientColors;

  const _GradientBorderBox({
    required this.child,
    required this.borderRadius,
    this.gradientColors = const [_gradBorderTop, _gradBorderBottom],
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GradientBorderPainter(
        borderRadius: borderRadius,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
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

// ─────────────────────────────────────────────────────────────────────────────
// Edit Profile Screen (PATCH update profile)
// ─────────────────────────────────────────────────────────────────────────────
class EditProfileView extends GetView<ProfileScreenController2> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [_bgGradientTop, _bgGradientBottom],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: glassBg,
                            shape: BoxShape.circle,
                            border: Border.all(color: glassBorder),
                          ),
                          child: const Icon(Icons.arrow_back_rounded,
                              color: Colors.white, size: 20),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Edit Profile',
                        style: TextStyle(
                          color: _textWhite,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Obx(() {
                            final u = controller.user.value;
                            final file = controller.pickedAvatar.value;

                            ImageProvider? img;
                            if (file != null) {
                              img = FileImage(file);
                            } else if (u?.avatar != null &&
                                u!.avatar!.startsWith('http')) {
                              img = NetworkImage(u.avatar!);
                            }

                            return Column(
                              children: [
                                CircleAvatar(
                                  radius: 54,
                                  backgroundColor: glassBg,
                                  backgroundImage: img,
                                  child: img == null
                                      ? const Icon(Icons.person_rounded,
                                      size: 54, color: Colors.white38)
                                      : null,
                                ),
                                const SizedBox(height: 10),
                                GestureDetector(
                                  onTap: controller.pickAvatarFromGallery,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: glassBg,
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(color: glassBorder),
                                    ),
                                    child: const Text(
                                      'Change Avatar',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),

                          const SizedBox(height: 18),

                          _GlassCard(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  _EditField(
                                    label: 'Name',
                                    controller: controller.nameCtrl,
                                  ),
                                  const SizedBox(height: 12),
                                  _EditField(
                                    label: 'Email',
                                    controller: controller.emailCtrl,
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                  const SizedBox(height: 12),
                                  _EditField(
                                    label: 'Phone',
                                    controller: controller.phoneCtrl,
                                    keyboardType: TextInputType.phone,
                                  ),
                                  const SizedBox(height: 12),

                                  // Gender dropdown
                                  Obx(() {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.06),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            color: Colors.white12),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: controller.gender.value,
                                          dropdownColor:
                                          const Color(0xFF0B2A12),
                                          iconEnabledColor: Colors.white70,
                                          items: const [
                                            DropdownMenuItem(
                                                value: 'male',
                                                child: Text('Male',
                                                    style: TextStyle(
                                                        color:
                                                        Colors.white))),
                                            DropdownMenuItem(
                                                value: 'female',
                                                child: Text('Female',
                                                    style: TextStyle(
                                                        color:
                                                        Colors.white))),
                                            DropdownMenuItem(
                                                value: 'other',
                                                child: Text('Other',
                                                    style: TextStyle(
                                                        color:
                                                        Colors.white))),
                                          ],
                                          onChanged: (v) {
                                            if (v != null) {
                                              controller.gender.value = v;
                                            }
                                          },
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          Obx(() {
                            return GestureDetector(
                              onTap: controller.isUpdating.value
                                  ? null
                                  : controller.updateProfile,
                              child: Container(
                                height: 48,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      _accentGreen,
                                      _accentGreen.withOpacity(0.7),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Center(
                                  child: controller.isUpdating.value
                                      ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white),
                                  )
                                      : const Text(
                                    'Save Changes',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),

                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EditField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  const _EditField({
    required this.label,
    required this.controller,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
              color: _textGrey,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            )),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withOpacity(0.06),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.white12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.white12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _accentGreen.withOpacity(0.8)),
            ),
          ),
        ),
      ],
    );
  }
}