import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kickchain/app/data/constants/string_constants.dart';

import '../../../common/colors.dart';
import '../../../common/common_widgets.dart';
import '../../../common/glass_container.dart';
import '../../../common/responsive_size.dart';
import '../../../common/small_coin_ustd_siwitch.dart';
import '../../../common/text_styles.dart';
import '../../../data/constants/icons_constant.dart';
import '../../../data/constants/image_constants.dart';
import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGradientBottom,
      floatingActionButton: _NotificationFab(
        onTap: controller.onNotificationTap,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Stack(
        children: [
          const _BackgroundGradient(),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  HeaderRow(controller: controller),
                  const SizedBox(height: 32),
                  CommonWidgets.appIcons(
                    assetName: ImageConstants.imgKeyChainLogo,
                    height: ResponsiveSize.height(context, 125),
                    width: ResponsiveSize.width(context, 133),
                  ),
                  const SizedBox(height: 20),
                  Text('Soccer Clash', style: MyTextStyle.homeTitle),
                  const SizedBox(height: 6),
                  Text(
                    'Choose your game mode',
                    style: MyTextStyle.homeSubtitle,
                  ),
                  const SizedBox(height: 32),
                  _ActionCard(
                    label: 'Play Match',
                    icon: Icons.play_circle_filled_rounded,
                    gradientColors: const [playMatchStart, playMatchEnd],
                    onTap: controller.onPlayMatch,
                  ),
                  const SizedBox(height: 16),
                  _ActionCard(
                    label: 'Shop',
                    icon: Icons.storefront_rounded,
                    gradientColors: const [shopStart, shopEnd],
                    onTap: controller.onShop,
                  ),
                  const SizedBox(height: 16),
                  _ActionCard(
                    label: 'Leaderboard',
                    icon: Icons.emoji_events_rounded,
                    gradientColors: const [leaderboardStart, leaderboardEnd],
                    onTap: controller.onLeaderboard,
                  ),
                  const SizedBox(height: 16),
                  _ActionCard(
                    label: 'Daily Missions',
                    icon: Icons.track_changes_rounded,
                    gradientColors: const [
                      dailyMissionsStart,
                      dailyMissionsEnd,
                    ],
                    onTap: controller.onDailyMissions,
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Background Gradient ─────────────────────────
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

class HeaderRow extends StatelessWidget {
  final HomeController controller;

  const HeaderRow({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoggedIn = controller.isLoggedIn.value;
      final avatarUrl = controller.userAvatar.value;
      final userName = controller.userName.value;

      return Row(
        children: [
          // ══════════════════════════════════════════════════════════════════
          //  AVATAR WITH GLASSMORPHISM
          // ══════════════════════════════════════════════════════════════════
          GradientGlassAvatar(
            imageUrl: avatarUrl,
            name: userName,
            radius: 28,
            onTap: controller.onProfileTap,
            gradientColors: isLoggedIn
                ? [primaryColor, primaryColor2]
                : [Colors.orange, Colors.deepOrange],
            isOnline: isLoggedIn,
            showBadge: !isLoggedIn,
            badge: !isLoggedIn ? _buildAnonymousBadge() : null,
          ),

          const SizedBox(width: 12),

          // ══════════════════════════════════════════════════════════════════
          //  WELCOME TEXT
          // ══════════════════════════════════════════════════════════════════
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isLoggedIn ? 'Welcome,' : 'Hey there,',
                  style: MyTextStyle.welcomeTitle,
                ),
                Text(
                  _formatName(userName),
                  style: MyTextStyle.welcomeSubtitle,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // ══════════════════════════════════════════════════════════════════
          //  COIN PILL / LOGIN BUTTON
          // ══════════════════════════════════════════════════════════════════
          if (isLoggedIn)
            _CoinPill(balance: controller.coinBalance.value)
          else
            // Login pill for anonymous
            GestureDetector(
              onTap: () => Get.toNamed(Routes.L_O_G_I_N_SCREEN),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [playMatchStart, playMatchEnd],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.login_rounded, color: Colors.white, size: 16),
                    SizedBox(width: 6),
                    Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      );
    });
  }

  // ── Anonymous Badge ──────────────────────────────────────────────────────
  Widget _buildAnonymousBadge() {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.orange, Colors.deepOrange],
        ),
        shape: BoxShape.circle,
        border: Border.all(color: bgGradientBottom, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.5),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: const Icon(Icons.question_mark, size: 10, color: Colors.white),
    );
  }

  // ── Format Name (Capitalize First Letter) ────────────────────────────────
  String _formatName(String name) {
    if (name.isEmpty) return 'Guest';

    return name
        .split(' ')
        .map((word) {
          if (word.isEmpty) return '';
          return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
        })
        .join(' ');
  }
}

// ── Coin Pill ───────────────────────────────────
class _CoinPill extends StatelessWidget {
  final int balance;

  const _CoinPill({required this.balance});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: CustomPaint(
          painter: _GlassBorderPainter(),
          child: Container(
            height: 35,
            width: 150,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: coinBarBg,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                CommonWidgets.appIcons(
                  assetName: IconConstants.icCoinIcon,
                  height: 18,
                  width: 18,
                ),
                const SizedBox(width: 5),
                Text(_formatCoin(balance), style: MyTextStyle.coinValue),
                const Spacer(),
                CoinUsdtSwitch(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatCoin(int v) {
    if (v >= 1000) {
      final s = v.toString();
      final buf = StringBuffer();
      int count = 0;
      for (int i = s.length - 1; i >= 0; i--) {
        if (count > 0 && count % 3 == 0) buf.write(',');
        buf.write(s[i]);
        count++;
      }
      return buf.toString().split('').reversed.join();
    }
    return v.toString();
  }
}

class _GlassBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(30),
    );
    final borderPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0x66FFFFFF), Color(0x00FFFFFF), Color(0x66000000)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(rect.outerRect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawRRect(rect, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// ── Action Card ─────────────────────────────────
class _ActionCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final List<Color> gradientColors;
  final VoidCallback onTap;

  const _ActionCard({
    required this.label,
    required this.icon,
    required this.gradientColors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 68,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: gradientColors,
          ),
          boxShadow: const [
            BoxShadow(
              color: cardShadowColor,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 26),
            const SizedBox(width: 10),
            Text(label, style: MyTextStyle.cardLabel),
          ],
        ),
      ),
    );
  }
}

