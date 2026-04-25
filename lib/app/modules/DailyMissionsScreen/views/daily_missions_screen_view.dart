import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/colors.dart';
import '../controllers/daily_missions_screen_controller.dart';

// ─────────────────────────────────────────────
//  DAILY MISSIONS SCREEN
// ─────────────────────────────────────────────

class DailyMissionsScreen extends GetView<DailyMissionsController> {
  const DailyMissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<DailyMissionsController>()) {
      Get.put(DailyMissionsController());
    }

    return Scaffold(
      backgroundColor: bgGradientBottom,
      body: Stack(
        children: [
          // ── 1. Radial green background ──────────
          const _Background(),

          // ── 2. Football art / illustration ──────
          //       Put your image asset here.
          //       Falls back to a painted soccer ball.
          Positioned(top: -30, right: -40, child: _FootballArtDecoration()),

          // ── 3. All UI ───────────────────────────
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ──────────────────────
                _Header(onBack: () => Get.back()),
                const SizedBox(height: 12),

                // ── Scrollable body ─────────────
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        const SizedBox(height: 60),

                        // ── Main glass card ─────
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: _MainGlassCard(ctrl: controller),
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),

                // ── Sticky bottom timer ──────────
                Obx(() => _ResetTimerBar(timer: controller.resetTimer.value)),
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
          center: Alignment(0.3, -0.65),
          radius: 1.3,
          colors: [Color(0xFF1DB800), Color(0xFF0A6400), Color(0xFF053300)],
          stops: [0.0, 0.45, 1.0],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  FOOTBALL ART DECORATION  (top-right)
// ─────────────────────────────────────────────

class _FootballArtDecoration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 340,
      height: 400,
      child: Image.asset(
        'assets/icons/ic_back_foodbal.png', // ← replace with your image
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => _SoccerBallPainter(),
      ),
    );
  }
}

/// Painted fallback soccer ball shown when asset is missing.
class _SoccerBallPainter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _BallPainter());
  }
}

