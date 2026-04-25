import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glass_kit/glass_kit.dart';

import '../../../common/colors.dart';
import '../../../common/text_styles.dart';
import '../controllers/wallet_screen_controller.dart';

class WalletScreenView extends GetView<WalletScreenController> {
  const WalletScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<WalletScreenController>()) {
      Get.put(WalletScreenController());
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const _WalletBackground(),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Wallet', style: MyTextStyle.walletPageTitle),
                  const SizedBox(height: 20),

                  _BalanceCard(ctrl: controller),
                  const SizedBox(height: 20),

                  _ActionButtons(ctrl: controller),
                  const SizedBox(height: 20),

                  _StatsRow(ctrl: controller),
                  const SizedBox(height: 28),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recent Activity',
                        style: MyTextStyle.walletSectionTitle,
                      ),
                      GestureDetector(
                        onTap: controller.onViewAll,
                        child: const Text(
                          'View All',
                          style: MyTextStyle.walletViewAll,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  Obx(
                    () => Column(
                      children: controller.transactions
                          .map(
                            (tx) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _TxCard(tx: tx),
                            ),
                          )
                          .toList(),
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

// ─────────────────────────────────────────────
//  BACKGROUND
// ─────────────────────────────────────────────

class _WalletBackground extends StatelessWidget {
  const _WalletBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(-0.2, -0.5),
          radius: 1.3,
          colors: [Color(0xFF1DB800), Color(0xFF0A6400), Color(0xFF041A0B)],
          stops: [0.0, 0.40, 1.0],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  GRADIENT BORDER HELPER
// ─────────────────────────────────────────────

class _GradientBorderBox extends StatelessWidget {
  final Widget child;
  final BorderRadius borderRadius;
  final List<Color> gradientColors;
  final double borderWidth;

  const _GradientBorderBox({
    required this.child,
    required this.borderRadius,
    this.gradientColors = const [Color(0xFF5DCF00), Color(0xFF0B826F)],
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

// ─────────────────────────────────────────────
//  BALANCE CARD
//
//  FIX: GlassContainer does NOT accept height: null when inside a
//  Column (unbounded height axis) — the render system throws a
//  "RenderBox was not laid out" assertion.
//  Solution: wrap in IntrinsicHeight so the glass container gets a
//  finite, content-driven height before layout.
// ─────────────────────────────────────────────

class _BalanceCard extends StatelessWidget {
  final WalletScreenController ctrl;

  const _BalanceCard({required this.ctrl});

  static final _radius = BorderRadius.circular(20);

  @override
  Widget build(BuildContext context) {
    return _GradientBorderBox(
      borderRadius: _radius,
      borderWidth: 1.5,
      // ✅ IntrinsicHeight resolves the null-height issue
      child: SizedBox(
        height: 250,
        child: LayoutBuilder(
          builder: (ctx, constraints) {
            return GlassContainer(
              width: constraints.maxWidth,
              // finite ✅
              height: double.infinity,
              // fills IntrinsicHeight ✅
              borderRadius: _radius,
              blur: 20,
              color: Colors.white.withOpacity(0.08),
              borderColor: Colors.transparent,
              borderWidth: 0,
              padding: const EdgeInsets.all(20),
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Balance',
                                style: MyTextStyle.walletBalanceLabel,
                              ),
                              SizedBox(height: 10),
                              Text(
                                ctrl.totalBalance.value,
                                style: MyTextStyle.walletBalanceAmount,
                              ),
                              SizedBox(height: 10),
                              Text(
                                ctrl.ethBalance.value,
                                style: MyTextStyle.walletEthLabel,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _SubBalancePill(
                              label: 'Available',
                              value: ctrl.available.value,
                            ),
                            const SizedBox(height: 8),
                            _SubBalancePill(
                              label: 'Locked',
                              value: ctrl.locked.value,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ── Available / Locked pill ──────────────────

class _SubBalancePill extends StatelessWidget {
  final String label;
  final String value;

  const _SubBalancePill({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: walletSubCardBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(label, style: MyTextStyle.walletSubLabel),
          const SizedBox(height: 4),
          Text(value, style: MyTextStyle.walletSubAmount),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  DEPOSIT / WITHDRAW BUTTONS
// ─────────────────────────────────────────────

class _ActionButtons extends StatelessWidget {
  final WalletScreenController ctrl;

  const _ActionButtons({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // ── Deposit (gradient fill) ────────────
        Expanded(
          child: GestureDetector(
            onTap: ctrl.onDeposit,
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [depositStart, depositEnd],
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x405DCF00),
                    blurRadius: 16,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _CoinIcon(color: Colors.white),
                  const SizedBox(width: 8),
                  const Text('Deposit', style: MyTextStyle.walletActionBtn),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),

        // ── Withdraw (outlined) ────────────────
        Expanded(
          child: GestureDetector(
            onTap: ctrl.onWithdraw,
            child: _GradientBorderBox(
              borderRadius: BorderRadius.circular(50),
              borderWidth: 1.5,
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: withdrawBg,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _CoinIcon(color: primaryColor),
                    const SizedBox(width: 8),
                    const Text('Withdraw', style: MyTextStyle.walletActionBtn),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Coin circle icon ─────────────────────────

class _CoinIcon extends StatelessWidget {
  final Color color;

  // ✅ non-const instance is fine; constructor can still be const
  const _CoinIcon({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
      ),
      child: Center(
        child: Icon(Icons.attach_money_rounded, color: color, size: 14),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  STATS ROW
// ─────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final WalletScreenController ctrl;

  const _StatsRow({required this.ctrl});

  static final _radius = BorderRadius.circular(18);

  @override
  Widget build(BuildContext context) {
    return _GradientBorderBox(
      borderRadius: _radius,
      borderWidth: 1.5,
      child: LayoutBuilder(
        builder: (ctx, constraints) {
          return GlassContainer(
            width: constraints.maxWidth,
            // finite ✅
            height: 100,
            // explicit fixed height ✅
            borderRadius: _radius,
            blur: 18,
            color: Color(0xFF053307).withAlpha(150),
            borderColor: Colors.transparent,
            borderWidth: 0,
            child: Obx(
              () => Row(
                children: [
                  _StatCell(label: "Today's PBL", value: ctrl.todayPbl.value),
                  const _VerticalDivider(), // ✅ const
                  _StatCell(label: 'Win Rate', value: ctrl.winRate.value),
                  const _VerticalDivider(), // ✅ const
                  _StatCell(label: 'Matches', value: ctrl.matches.value),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  final String label;
  final String value;

  const _StatCell({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: MyTextStyle.walletStatLabel,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: MyTextStyle.walletStatValue,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ✅ const constructor added
class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 44, color: statsDivider);
  }
}

// ─────────────────────────────────────────────
//  TRANSACTION CARD
// ─────────────────────────────────────────────

class _TxCard extends StatelessWidget {
  final TxItem tx;

  const _TxCard({required this.tx});

  static final _radius = BorderRadius.circular(16);

  bool get _isIncome => tx.type == TxType.income;

  @override
  Widget build(BuildContext context) {
    return _GradientBorderBox(
      borderRadius: _radius,
      borderWidth: 1.2,
      gradientColors: const [Color(0x665DCF00), Color(0x330B826F)],
      child: LayoutBuilder(
        builder: (ctx, constraints) {
          return GlassContainer(
            width: constraints.maxWidth,
            // finite ✅
            height: 76,
            // explicit fixed height ✅
            borderRadius: _radius,
            blur: 14,
            color: Colors.white.withOpacity(0.07),
            borderColor: Colors.transparent,
            borderWidth: 0,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Icon circle
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isIncome ? txIconIncomeBg : txIconOutgoingBg,
                  ),
                  child: Icon(
                    _isIncome
                        ? Icons.south_west_rounded
                        : Icons.north_east_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),

                // Title + time
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tx.title, style: MyTextStyle.walletTxTitle),
                      const SizedBox(height: 4),
                      Text(tx.time, style: MyTextStyle.walletTxSubtitle),
                    ],
                  ),
                ),

                // Amount
                Text(
                  tx.amount,
                  style: _isIncome
                      ? MyTextStyle.walletTxPositive
                      : MyTextStyle.walletTxNegative,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