// ── Notification FAB ────────────────────────────
class _NotificationFab extends StatelessWidget {
  final VoidCallback onTap;

  const _NotificationFab({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Spacer(),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [notifGradientStart, notifGradientEnd],
              ),
              border: Border.all(color: notifBorder, width: 4),
              boxShadow: const [
                BoxShadow(
                  color: cardShadowColor,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.notifications_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(height: 130),
        ],
      ),
    );
  }
}

// lib/common/widgets/gradient_glass_avatar.dart

class GradientGlassAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? filePath;
  final String? assetPath;
  final String name;
  final double radius;
  final VoidCallback? onTap;
  final List<Color>? gradientColors;
  final double borderWidth;
  final bool showBadge;
  final Widget? badge;
  final bool isOnline;

  const GradientGlassAvatar({
    super.key,
    this.imageUrl,
    this.filePath,
    this.assetPath,
    this.name = 'User',
    this.radius = 28,
    this.onTap,
    this.gradientColors,
    this.borderWidth = 3,
    this.showBadge = false,
    this.badge,
    this.isOnline = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = gradientColors ?? [primaryColor, primaryColor2];

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          // Gradient Border Container
          Container(
            width: (radius + borderWidth) * 2,
            height: (radius + borderWidth) * 2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: colors,
              ),
              boxShadow: [
                BoxShadow(
                  color: colors[0].withOpacity(0.4),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: radius * 2,
                height: radius * 2,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: bgGradientBottom,
                ),
                child: ClipOval(child: _buildAvatarContent()),
              ),
            ),
          ),

          // Online Indicator
          if (isOnline)
            Positioned(
              bottom: 2,
              right: 2,
              child: Container(
                width: radius * 0.4,
                height: radius * 0.4,
                decoration: BoxDecoration(
                  color: successGreenColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: bgGradientBottom, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: successGreenColor.withOpacity(0.5),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),

          // Custom Badge
          if (showBadge && badge != null)
            Positioned(bottom: 0, right: 0, child: badge!),
        ],
      ),
    );
  }

  Widget _buildAvatarContent() {
    // Network Image
    if (imageUrl != null &&
        imageUrl!.isNotEmpty &&
        (imageUrl!.startsWith('http://') || imageUrl!.startsWith('https://'))) {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        fit: BoxFit.cover,
        width: radius * 2,
        height: radius * 2,
        placeholder: (context, url) => _buildLoadingAvatar(),
        errorWidget: (context, url, error) => _buildInitialsAvatar(),
      );
    }

    // File Image
    if (filePath != null && filePath!.isNotEmpty) {
      final file = File(filePath!);
      if (file.existsSync()) {
        return Image.file(
          file,
          fit: BoxFit.cover,
          width: radius * 2,
          height: radius * 2,
          errorBuilder: (_, __, ___) => _buildInitialsAvatar(),
        );
      }
    }

    // Asset Image
    if (assetPath != null && assetPath!.isNotEmpty) {
      return Image.asset(
        assetPath!,
        fit: BoxFit.cover,
        width: radius * 2,
        height: radius * 2,
        errorBuilder: (_, __, ___) => _buildInitialsAvatar(),
      );
    }

    // Default: Initials
    return _buildInitialsAvatar();
  }

  Widget _buildInitialsAvatar() {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryColor.withOpacity(0.3),
            primaryColor2.withOpacity(0.5),
          ],
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.2),
                Colors.white.withOpacity(0.05),
              ],
            ),
          ),
          child: Center(
            child: Text(
              _getInitials(),
              style: TextStyle(
                color: Colors.white,
                fontSize: radius * 0.65,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 6,
                    offset: const Offset(1, 2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingAvatar() {
    return Container(
      width: radius * 2,
      height: radius * 2,
      color: glassBg,
      child: Center(
        child: SizedBox(
          width: radius * 0.5,
          height: radius * 0.5,
          child: const CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
          ),
        ),
      ),
    );
  }

  String _getInitials() {
    if (name.isEmpty) return '?';

    final words = name.trim().split(RegExp(r'\s+'));

    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    } else if (words.length == 1 && words[0].isNotEmpty) {
      return words[0][0].toUpperCase();
    }

    return '?';
  }
}
