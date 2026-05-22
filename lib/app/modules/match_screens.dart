import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../common/colors.dart';
import '../common/common_widgets.dart';
import '../common/wallet_service.dart';
import '../data/constants/icons_constant.dart';
import 'StakeController.dart';

// ─────────────────────────────────────────────
//  FUN COINS MATCH SCREEN
// ─────────────────────────────────────────────

class FunCoinsMatchScreen extends StatefulWidget {
  const FunCoinsMatchScreen({super.key});

  @override
  State<FunCoinsMatchScreen> createState() => _FunCoinsMatchScreenState();
}

class _FunCoinsMatchScreenState extends State<FunCoinsMatchScreen> {
  late final StakeController ctrl;

  @override
  void initState() {
    super.initState();
    ctrl = Get.put(StakeController());

    // Initialize wallet service with context after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initWalletService();
    });
  }

  Future<void> _initWalletService() async {
    if (kIsWeb) return;
    try {
      final ws = WalletService.to;
      if (!ws.isAppKitReady) {
        await ws.initAppKit(context);
      }
    } catch (e) {
      debugPrint('[FunCoinsMatchScreen] Wallet init error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // ── Background ──────────────────────
          const _BackgroundGradient(),

          // ── Content ─────────────────────────
          SafeArea(
            child: Column(
              children: [
                _TopBar(ctrl: ctrl),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 22),
                        const Text(
                          'Fun Coins Matches',
                          style: TextStyle(
                            color: textWhite,
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Select your stake amount to get started',
                          style: TextStyle(
                            color: textWhite,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 18),
                        _MatchTypeToggle(ctrl: ctrl),
                        const SizedBox(height: 24),
                        _FreePracticeCard(ctrl: ctrl),
                        const SizedBox(height: 22),
                        Obx(() {
                          ctrl.count.value;
                          return _StakeTiers(ctrl: ctrl, isFunCoins: true);
                        }),
                        const SizedBox(height: 22),
                        const _TablePreviewCard(),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Sticky Start Match button ────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _StartMatchButton(ctrl: ctrl),
          ),

          // ── Full-screen loading overlay ──────
          Obx(() {
            if (!ctrl.isLoading.value) return const SizedBox.shrink();
            return _FullScreenLoader(message: ctrl.loadingMessage.value);
          }),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  REAL MONEY MATCH SCREEN
// ─────────────────────────────────────────────

class RealMoneyMatchScreen extends StatefulWidget {
  const RealMoneyMatchScreen({super.key});

  @override
  State<RealMoneyMatchScreen> createState() => _RealMoneyMatchScreenState();
}

class _RealMoneyMatchScreenState extends State<RealMoneyMatchScreen> {
  late final StakeController ctrl;

  @override
  void initState() {
    super.initState();
    ctrl = Get.put(StakeController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initWalletService();
    });
  }

  Future<void> _initWalletService() async {
    if (kIsWeb) return;
    try {
      final ws = WalletService.to;
      if (!ws.isAppKitReady) {
        await ws.initAppKit(context);
      }
    } catch (e) {
      debugPrint('[RealMoneyMatchScreen] Wallet init error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const _BackgroundGradient(),
          SafeArea(
            child: Column(
              children: [
                _TopBar(ctrl: ctrl, isRealMoney: true),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 22),
                        const Text(
                          'Real Money Matches',
                          style: TextStyle(
                            color: textWhite,
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Select your stake amount to compete for real rewards',
                          style: TextStyle(
                            color: textGrey,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 18),
                        _MatchTypeToggle(ctrl: ctrl),
                        const SizedBox(height: 24),
                        Obx(() {
                          ctrl.count.value;
                          return _StakeTiers(ctrl: ctrl, isFunCoins: false);
                        }),
                        const SizedBox(height: 22),
                        const _TablePreviewCard(),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _StartMatchButton(ctrl: ctrl),
          ),
          Obx(() {
            if (!ctrl.isLoading.value) return const SizedBox.shrink();
            return _FullScreenLoader(message: ctrl.loadingMessage.value);
          }),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  FULL SCREEN LOADER
// ─────────────────────────────────────────────
class _FullScreenLoader extends StatelessWidget {
  final String message;

  const _FullScreenLoader({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            decoration: BoxDecoration(
              color: const Color(0xFF0D3D0A),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: primaryColor.withOpacity(0.4),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.2),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _PulsingLoader(),
                const SizedBox(height: 24),
                Text(
                  message.isNotEmpty ? message : 'Please wait...',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: textWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Setting up your match',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 13,
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

class _PulsingLoader extends StatefulWidget {
  const _PulsingLoader();

  @override
  State<_PulsingLoader> createState() => _PulsingLoaderState();
}

class _PulsingLoaderState extends State<_PulsingLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _opacityAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _scaleAnim = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _opacityAnim = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnim.value,
          child: Opacity(
            opacity: _opacityAnim.value,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [playMatchStart, playMatchEnd],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: playMatchStart.withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.sports_soccer_rounded,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
//  SHARED WIDGETS
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

class _TopBar extends StatelessWidget {
  final StakeController ctrl;
  final bool isRealMoney;

  const _TopBar({required this.ctrl, this.isRealMoney = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: backButtonColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chevron_left_rounded,
                color: Colors.white,
                size: 26,
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'Back',
            style: TextStyle(
              color: textWhite,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Obx(
            () => _CoinPill(
              balance: ctrl.coinBalance.value,
              isRealMoney: isRealMoney,
            ),
          ),
        ],
      ),
    );
  }
}

class _CoinPill extends StatelessWidget {
  final int balance;
  final bool isRealMoney;

  const _CoinPill({required this.balance, this.isRealMoney = false});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          height: 35,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: coinBarBg,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CommonWidgets.appIcons(
                assetName: IconConstants.icCoinIcon,
                height: 18,
                width: 18,
              ),
              const SizedBox(width: 5),
              Text(
                _formatCoin(balance),
                style: const TextStyle(
                  color: textWhite,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 6),
              const CoinUsdtSwitch(),
            ],
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

class CoinUsdtSwitch extends StatefulWidget {
  const CoinUsdtSwitch({super.key});

  @override
  State<CoinUsdtSwitch> createState() => _CoinUsdtSwitchState();
}

class _CoinUsdtSwitchState extends State<CoinUsdtSwitch> {
  bool isUsdt = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => isUsdt = !isUsdt),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 51,
        height: 22,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          gradient: isUsdt
              ? const LinearGradient(
                  colors: [Color(0xFF8AD9C6), Color(0xFF0F7B63)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : const LinearGradient(
                  colors: [Color(0xFFFFD54F), Color(0xFFFFA000)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: isUsdt ? 6 : null,
              right: isUsdt ? null : 6,
              child: Text(
                isUsdt ? 'USDT' : 'Coins',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 6,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            AnimatedAlign(
              duration: const Duration(milliseconds: 250),
              alignment: isUsdt ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 18,
                height: 18,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFEAEAEA),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MatchTypeToggle extends StatelessWidget {
  final StakeController ctrl;

  const _MatchTypeToggle({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: ctrl.selectRandomMatch,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 42,
                decoration: BoxDecoration(
                  gradient: ctrl.isRandomMatch.value
                      ? const LinearGradient(
                          colors: [playMatchStart, playMatchEnd],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: ctrl.isRandomMatch.value ? null : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                  border: ctrl.isRandomMatch.value
                      ? null
                      : Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.people_rounded, color: Colors.white, size: 18),
                    SizedBox(width: 6),
                    Text(
                      'Random Match',
                      style: TextStyle(
                        color: textWhite,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onTap: ctrl.selectInviteFriend,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 42,
                decoration: BoxDecoration(
                  gradient: !ctrl.isRandomMatch.value
                      ? const LinearGradient(
                          colors: [playMatchStart, playMatchEnd],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: !ctrl.isRandomMatch.value ? null : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                  border: !ctrl.isRandomMatch.value
                      ? null
                      : Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_add_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Invite Friend',
                      style: TextStyle(
                        color: textWhite,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FreePracticeCard extends StatelessWidget {
  final StakeController ctrl;

  const _FreePracticeCard({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Free / Practice',
          style: TextStyle(
            color: textWhite,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: ctrl.onFreeMatch,
          child: Container(
            height: 62,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [funCoinsStart, funCoinsEnd],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFFFC940),
                      ),
                      child: const Center(
                        child: Text('🪙', style: TextStyle(fontSize: 14)),
                      ),
                    ),
                    Positioned(
                      left: -8,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFFFB300),
                        ),
                        child: const Center(
                          child: Text('🪙', style: TextStyle(fontSize: 14)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 18),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '0 Coins',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Free Match',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    'Play',
                    style: TextStyle(
                      color: funCoinsEnd,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StakeTiers extends StatelessWidget {
  final StakeController ctrl;
  final bool isFunCoins;

  const _StakeTiers({required this.ctrl, required this.isFunCoins});

  static const _vip = 'HIGH / VIP';

  @override
  Widget build(BuildContext context) {
    final stakes = isFunCoins ? ctrl.funCoinStakes : ctrl.realMoneyStakes;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: stakes.entries.map((entry) {
        final tier = entry.key;
        final amounts = entry.value;
        final isVip = tier == _vip;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  tier,
                  style: TextStyle(
                    color: isVip ? leaderboardStart : textWhite,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (isVip) ...[
                  const SizedBox(width: 6),
                  const Text('👑', style: TextStyle(fontSize: 14)),
                ],
              ],
            ),
            const SizedBox(height: 10),
            _StakeGrid(
              ctrl: ctrl,
              tier: tier,
              amounts: amounts,
              isVip: isVip,
              isFunCoins: isFunCoins,
            ),
            const SizedBox(height: 20),
          ],
        );
      }).toList(),
    );
  }
}

class _StakeGrid extends StatelessWidget {
  final StakeController ctrl;
  final String tier;
  final List<String> amounts;
  final bool isVip;
  final bool isFunCoins;

  const _StakeGrid({
    required this.ctrl,
    required this.tier,
    required this.amounts,
    required this.isVip,
    required this.isFunCoins,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final rows = <Widget>[];
      for (int i = 0; i < amounts.length; i += 2) {
        final hasSecond = i + 1 < amounts.length;
        rows.add(
          Row(
            children: [
              Expanded(
                child: _StakeButton(
                  ctrl: ctrl,
                  tier: tier,
                  index: i,
                  label: amounts[i],
                  isVip: isVip,
                  isFunCoins: isFunCoins,
                  isSelected: ctrl.isSelected(tier, i),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: hasSecond
                    ? _StakeButton(
                        ctrl: ctrl,
                        tier: tier,
                        index: i + 1,
                        label: amounts[i + 1],
                        isVip: isVip,
                        isFunCoins: isFunCoins,
                        isSelected: ctrl.isSelected(tier, i + 1),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        );
        if (i + 2 < amounts.length) rows.add(const SizedBox(height: 10));
      }
      return Column(children: rows);
    });
  }
}

class _StakeButton extends StatelessWidget {
  final StakeController ctrl;
  final String tier;
  final int index;
  final String label;
  final bool isVip;
  final bool isFunCoins;
  final bool isSelected;

  const _StakeButton({
    required this.ctrl,
    required this.tier,
    required this.index,
    required this.label,
    required this.isVip,
    required this.isFunCoins,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => ctrl.selectStake(tier, index, context),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 56,
        decoration: BoxDecoration(
          color: isSelected
              ? (isVip
                    ? const Color(0xFFEFB000).withOpacity(0.18)
                    : primaryColor.withOpacity(0.18))
              : const Color(0xFF0D3D0A).withAlpha(40),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? (isVip ? leaderboardStart : primaryColor)
                : isVip
                ? leaderboardStart.withOpacity(0.6)
                : Colors.white.withAlpha(90),
            width: isSelected ? 1.8 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isFunCoins)
              const Text('🪙', style: TextStyle(fontSize: 15))
            else
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.15),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: const Center(
                  child: Text(
                    '\$',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            const SizedBox(width: 7),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? (isVip ? leaderboardStart : primaryColor)
                    : textWhite,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TablePreviewCard extends StatelessWidget {
  const _TablePreviewCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF0D3D0A),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.08), width: 1),
      ),
      child: Column(
        children: [
          const Text(
            'Table Preview',
            style: TextStyle(
              color: textWhite,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          _FootballPitchPreview(),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: () => Get.toNamed('/customize-table'),
            child: const Text(
              'Customize Table & Skins →',
              style: TextStyle(
                color: leaderboardStart,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FootballPitchPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 130,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CustomPaint(painter: _PitchPainter()),
      ),
    );
  }
}

class _PitchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final grassPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF2ECC40), Color(0xFF1A9928)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), grassPaint);

    final stripePaint = Paint()..color = const Color(0x1A000000);
    for (int i = 0; i < 6; i++) {
      if (i % 2 == 0) {
        canvas.drawRect(Rect.fromLTWH(i * w / 6, 0, w / 6, h), stripePaint);
      }
    }

    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    canvas.drawRect(Rect.fromLTRB(8, 8, w - 8, h - 8), linePaint);
    canvas.drawLine(Offset(w / 2, 8), Offset(w / 2, h - 8), linePaint);
    canvas.drawCircle(Offset(w / 2, h / 2), 18, linePaint);
    canvas.drawCircle(
      Offset(w / 2, h / 2),
      2,
      Paint()..color = Colors.white.withOpacity(0.8),
    );
    canvas.drawRect(Rect.fromLTRB(8, h / 2 - 22, 38, h / 2 + 22), linePaint);
    canvas.drawRect(
      Rect.fromLTRB(w - 38, h / 2 - 22, w - 8, h / 2 + 22),
      linePaint,
    );
    canvas.drawRect(Rect.fromLTRB(8, h / 2 - 10, 18, h / 2 + 10), linePaint);
    canvas.drawRect(
      Rect.fromLTRB(w - 18, h / 2 - 10, w - 8, h / 2 + 10),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _StartMatchButton extends StatelessWidget {
  final StakeController ctrl;

  const _StartMatchButton({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF041A0B), Color(0xFF041A0B)],
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        18,
        12,
        18,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      child: Obx(() {
        final isLoading = ctrl.isLoading.value;
        final loadingMsg = ctrl.loadingMessage.value;

        return GestureDetector(
          onTap: isLoading ? null : () => ctrl.onStartMatch(context),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 54,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isLoading
                    ? [
                        playMatchStart.withOpacity(0.6),
                        playMatchEnd.withOpacity(0.6),
                      ]
                    : [playMatchStart, playMatchEnd],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: playMatchStart.withOpacity(isLoading ? 0.15 : 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading) ...[
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    loadingMsg.isNotEmpty ? loadingMsg : 'Loading...',
                    style: const TextStyle(
                      color: textWhite,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                ] else ...[
                  const Text(
                    'Start Match',
                    style: TextStyle(
                      color: textWhite,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      }),
    );
  }
}
