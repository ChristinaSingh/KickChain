import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../common/colors.dart';
import '../controllers/withdraw_screen_controller.dart';

// ─────────────────────────────────────────────
//  WITHDRAW SCREEN
// ─────────────────────────────────────────────

class WithdrawScreen extends GetView<WithdrawController> {
  const WithdrawScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<WithdrawController>()) {
      Get.put(WithdrawController());
    }

    return Scaffold(
      backgroundColor: bgGradientBottom,
      body: Stack(
        children: [
          const _Background(),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ────────────────────────
                _Header(onBack: () => Get.back()),
                const SizedBox(height: 24),

                // ── Scrollable content ────────────
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Balance card ────────────
                        _BalanceCard(balance: controller.totalBalance),
                        const SizedBox(height: 16),

                        // ── Amount card ─────────────
                        _AmountCard(ctrl: controller),
                        const SizedBox(height: 16),

                        // ── Network card ─────────────
                        Obx(() {
                          controller.count.value;
                          return  _NetworkCard(ctrl: controller);
                        }),
                        const SizedBox(height: 16),

                        // ── Withdrawal Address card ──
                        _AddressCard(ctrl: controller),
                        const SizedBox(height: 24),

                        // ── Fee summary ──────────────

                        Obx(() {
                          controller.count.value;
                          return  _FeeSummary(ctrl: controller);
                        }),
                        const SizedBox(height: 28),

                        // ── Confirm button ───────────
                        _ConfirmButton(onTap: controller.onConfirmWithdraw),
                        const SizedBox(height: 16),
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
          colors: [
            Color(0xFF1DB800),
            Color(0xFF0A6400),
            Color(0xFF053300),
          ],
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
            'Withdraw',
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
//  BALANCE CARD  (solid gradient — no glass)
// ─────────────────────────────────────────────

class _BalanceCard extends StatelessWidget {
  final double balance;
  const _BalanceCard({required this.balance});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF5DCF00),
            Color(0xFF1DB870),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF5DCF00).withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Balance',
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '\$${_formatAmount(balance)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  String _formatAmount(double v) {
    final parts = v.toStringAsFixed(2).split('.');
    final intPart = parts[0];
    final decPart = parts[1];
    final buf = StringBuffer();
    int count = 0;
    for (int i = intPart.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) buf.write(',');
      buf.write(intPart[i]);
      count++;
    }
    return '${buf.toString().split('').reversed.join()}.$decPart';
  }
}

// ─────────────────────────────────────────────
//  AMOUNT CARD
// ─────────────────────────────────────────────