class _BallPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.6, size.height * 0.4);
    final radius = size.width * 0.32;

    // Green glow
    canvas.drawCircle(
      center,
      radius * 1.5,
      Paint()
        ..color = const Color(0xFF5DCF00).withOpacity(0.18)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30),
    );

    // White ball
    canvas.drawCircle(center, radius, Paint()..color = Colors.white);

    // Black pentagon patches
    final patchPaint = Paint()..color = const Color(0xFF1A1A1A);
    final patches = [
      center,
      center + Offset(radius * 0.5, -radius * 0.55),
      center + Offset(-radius * 0.55, -radius * 0.4),
      center + Offset(radius * 0.55, radius * 0.45),
      center + Offset(-radius * 0.4, radius * 0.55),
    ];
    for (final p in patches) {
      _drawHexagon(canvas, p, radius * 0.22, patchPaint);
    }

    // Border
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = const Color(0xFF333333)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  void _drawHexagon(Canvas canvas, Offset center, double r, Paint paint) {
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = (i * 60 - 30) * 3.14159 / 180;
      final x = center.dx + r * cos(angle);
      final y = center.dy + r * sin(angle);
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  double cos(double r) => (r >= 0 && r < 6.3)
      ? [
          1,
          0.866,
          0.5,
          0,
          -0.5,
          -0.866,
          -1,
          -0.866,
          -0.5,
          0,
          0.5,
          0.866,
        ][((r / (3.14159 / 6)).round() % 12)].toDouble()
      : 0;

  double sin(double r) => cos(r - 3.14159 / 2);

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
            'Daily Missions',
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
//  MAIN GLASS CARD  (contains title + all missions)
// ─────────────────────────────────────────────

class _MainGlassCard extends StatelessWidget {
  final DailyMissionsController ctrl;

  const _MainGlassCard({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
        child: CustomPaint(
          painter: _CardBorderPainter(),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              color: Colors.black.withOpacity(0.32),
            ),
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
            child: Column(
              children: [
                // ── Title ──────────────────────
                const Text(
                  'Daily Missions',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Complete missions to earn rewards!',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 24),

                // ── Mission cards ───────────────
                ...ctrl.missions.map(
                  (m) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Obx(() {
                      ctrl.count.value;
                      return _MissionCard(
                        mission: m,
                        onClaim: () => ctrl.claimReward(m),
                      );
                    }),
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

// ─────────────────────────────────────────────
//  MISSION CARD
// ─────────────────────────────────────────────

class _MissionCard extends StatelessWidget {
  final MissionModel mission;
  final VoidCallback onClaim;

  const _MissionCard({required this.mission, required this.onClaim});

  @override
  Widget build(BuildContext context) {
    final state = mission.state.value;
    final isClaimed = state == MissionState.claimed;
    final isClaimable = state == MissionState.claimable;
    final showProgress = state == MissionState.inProgress;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.black.withOpacity(isClaimed ? 0.15 : 0.25),
            border: Border.all(
              color: isClaimed
                  ? Colors.white.withOpacity(0.08)
                  : const Color(0xFF3a7a3a).withOpacity(0.55),
              width: 1.1,
            ),
          ),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top row: title + reward ───────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mission.title,
                          style: TextStyle(
                            color: isClaimed ? Colors.white54 : Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          mission.description,
                          style: TextStyle(
                            color: isClaimed ? Colors.white38 : Colors.white70,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Coin + reward
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _CoinBadge(),
                      const SizedBox(width: 5),
                      Text(
                        '${mission.reward}',
                        style: TextStyle(
                          color: isClaimed ? Colors.white38 : Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // ── Progress bar (in-progress only) ──
              if (showProgress) ...[
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Progress',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${mission.rxCurrent.value}/${mission.total}',
                      style: const TextStyle(
                        color: Color(0xFF72E000),
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _ProgressBar(progress: mission.progress),
              ],

              // ── Claim button (claimable) ──────
              if (isClaimable) ...[
                const SizedBox(height: 16),
                _ClaimButton(onTap: onClaim),
              ],

              // ── Claimed state ─────────────────
              if (isClaimed) ...[
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFF5DCF00),
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Reward Claimed',
                      style: TextStyle(
                        color: const Color(0xFF5DCF00).withOpacity(0.85),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  PROGRESS BAR
// ─────────────────────────────────────────────

class _ProgressBar extends StatelessWidget {
  final double progress;

  const _ProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        return Stack(
          children: [
            // Track
            Container(
              height: 7,
              width: constraints.maxWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white.withOpacity(0.12),
              ),
            ),
            // Fill
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOut,
              height: 7,
              width: constraints.maxWidth * progress,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                  colors: [Color(0xFF72E000), Color(0xFF0B826F)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF5DCF00).withOpacity(0.55),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
//  CLAIM BUTTON
// ─────────────────────────────────────────────

class _ClaimButton extends StatelessWidget {
  final VoidCallback onTap;

  const _ClaimButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFF72E000), Color(0xFF3AAA00)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF5DCF00).withOpacity(0.40),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.emoji_events_rounded, color: Colors.white, size: 22),
            SizedBox(width: 8),
            Text(
              'Claim Reward',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  GOLD COIN BADGE
// ─────────────────────────────────────────────

class _CoinBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFFFFD600), Color(0xFFF59E0B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Icon(Icons.star_rounded, color: Colors.white, size: 15),
    );
  }
}

// ─────────────────────────────────────────────
//  RESET TIMER BAR  (sticky bottom)
// ─────────────────────────────────────────────

class _ResetTimerBar extends StatelessWidget {
  final String timer;

  const _ResetTimerBar({required this.timer});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.20),
            border: Border(
              top: BorderSide(color: Colors.white.withOpacity(0.08), width: 1),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.timer_rounded,
                color: Color(0xFFFFD600),
                size: 18,
              ),
              const SizedBox(width: 8),
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Missions reset in ',
                      style: TextStyle(
                        color: Color(0xFFFFD600),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: timer,
                      style: const TextStyle(
                        color: Color(0xFFFFD600),
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  MAIN GLASS CARD BORDER PAINTER
// ─────────────────────────────────────────────

class _CardBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(28),
    );

    canvas.drawRRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          colors: [
            Colors.white.withOpacity(0.30),
            Colors.white.withOpacity(0.05),
            Colors.white.withOpacity(0.05),
            Colors.white.withOpacity(0.18),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.0, 0.25, 0.75, 1.0],
        ).createShader(rect.outerRect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.3,
    );

    // Top gloss
    final glossRect = Rect.fromLTWH(0, 0, size.width, size.height * 0.18);
    canvas.drawRRect(
      RRect.fromRectAndRadius(glossRect, const Radius.circular(28)),
      Paint()
        ..shader = LinearGradient(
          colors: [
            Colors.white.withOpacity(0.14),
            Colors.white.withOpacity(0.0),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(glossRect),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
