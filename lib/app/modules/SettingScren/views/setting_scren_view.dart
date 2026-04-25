import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kickchain/app/routes/app_pages.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../common/colors.dart';
import '../../../common/common_widgets.dart';
import '../../../data/constants/icons_constant.dart';
import '../../../data/constants/string_constants.dart';
import '../controllers/setting_scren_controller.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingScrenController controller = Get.put(SettingScrenController());
  // ── Toggle state ─────────────────────────────────────────────────────────
  bool _soundEffects = true;
  bool _backgroundMusic = true;
  bool _showAds = true;
  bool _autoMatch = true;
  bool _vibration = false;

  // ── Language ─────────────────────────────────────────────────────────────
  String _selectedLanguage = StringConstants.usEnglish;
  final List<String> _languages = [
    'us English',
    'Español',
    'Français',
    'Deutsch',
    'Português',
  ];

  // ── Helpers ──────────────────────────────────────────────────────────────
  static const _radius = BorderRadius.all(Radius.circular(20));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // ── Gradient background ──────────────────────────────────────────
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

          // Subtle radial glow top-right
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [accentGreen.withOpacity(0.18), Colors.transparent],
                ),
              ),
            ),
          ),

          // ── Safe-area scrollable content ─────────────────────────────────
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const SizedBox(height: 12),

                      // ── Top bar ───────────────────────────────────────
                      _buildTopBar(),
                      const SizedBox(height: 24),

                      // ── Audio Settings ────────────────────────────────
                      _buildAudioCard(),
                      const SizedBox(height: 16),

                      // ── Language ──────────────────────────────────────
                      _buildLanguageCard(),
                      const SizedBox(height: 16),

                      // ── Game Preferences ─────────────────────────────
                      _buildGamePreferencesCard(),
                      const SizedBox(height: 16),

                      // ── Support & Information ─────────────────────────
                      _buildSupportCard(),
                      const SizedBox(height: 32),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Top bar ───────────────────────────────────────────────────────────────
  Widget _buildTopBar() {
    return Row(
      children: [
        Text(
          StringConstants.screenTitle,
          style: const TextStyle(
            color: textPrimary,
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.3,
          ),
        ),
        const Spacer(),
        _LogOutButton(
          onTap: () {
            LogoutDialog.show(
              onConfirm: () async {
                await controller.logout();
              },
            );
          },
        ),
      ],
    );
  }

  // ── Glass card wrapper ────────────────────────────────────────────────────
  Widget _glassCard({required Widget child}) {
    return GradientBorderBox(
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
                  Colors.black87.withOpacity(0.10),
                  Colors.black87.withOpacity(0.04),
                ],
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  // ── Section header ────────────────────────────────────────────────────────
  Widget _sectionHeader(String title, {VoidCallback? onTapSectionHeader}) {
    return InkWell(
      onTap: onTapSectionHeader,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Text(
          title,
          style: const TextStyle(
            color: textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }

  // ── Divider ───────────────────────────────────────────────────────────────
  Widget _divider() => const Padding(
    padding: EdgeInsets.symmetric(horizontal: 16),
    child: Divider(color: divider, height: 1, thickness: 1),
  );

  // ── Toggle row ────────────────────────────────────────────────────────────
  Widget _toggleRow({
    required String icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          if (icon != "")
            CommonWidgets.appIconsSvg(
              assetName: icon,
              height: 24.px,
              width: 24.px,
            ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(color: textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
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

  // ── Audio Settings card ───────────────────────────────────────────────────
  Widget _buildAudioCard() {
    return _glassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            StringConstants.audioSettings,
            onTapSectionHeader: () {
              // Handle tap on section header (e.g. show tooltip)
            },
          ),
          _toggleRow(
            icon: IconConstants.icSoundEffects,
            title: StringConstants.soundEffects,
            subtitle: StringConstants.soundEffectsSubtitle,
            value: _soundEffects,
            onChanged: (v) => setState(() => _soundEffects = v),
          ),
          _divider(),
          _toggleRow(
            icon: IconConstants.icBackgroundMusic,
            title: StringConstants.backgroundMusic,
            subtitle: StringConstants.backgroundMusicSubtitle,
            value: _backgroundMusic,
            onChanged: (v) => setState(() => _backgroundMusic = v),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  // ── Language card ─────────────────────────────────────────────────────────
  Widget _buildLanguageCard() {
    return _glassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(StringConstants.language),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: _LanguageDropdown(
              value: _selectedLanguage,
              items: _languages,
              onChanged: (v) {
                if (v != null) setState(() => _selectedLanguage = v);
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── Game Preferences card ─────────────────────────────────────────────────
  Widget _buildGamePreferencesCard() {
    return _glassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(StringConstants.gamePreferences),
          _toggleRow(
            icon: "",
            title: StringConstants.showAds,
            subtitle: StringConstants.showAdsSubtitle,
            value: _showAds,
            onChanged: (v) => setState(() => _showAds = v),
          ),
          _divider(),
          _toggleRow(
            icon: "",
            title: StringConstants.autoMatch,
            subtitle: StringConstants.autoMatchSubtitle,
            value: _autoMatch,
            onChanged: (v) => setState(() => _autoMatch = v),
          ),
          _divider(),
          _toggleRow(
            icon: "",
            title: StringConstants.vibration,
            subtitle: StringConstants.vibrationSubtitle,
            value: _vibration,
            onChanged: (v) => setState(() => _vibration = v),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  // ── Support card ──────────────────────────────────────────────────────────
  Widget _buildSupportCard() {
    return _glassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            StringConstants.supportInfo,
            onTapSectionHeader: () {
              // Handle tap on section header (e.g. show tooltip)
            },
          ),
          _supportRow(
            StringConstants.helpFaq,
            onTapSectionHeader: () {
            Get.toNamed(Routes.FAQ_SCREEN);
            },
          ),
          _divider(),
          _supportRow(
            StringConstants.termsOfService,
            onTapSectionHeader: () {
              Get.toNamed(Routes.TERMS_CONDITIONS);
            },
          ),
          _divider(),
          _supportRow(
            StringConstants.privacyPolicy,

            onTapSectionHeader: () {
              Get.toNamed(Routes.PRIVACY_P_OLICY);
            },
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _supportRow(String title, {VoidCallback? onTapSectionHeader}) {
    return InkWell(
      onTap: onTapSectionHeader,
      borderRadius: _radius,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: chevron, size: 22),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Log Out Button
// ─────────────────────────────────────────────────────────────────────────────
class _LogOutButton extends StatelessWidget {
  final VoidCallback onTap;

  const _LogOutButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: logoutBtn,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: logoutBtn.withOpacity(0.45),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.logout_rounded, color: Colors.white, size: 18),
            SizedBox(width: 6),
            Text(
              StringConstants.logOut,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
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

// ─────────────────────────────────────────────────────────────────────────────
//  Icon Box (emoji icon with green tinted background circle)
// ─────────────────────────────────────────────────────────────────────────────
class _IconBox extends StatelessWidget {
  final String emoji;

  const _IconBox({required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: accentGreen.withOpacity(0.18),
      ),
      child: Center(child: Text(emoji, style: const TextStyle(fontSize: 16))),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Language Dropdown
// ─────────────────────────────────────────────────────────────────────────────
class _LanguageDropdown extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _LanguageDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cardBorder, width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: const Color(0xFF145200),
          iconEnabledColor: accentGreen,
          icon: const Icon(Icons.arrow_drop_down_rounded, size: 24),
          style: const TextStyle(
            color: textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          items: items
              .map(
                (lang) => DropdownMenuItem(
                  value: lang,
                  child: Row(
                    children: [
                      CommonWidgets.appIconsSvg(
                        assetName: IconConstants.icEnglish,
                        height: 24.px,
                        width: 24.px,
                      ),
                      const SizedBox(width: 10),
                      Text(lang),
                    ],
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

/// ─────────────────────────────────────────────────────────────────────────────
///  FootballToggle
///
///  A custom iOS-style toggle whose thumb is a football (⚽) icon.
///  Drop in `customIcon` to replace the football with any widget you like.
/// ─────────────────────────────────────────────────────────────────────────────
class FootballToggle extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  /// Replace the football emoji with any widget — e.g. an Image.asset.
  /// Defaults to the ⚽ emoji text widget.
  final Widget? customIcon;

  /// Width of the pill track.
  final double trackWidth;

  /// Height of the pill track.
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

  void _handleTap() {
    widget.onChanged?.call(!widget.value);
  }

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
              // subtle inner shadow
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
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

/// The circular thumb with a football icon inside.
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
            color: Colors.black.withOpacity(0.30),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child:
            customIcon ??
            // ── Default: football emoji ──────────────────────
            // To swap, pass your own widget via `customIcon`,
            // e.g. Image.asset('assets/football.png', width: size * 0.72)
            Text('⚽', style: TextStyle(fontSize: size * 0.62)),
      ),
    );
  }
}

class GradientBorderBox extends StatelessWidget {
  final Widget child;
  final BorderRadius borderRadius;
  final List<Color> gradientColors;
  final double borderWidth;

  const GradientBorderBox({
    super.key,
    required this.child,
    required this.borderRadius,
    this.gradientColors = const [gradBorderTop, gradBorderBottom],
    this.borderWidth = 1.5,
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
        strokeWidth: borderWidth,
      ),
      child: child,
    );
  }
}

// ── Painter ──────────────────────────────────────────────────────────────────
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


class LogoutDialog extends StatelessWidget {
  final Future<void> Function() onConfirm;

  const LogoutDialog({super.key, required this.onConfirm});

  static void show({required Future<void> Function() onConfirm}) {
    Get.dialog(
      LogoutDialog(onConfirm: onConfirm),
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.65),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: _DialogContent(onConfirm: onConfirm),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  DIALOG CONTENT
// ─────────────────────────────────────────────

class _DialogContent extends StatelessWidget {
  final Future<void> Function() onConfirm;
  const _DialogContent({required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(28, 28, 28, 32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: const Color(0xFF0D2A0D),
        border: Border.all(
          color: Colors.white.withOpacity(0.07),
          width: 1.0,
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -8,
            left: -8,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFE53935),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE53935).withOpacity(0.40),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              const Text(
                'Log Out',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Are you sure want to log out?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        Get.back();
                        await onConfirm();
                      },
                      child: Container(
                        height: 58,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF72E000),
                              Color(0xFF1DB800),
                              Color(0xFF0A8C00),
                            ],
                            stops: [0.0, 0.55, 1.0],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF5DCF00).withOpacity(0.40),
                              blurRadius: 18,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Yes',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        height: 58,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: Colors.transparent,
                          border: Border.all(
                            color: const Color(0xFF5DCF00),
                            width: 1.8,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'No',
                          style: TextStyle(
                            color: Color(0xFF5DCF00),
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}