class _AmountCard extends StatelessWidget {
  final WithdrawController ctrl;
  const _AmountCard({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Amount (USD)',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),

          // Input field
          Container(
            height: 52,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.28),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFF3a7a3a).withOpacity(0.5),
                width: 1.0,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: ctrl.amountController,
              onChanged: ctrl.onAmountChanged,
              keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              decoration: const InputDecoration(
                hintText: '0.00',
                hintStyle: TextStyle(
                  color: Colors.white38,
                  fontSize: 16,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              cursorColor: accentGreen,
            ),
          ),

          const SizedBox(height: 8),
          Text(
            'Min: \$${ctrl.minAmount.toStringAsFixed(2)}',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  NETWORK CARD  (with custom dropdown)
// ─────────────────────────────────────────────

class _NetworkCard extends StatelessWidget {
  final WithdrawController ctrl;
  const _NetworkCard({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Network',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),

          // Dropdown trigger
          GestureDetector(
            onTap: ctrl.toggleDropdown,
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.28),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFF3a7a3a).withOpacity(0.5),
                  width: 1.0,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      ctrl.selectedNetwork.display,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: ctrl.isDropdownOpen.value ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.white70,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Dropdown list
          if (ctrl.isDropdownOpen.value) ...[
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.45),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFF3a7a3a).withOpacity(0.5),
                      width: 1.0,
                    ),
                  ),
                  child: Column(
                    children: List.generate(ctrl.networks.length, (i) {
                      final isSelected =
                          ctrl.selectedNetworkIndex.value == i;
                      final isLast = i == ctrl.networks.length - 1;
                      return GestureDetector(
                        onTap: () => ctrl.selectNetwork(i),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? accentGreen.withOpacity(0.15)
                                : Colors.transparent,
                            border: !isLast
                                ? Border(
                              bottom: BorderSide(
                                color: Colors.white.withOpacity(0.08),
                                width: 0.8,
                              ),
                            )
                                : null,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  ctrl.networks[i].display,
                                  style: TextStyle(
                                    color: isSelected
                                        ? accentGreen
                                        : Colors.white70,
                                    fontSize: 13,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w400,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                const Icon(
                                  Icons.check_rounded,
                                  color: accentGreen,
                                  size: 16,
                                ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  WITHDRAWAL ADDRESS CARD
// ─────────────────────────────────────────────

class _AddressCard extends StatelessWidget {
  final WithdrawController ctrl;
  const _AddressCard({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Withdrawal Address',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),

          Container(
            height: 52,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.28),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFF3a7a3a).withOpacity(0.5),
                width: 1.0,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: ctrl.addressController,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
              decoration: const InputDecoration(
                hintText: '0x742d35Cc6634C0532925a3b844Bc9e75',
                hintStyle: TextStyle(
                  color: Colors.white38,
                  fontSize: 13,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              cursorColor: accentGreen,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  FEE SUMMARY
// ─────────────────────────────────────────────

class _FeeSummary extends StatelessWidget {
  final WithdrawController ctrl;
  const _FeeSummary({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final fee = ctrl.networkFee;
    final amount = ctrl.enteredAmount.value;
    final receive = ctrl.youWillReceive;

    return Column(
      children: [
        // ── Network Fee row ──────────────────
        _SummaryRow(
          label: 'Network Fee',
          value: '\$${fee.toStringAsFixed(2)}',
          valueColor: Colors.white70,
          bold: false,
        ),
        const SizedBox(height: 12),

        // ── Amount row ───────────────────────
        _SummaryRow(
          label: 'Amount',
          value: '\$${amount.toStringAsFixed(2)}',
          valueColor: Colors.white70,
          bold: false,
        ),

        const SizedBox(height: 14),

        // ── Divider ──────────────────────────
        Container(
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.0),
                Colors.white.withOpacity(0.35),
                Colors.white.withOpacity(0.0),
              ],
            ),
          ),
        ),

        const SizedBox(height: 14),

        // ── You'll Receive row ───────────────
        _SummaryRow(
          label: "You'll Receive",
          value: '\$${receive.toStringAsFixed(2)}',
          valueColor: accentGreen,
          bold: true,
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  final bool bold;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.valueColor,
    required this.bold,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: bold ? Colors.white : Colors.white60,
            fontSize: bold ? 16 : 14,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: bold ? 16 : 14,
            fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  CONFIRM WITHDRAWAL BUTTON
// ─────────────────────────────────────────────

class _ConfirmButton extends StatelessWidget {
  final VoidCallback onTap;
  const _ConfirmButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 58,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF72E000),
              Color(0xFF3AAA00),
            ],
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x505DCF00),
              blurRadius: 22,
              spreadRadius: 1,
              offset: Offset(0, 6),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: const Text(
          'Confirm Withdrawal',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  MANUAL GLASS CARD
//  ClipRRect + BackdropFilter — sizes to child.
// ─────────────────────────────────────────────

class _GlassCard extends StatelessWidget {
  final Widget child;
  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: CustomPaint(
          painter: _GlassCardBorderPainter(),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.black.withOpacity(0.22),
            ),
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
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
      const Radius.circular(20),
    );

    // Outer gradient border: green-teal like walletCardBorderStart/End
    final borderPaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0x885DCF00),
          Color(0x220B826F),
          Color(0x220B826F),
          Color(0x880B826F),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0.0, 0.30, 0.70, 1.0],
      ).createShader(rect.outerRect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    canvas.drawRRect(rect, borderPaint);

    // Top-left inner gloss
    final glossRect =
    Rect.fromLTWH(0, 0, size.width, size.height * 0.35);
    final glossPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.white.withOpacity(0.10),
          Colors.white.withOpacity(0.0),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(glossRect);

    canvas.drawRRect(
      RRect.fromRectAndRadius(glossRect, const Radius.circular(20)),
      glossPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}