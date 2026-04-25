import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:glass_kit/glass_kit.dart';

import '../../../common/colors.dart';
import '../controllers/leader_board_screen_controller.dart';

// ─────────────────────────────────────────────
//  LEADERBOARD SCREEN
// ─────────────────────────────────────────────

class LeaderboardScreen extends GetView<LeaderboardController> {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<LeaderboardController>()) {
      Get.put(LeaderboardController());
    }

    return Scaffold(
      backgroundColor: bgGradientBottom,
      body: Stack(
        children: [
          // ── 1. Radial green background ───────────
          const _Background(),

          // ── 2. Trophy image — full-screen behind everything ──
          Column(
            children: [
              SizedBox(height: 50,),
              Image.asset(
                'assets/icons/ic_cup_leaderboard.png',
                fit: BoxFit.cover,
                height: 600,
                alignment: Alignment.topCenter,
              ),
            ],
          ),

          // ── 3. All UI on top ──────────────────────
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ──────────────────────
                _Header(onBack: () => Get.back()),
                const SizedBox(height: 20),

                // ── Tab bar ──────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Obx(() {
                    controller.count.value;
                    return _TabBar(ctrl: controller);
                  }),
                ),

                // ── Scrollable body ──────────────
                Expanded(
                  child: Obx(() {
                    controller.count.value;
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          // Space for the trophy to show through
                          const SizedBox(height: 280),

                          // ── Podium ─────────────
                          _PodiumSection(ctrl: controller),
                          const SizedBox(height: 20),

                          // ── Rank list (4+) ──────
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                            child: Column(
                              children: controller.restList
                                  .map(
                                    (p) => Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 12,
                                      ),
                                      child: _RankTile(player: p),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ],
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
}

// ─────────────────────────────────────────────
//  BACKGROUND
// ─────────────────────────────────────────────

class _Background extends StatelessWidget {
  const _Background();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0.0, -0.4),
          radius: 1.2,
          colors: [Color(0xFF1DB800), Color(0xFF0A6400), Color(0xFF053300)],
          stops: [0.0, 0.45, 1.0],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  HEADER
// ─────────────────────────────────────────────

class _Header extends StatelessWidget {
  final VoidCallback onBack;

  const _Header({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: ClipOval(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: backButtonColor.withOpacity(0.85),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1.2,
                    ),
                  ),
                  child: const Icon(
                    Icons.chevron_left_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          const Text(
            'Leaderboard',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  TAB BAR
// ─────────────────────────────────────────────

class _TabBar extends StatelessWidget {
  final LeaderboardController ctrl;

  const _TabBar({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) => GlassContainer(
        height: 52,
        width: constraints.maxWidth,
        borderRadius: BorderRadius.circular(50),
        blur: 18,
        color: Colors.black.withOpacity(0.22),
        borderGradient: LinearGradient(
          colors: [
            const Color(0xFFa2dba2).withValues(alpha: 0.75),
            const Color(0xFFa2dba2).withValues(alpha: 0.10),
            const Color(0xFFa2dba2).withValues(alpha: 0.10),
            const Color(0xFFa2dba2).withValues(alpha: 0.75),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.0, 0.15, 0.60, 1.0],
        ),
        borderWidth: 1.1,
        padding: const EdgeInsets.all(4),
        child: Row(
          children: List.generate(ctrl.tabs.length, (i) {
            final active = ctrl.selectedTab.value == i;
            return Expanded(
              child: GestureDetector(
                onTap: () => ctrl.selectTab(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    gradient: active
                        ? const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF5DCF00), Color(0xFF0B826F)],
                          )
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    ctrl.tabs[i],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  PODIUM SECTION
// ─────────────────────────────────────────────

class _PodiumSection extends StatelessWidget {
  final LeaderboardController ctrl;

  const _PodiumSection({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final p1 = ctrl.first;
    final p2 = ctrl.second;
    final p3 = ctrl.third;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (p2 != null)
            Expanded(child: _PodiumPlayer(player: p2, isFirst: false)),
          const SizedBox(width: 8),
          if (p1 != null)
            Expanded(flex: 2, child: _PodiumPlayer(player: p1, isFirst: true)),
          const SizedBox(width: 8),
          if (p3 != null)
            Expanded(child: _PodiumPlayer(player: p3, isFirst: false)),
        ],
      ),
    );
  }
}

class _PodiumPlayer extends StatelessWidget {
  final LeaderboardPlayer player;
  final bool isFirst;

  const _PodiumPlayer({required this.player, required this.isFirst});

  @override
  Widget build(BuildContext context) {
    final avatarRadius = isFirst ? 52.0 : 38.0;
    final nameFontSize = isFirst ? 16.0 : 13.0;
    final scoreFontSize = isFirst ? 13.0 : 11.0;
    final borderWidth = isFirst ? 3.5 : 2.5;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (isFirst)
          SvgPicture.asset(
            'assets/icons/ic_victory.svg',
            height: 36
          ),
        if (isFirst) const SizedBox(height: 4),

        Container(
          width: avatarRadius * 2 + borderWidth * 2,
          height: avatarRadius * 2 + borderWidth * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFF5DCF00), Color(0xFF0B826F)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: isFirst
                ? [
                    BoxShadow(
                      color: const Color(0xFF5DCF00).withOpacity(0.45),
                      blurRadius: 18,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          padding: EdgeInsets.all(borderWidth),
          child: CircleAvatar(
            radius: avatarRadius,
            backgroundColor: const Color(0xFF1A6B00),
            backgroundImage: player.avatarUrl.isNotEmpty
                ? NetworkImage(player.avatarUrl)
                : null,
            onBackgroundImageError: player.avatarUrl.isNotEmpty
                ? (_, __) {}
                : null,
          ),
        ),

        const SizedBox(height: 6),

        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFF5DCF00), Color(0xFF0B826F)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            '${player.rank}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),

        const SizedBox(height: 6),

        Text(
          player.name,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
            fontSize: nameFontSize,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          '${player.score}',
          style: TextStyle(
            color: Colors.white60,
            fontSize: scoreFontSize,
            fontWeight: FontWeight.w400,
          ),
        ),

        const SizedBox(height: 8),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  RANK TILE  (rank 4 onwards)
// ─────────────────────────────────────────────

class _RankTile extends StatelessWidget {
  final LeaderboardPlayer player;

  const _RankTile({required this.player});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) => GlassContainer(
        height: 72,
        width: constraints.maxWidth,
        borderRadius: BorderRadius.circular(20),
        blur: 14,
        color: Colors.black.withOpacity(0.22),
        borderGradient: LinearGradient(
          colors: [
            const Color(0xFFa2dba2).withValues(alpha: 0.50),
            const Color(0xFFa2dba2).withValues(alpha: 0.07),
            const Color(0xFFa2dba2).withValues(alpha: 0.07),
            const Color(0xFFa2dba2).withValues(alpha: 0.50),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.0, 0.20, 0.60, 1.0],
        ),
        borderWidth: 1.0,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            SizedBox(
              width: 28,
              child: Text(
                '${player.rank}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 10),
            CircleAvatar(
              radius: 24,
              backgroundColor: const Color(0xFF1A6B00),
              backgroundImage: player.avatarUrl.isNotEmpty
                  ? NetworkImage(player.avatarUrl)
                  : null,
              onBackgroundImageError: player.avatarUrl.isNotEmpty
                  ? (_, __) {}
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                player.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFFFFD600), Color(0xFFF59E0B)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Icon(
                    Icons.star_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  player.formattedScore,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
