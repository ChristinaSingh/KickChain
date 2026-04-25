import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kickchain/app/common/common_widgets.dart';
import 'package:kickchain/app/data/constants/image_constants.dart';

import '../../../common/colors.dart';
import '../../match_screens.dart';

class MatchSetupScreen extends StatelessWidget {
  const MatchSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGradientBottom,
      body: Stack(
        children: [
          // ── 1. Background gradient (bottom-most) ──
          const _BackgroundGradient(),

          // ── 2. Scrollable content ──────────────────
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 180),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Match Setup',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                            height: 1.1,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Review and start your match',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _MatchCard(
                      title: 'FUN COINS',
                      subtitle: 'Practice / Free Play',
                      gradientColors: const [funCoinsStart, funCoinsEnd],
                      orbColor: funCoinsOrb,
                      buttonLabel: 'Play with Fun Coins',
                      buttonIcon: _CoinIcon(),
                      buttonTextColor: funCoinsEnd,
                      onTap: () {
                        Get.to(FunCoinsMatchScreen());
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _MatchCard(
                      title: 'REAL STAKES',
                      subtitle: 'USDT / USDC',
                      gradientColors: const [realStakesStart, realStakesEnd],
                      orbColor: realStakesOrb,
                      buttonLabel: 'Play for Real',
                      buttonIcon: _DollarIcon(),
                      buttonTextColor: realStakesEnd,
                      onTap: () {},
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // ── 3. Soccer player image ─────────────────
          //    Positioned AFTER SafeArea so it renders on top of the scroll
          Positioned(
            top: 20,
            right: 0,
            child: SizedBox(
              height: 200,
              width: 200,
              child: CommonWidgets.appIcons(
                assetName: ImageConstants.imgFoodballPlayingGuys,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // ── 4. Back button — topmost layer ──────────
          //    Must come LAST in the Stack children so it sits above
          //    the SingleChildScrollView and receives tap events first.
          Positioned(
            top: 60,
            left: 20,
            child: Row(
              children: [
                InkWell(
                  onTap: () => Get.back(),
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
                const SizedBox(width: 10),
                const Text(
                  'Back',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
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
//  BACKGROUND GRADIENT
// ─────────────────────────────────────────────

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

// ─────────────────────────────────────────────
//  MATCH CARD  (glassmorphic gradient card)
// ─────────────────────────────────────────────

class _MatchCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Color> gradientColors;
  final Color orbColor;
  final String buttonLabel;
  final Widget buttonIcon;
  final Color buttonTextColor;
  final VoidCallback onTap;

  const _MatchCard({
    required this.title,
    required this.subtitle,
    required this.gradientColors,
    required this.orbColor,
    required this.buttonLabel,
    required this.buttonIcon,
    required this.buttonTextColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: CustomPaint(
            painter: _CardGlassBorderPainter(gradientColors.first),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(28, 32, 28, 28),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradientColors,
                ),
                boxShadow: [
                  BoxShadow(
                    color: gradientColors.first.withOpacity(0.4),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                  const BoxShadow(
                    color: cardShadowColor,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    right: -20,
                    top: -30,
                    child: _GlassOrb(color: orbColor),
                  ),
                  Positioned(
                    left: -30,
                    bottom: -20,
                    child: _GlassOrb(color: orbColor, size: 90, opacity: 0.25),
                  ),

                  Column(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                          shadows: [
                            Shadow(
                              color: Color(0x55000000),
                              offset: Offset(0, 2),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.3,
                        ),
                      ),

                      const SizedBox(height: 28),

                      _PillButton(
                        label: buttonLabel,
                        icon: buttonIcon,
                        textColor: buttonTextColor,
                        onTap: onTap,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  GLASS ORB
// ─────────────────────────────────────────────

class _GlassOrb extends StatelessWidget {
  final Color color;
  final double size;
  final double opacity;

  const _GlassOrb({required this.color, this.size = 130, this.opacity = 0.35});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(opacity),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  PILL BUTTON
// ─────────────────────────────────────────────

class _PillButton extends StatelessWidget {
  final String label;
  final Widget icon;
  final Color textColor;
  final VoidCallback onTap;

  const _PillButton({
    required this.label,
    required this.icon,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(width: 10),
            icon,
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  COIN ICON
// ─────────────────────────────────────────────

class _CoinIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 34,
      height: 22,
      child: Stack(
        children: [
          _SingleCoin(color: funCoinsEnd, left: 0),
          _SingleCoin(color: funCoinsStart, left: 12),
        ],
      ),
    );
  }
}

class _SingleCoin extends StatelessWidget {
  final Color color;
  final double left;

  const _SingleCoin({required this.color, required this.left});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      child: Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: Border.all(color: Colors.white, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            '\$',
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  DOLLAR ICON
// ─────────────────────────────────────────────

class _DollarIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: realStakesEnd,
        border: Border.all(color: Colors.white, width: 1.5),
      ),
      child: const Center(
        child: Text(
          '\$',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  CARD GLASS BORDER PAINTER
// ─────────────────────────────────────────────

class _CardGlassBorderPainter extends CustomPainter {
  final Color baseColor;

  const _CardGlassBorderPainter(this.baseColor);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(28),
    );

    final borderPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.white.withOpacity(0.55),
          Colors.white.withOpacity(0.0),
          Colors.black.withOpacity(0.25),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(rect.outerRect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    canvas.drawRRect(rect, borderPaint);

    final glossRect = Rect.fromLTWH(0, 0, size.width, size.height * 0.38);
    final glossPaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.white.withOpacity(0.28), Colors.white.withOpacity(0.0)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(glossRect);

    canvas.drawRRect(
      RRect.fromRectAndRadius(glossRect, const Radius.circular(28)),
      glossPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CardGlassBorderPainter old) =>
      old.baseColor != baseColor;
}