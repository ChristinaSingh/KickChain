import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kickchain/app/data/apis/api_models/faq_response_model.dart';
import 'package:kickchain/app/data/constants/icons_constant.dart';

import '../../../common/colors.dart';
import '../controllers/faq_screen_controller.dart';

// ─────────────────────────────────────────────
//  FAQ SCREEN
// ─────────────────────────────────────────────

class FaqScreen extends GetView<FaqController> {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<FaqController>()) {
      Get.put(FaqController());
    }

    return Scaffold(
      backgroundColor: bgGradientBottom,
      body: Stack(
        children: [
          // ── Background ─────────────────────────
          const _Background(),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ──────────────────────
                _Header(onBack: () => Get.back()),

                // ── Scrollable body ─────────────
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        // ── Hero illustration ────
                        _HeroIllustration(),

                        // ── Title block ──────────
                        const _TitleBlock(),

                        const SizedBox(height: 24),

                        // ── FAQ accordion ────────
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                          child: Obx(() {
                            if (controller.isLoading.value) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 50),
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            }
                            if (controller.faqs.isEmpty) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 50),
                                  child: Text(
                                    'No FAQs found.',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                ),
                              );
                            }
                            return Column(
                              children: List.generate(
                                controller.faqs.length,
                                (i) => Padding(
                                  padding: const EdgeInsets.only(bottom: 14),
                                  child: _FaqTile(
                                    faq: controller.faqs[i],
                                    isExpanded:
                                        controller.expandedIndex.value == i,
                                    onTap: () => controller.toggleFaq(i),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
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
          center: Alignment(0.0, -0.5),
          radius: 1.2,
          colors: [Color(0xFF1DB800), Color(0xFF0A6400), Color(0xFF053300)],
          stops: [0.0, 0.45, 1.0],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  HEADER  (back button + FAQ label)
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
          // Glassmorphic back button
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
            'FAQ',
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
//  HERO ILLUSTRATION
//  Replace the asset path with your actual image.
// ─────────────────────────────────────────────

class _HeroIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      width: double.infinity,
      child: Image.asset(
        IconConstants.icFAQ, // ← replace with your asset path
        fit: BoxFit.contain,
      ),
    );
  }
}

/// Fallback placeholder — shown only when the asset is missing.
class _FaqGuyPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer glow circle
          Container(
            width: 230,
            height: 230,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.04),
            ),
          ),
          // Question marks floating around
          ..._buildFloatingIcons(),
          // Person icon
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF2AABEE).withOpacity(0.85),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2AABEE).withOpacity(0.4),
                  blurRadius: 20,
                ),
              ],
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 56),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFloatingIcons() {
    final items = [
      _FloatItem(
        text: '?',
        color: const Color(0xFF1DB800),
        x: -90,
        y: -30,
        size: 32,
      ),
      _FloatItem(
        text: '?',
        color: const Color(0xFF2AABEE),
        x: 90,
        y: -60,
        size: 28,
      ),
      _FloatItem(
        text: '?',
        color: const Color(0xFFFFD600),
        x: 85,
        y: 50,
        size: 24,
      ),
      _FloatItem(
        text: '?',
        color: const Color(0xFF1DB800),
        x: -70,
        y: 60,
        size: 20,
      ),
      _FloatItem(
        text: 'i',
        color: const Color(0xFF2AABEE),
        x: 110,
        y: 0,
        size: 22,
      ),
    ];
    return items
        .map(
          (item) => Transform.translate(
            offset: Offset(item.x, item.y),
            child: Text(
              item.text,
              style: TextStyle(
                color: item.color,
                fontSize: item.size,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        )
        .toList();
  }
}

class _FloatItem {
  final String text;
  final Color color;
  final double x, y, size;
  const _FloatItem({
    required this.text,
    required this.color,
    required this.x,
    required this.y,
    required this.size,
  });
}

// ─────────────────────────────────────────────
//  TITLE BLOCK  ("FAQ" + subtitle)
// ─────────────────────────────────────────────

class _TitleBlock extends StatelessWidget {
  const _TitleBlock();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Text(
            'FAQ',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 38,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Most common question about our services',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  FAQ TILE  (glassmorphic expandable accordion)
// ─────────────────────────────────────────────

class _FaqTile extends StatelessWidget {
  final FaqData faq;
  final bool isExpanded;
  final VoidCallback onTap;

  const _FaqTile({
    required this.faq,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: CustomPaint(
            painter: _FaqTileBorderPainter(isExpanded: isExpanded),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                // Slightly lighter when expanded
                color: isExpanded
                    ? Colors.black.withOpacity(0.30)
                    : Colors.black.withOpacity(0.20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Question row ───────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 16, 18),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            faq.question ?? '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              height: 1.3,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Animated chevron
                        AnimatedRotation(
                          turns: isExpanded ? 0.5 : 0.0,
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isExpanded
                                  ? accentGreen.withOpacity(0.20)
                                  : Colors.white.withOpacity(0.08),
                            ),
                            child: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: isExpanded ? accentGreen : Colors.white70,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Answer (animated expand) ───
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 250),
                    crossFadeState: isExpanded
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    firstChild: Column(
                      children: [
                        // Divider
                        Container(
                          height: 1,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.0),
                                Colors.white.withOpacity(0.20),
                                Colors.white.withOpacity(0.0),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
                          child: Text(
                            faq.answer ?? '',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              height: 1.55,
                            ),
                          ),
                        ),
                      ],
                    ),
                    secondChild: const SizedBox.shrink(),
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
//  FAQ TILE BORDER PAINTER
// ─────────────────────────────────────────────

class _FaqTileBorderPainter extends CustomPainter {
  final bool isExpanded;
  const _FaqTileBorderPainter({required this.isExpanded});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(18),
    );

    final borderPaint = Paint()
      ..shader = LinearGradient(
        colors: isExpanded
            ? [
                const Color(0xBB5DCF00), // bright green when open
                const Color(0x225DCF00),
                const Color(0x220B826F),
                const Color(0xBB0B826F),
              ]
            : [
                const Color(0x665DCF00),
                const Color(0x111DB800),
                const Color(0x110B826F),
                const Color(0x660B826F),
              ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: const [0.0, 0.30, 0.70, 1.0],
      ).createShader(rect.outerRect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3;

    canvas.drawRRect(rect, borderPaint);

    // Top gloss highlight
    final glossRect = Rect.fromLTWH(0, 0, size.width, size.height * 0.4);
    canvas.drawRRect(
      RRect.fromRectAndRadius(glossRect, const Radius.circular(18)),
      Paint()
        ..shader = LinearGradient(
          colors: [
            Colors.white.withOpacity(0.08),
            Colors.white.withOpacity(0.0),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(glossRect),
    );
  }

  @override
  bool shouldRepaint(covariant _FaqTileBorderPainter old) =>
      old.isExpanded != isExpanded;
}
