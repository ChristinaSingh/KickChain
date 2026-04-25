import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../common/colors.dart';
import '../controllers/deposit_screen_controller.dart';

// ─────────────────────────────────────────────
//  DEPOSIT SCREEN
// ─────────────────────────────────────────────

class DepositScreen extends GetView<DepositController> {
  const DepositScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<DepositController>()) {
      Get.put(DepositController());
    }

    return Scaffold(
      backgroundColor: bgGradientBottom,
      body: Stack(
        children: [
          // ── Full-screen background ─────────────
          const _Background(),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ────────────────────────
                _Header(onBack: () => Get.back()),
                const SizedBox(height: 24),

                // ── Scrollable body ───────────────
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Select Token ────────────
                        const Text(
                          'Select Token',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(height: 14),

                        // ── Token 2×2 Grid ──────────
                        Obx(() {
                          controller.count.value;
                          return _TokenGrid(controller: controller);
                        }),

                        const SizedBox(height: 20),

                        // ── QR Code card ────────────
                        Obx(() {
                          controller.count.value;
                          return _QrCard(controller: controller);
                        }),

                        const SizedBox(height: 16),

                        // ── Wallet Address card ──────
                        Obx(() {
                          controller.count.value;
                          return _WalletAddressCard(controller: controller);
                        }),
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
//  HEADER  (back button + title)
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
            'Deposit',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  TOKEN GRID  (2 × 2)
// ─────────────────────────────────────────────

class _TokenGrid extends StatelessWidget {
  final DepositController controller;

  const _TokenGrid({required this.controller});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2.1,
      ),
      itemCount: controller.tokens.length,
      itemBuilder: (_, i) => _TokenCard(
        token: controller.tokens[i],
        isSelected: controller.selectedTokenIndex.value == i,
        onTap: () => controller.selectToken(i),
      ),
    );
  }
}

class _TokenCard extends StatelessWidget {
  final TokenModel token;
  final bool isSelected;
  final VoidCallback onTap;

  const _TokenCard({
    required this.token,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: isSelected
                  ? const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF5DCF00), Color(0xFF0B826F)],
                    )
                  : LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.08),
                        Colors.white.withOpacity(0.04),
                      ],
                    ),
              border: Border.all(
                color: isSelected
                    ? Colors.white.withOpacity(0.35)
                    : const Color(0xFF3a7a3a).withOpacity(0.6),
                width: 1.2,
              ),
            ),
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        token.symbol,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        token.name,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.75),
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                // Network badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.black.withOpacity(0.35),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.15),
                      width: 0.8,
                    ),
                  ),
                  child: Text(
                    token.network,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
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
//  QR CODE CARD
// ─────────────────────────────────────────────

class _QrCard extends StatelessWidget {
  final DepositController controller;

  const _QrCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    final token = controller.selectedToken;

    return _ManualGlassCard(
      child: Column(
        children: [
          // White rounded container holding the QR
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: QrImageView(
                foregroundColor: Color(0xFF1D8C01),
                data: token.walletAddress,
                version: QrVersions.auto,
                backgroundColor: Colors.transparent,
                size: 220,
                // Green gradient foreground via embedded image widget
                eyeStyle: const QrEyeStyle(
                  eyeShape: QrEyeShape.square,
                  color: Color(0xFF1D8C01),
                ),
                dataModuleStyle: const QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square,
                  color: Color(0xFF1D8C01),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Caption
          Text(
            'Scan QR code to deposit ${token.symbol}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  WALLET ADDRESS CARD
// ─────────────────────────────────────────────

class _WalletAddressCard extends StatelessWidget {
  final DepositController controller;

  const _WalletAddressCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    final address = controller.selectedToken.walletAddress;

    return _ManualGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Wallet Address',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 16),

          // Address pill with copy icon
          GestureDetector(
            onTap: controller.copyAddress,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.30),
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(
                      color: const Color(0xFF3a7a3a).withOpacity(0.55),
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Copy icon
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.20),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.copy_rounded,
                          color: primaryColor,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Address text — truncated to fit
                      Expanded(
                        child: Text(
                          address,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.3,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  MANUAL GLASS CARD
//  ClipRRect + BackdropFilter — sizes to child content.
// ─────────────────────────────────────────────

class _ManualGlassCard extends StatelessWidget {
  final Widget child;

  const _ManualGlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: CustomPaint(
          painter: _GlassCardBorderPainter(),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Colors.black.withOpacity(0.28),
            ),
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
            child: child,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  GLASS CARD BORDER PAINTER
// ─────────────────────────────────────────────

class _GlassCardBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(24),
    );

    final borderPaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0x995DCF00), // green @ 60%
          Color(0x1A5DCF00), // green @ 10%
          Color(0x1A0B826F), // teal @ 10%
          Color(0x990B826F), // teal @ 60%
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0.0, 0.25, 0.75, 1.0],
      ).createShader(rect.outerRect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3;

    canvas.drawRRect(rect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
