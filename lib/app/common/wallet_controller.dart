import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../common/colors.dart';
import 'wallet_service.dart';

class WalletConnectSheet extends StatelessWidget {
  final VoidCallback? onConnected;
  final BuildContext parentContext;

  const WalletConnectSheet({
    super.key,
    this.onConnected,
    required this.parentContext,
  });

  /// Show the sheet from anywhere
  static Future<void> show({
    required BuildContext context,
    VoidCallback? onConnected,
  }) {
    return Get.bottomSheet(
      WalletConnectSheet(onConnected: onConnected, parentContext: context),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ws = WalletService.to;

    return Obx(() {
      // Auto-close & fire callback when connected
      if (ws.isConnected.value) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          onConnected?.call();
          if (Get.isBottomSheetOpen ?? false) Get.back();
        });
      }

      return _SheetScaffold(
        child: ws.isConnected.value
            ? _ConnectedView(ws: ws)
            : _ConnectView(ws: ws, parentContext: parentContext),
      );
    });
  }
}

// ─────────────────────────────────────────────
//  SHEET SCAFFOLD
// ─────────────────────────────────────────────
class _SheetScaffold extends StatelessWidget {
  final Widget child;
  const _SheetScaffold({required this.child});

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, bottomPad + 24),
          decoration: BoxDecoration(
            color: const Color(0xCC041A0B),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border(
              top: BorderSide(color: Colors.white.withOpacity(0.12), width: 1),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  CONNECT VIEW
// ─────────────────────────────────────────────
class _ConnectView extends StatelessWidget {
  final WalletService ws;
  final BuildContext parentContext;

  const _ConnectView({required this.ws, required this.parentContext});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _GlowIcon(),
        const SizedBox(height: 20),

        const Text(
          'Connect Your Wallet',
          style: TextStyle(
            color: textWhite,
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Link a wallet to deposit funds\nand join real-money matches.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 14,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 28),

        const _FeaturePills(),
        const SizedBox(height: 28),

        Obx(
          () => _GradientButton(
            label: ws.isConnecting.value ? 'Connecting…' : 'Connect Wallet',
            icon: ws.isConnecting.value
                ? const _SpinIcon()
                : const Icon(
                    Icons.account_balance_wallet_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
            onTap: ws.isConnecting.value
                ? null
                : () => ws.openConnectModal(parentContext),
          ),
        ),
        if (ws.isTelegramMobileContext) ...[
          const SizedBox(height: 12),
          Text(
            'Telegram Mini App detected. Open a wallet app, approve, then come back and tap Check Connection.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 12,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: ws.isConnecting.value
                      ? null
                      : () =>
                            ws.openWalletAppForTelegram(WebWalletApp.metamask),
                  icon: const Icon(
                    Icons.open_in_new,
                    size: 16,
                    color: Colors.white,
                  ),
                  label: const Text('Open MetaMask'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(color: Colors.white.withOpacity(0.35)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: ws.isConnecting.value
                      ? null
                      : () => ws.openWalletAppForTelegram(
                          WebWalletApp.trustWallet,
                        ),
                  icon: const Icon(
                    Icons.open_in_new,
                    size: 16,
                    color: Colors.white,
                  ),
                  label: const Text('Open Trust'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(color: Colors.white.withOpacity(0.35)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: ws.isConnecting.value ? null : ws.checkWebConnection,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: BorderSide(color: primaryColor.withOpacity(0.8)),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text('Check Connection'),
          ),
        ],
        const SizedBox(height: 12),

        TextButton(
          onPressed: () => Get.back(),
          child: Text(
            'Maybe Later',
            style: TextStyle(
              color: Colors.white.withOpacity(0.45),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  CONNECTED VIEW
// ─────────────────────────────────────────────
class _ConnectedView extends StatelessWidget {
  final WalletService ws;
  const _ConnectedView({required this.ws});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [playMatchStart, playMatchEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: playMatchStart.withOpacity(0.4),
                blurRadius: 24,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(
            Icons.check_circle_outline_rounded,
            color: Colors.white,
            size: 36,
          ),
        ),
        const SizedBox(height: 18),

        const Text(
          'Wallet Connected!',
          style: TextStyle(
            color: textWhite,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),

        GestureDetector(
          onTap: () {
            Clipboard.setData(ClipboardData(text: ws.walletAddress.value));
            Get.snackbar(
              'Copied',
              'Address copied to clipboard',
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 2),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: primaryColor.withOpacity(0.4),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: playMatchStart,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  ws.shortAddress,
                  style: const TextStyle(
                    color: textWhite,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.copy_rounded,
                  color: Colors.white.withOpacity(0.4),
                  size: 14,
                ),
              ],
            ),
          ),
        ),

        if (ws.connectedChain.value.isNotEmpty) ...[
          const SizedBox(height: 10),
          Text(
            'on ${ws.connectedChain.value}',
            style: TextStyle(
              color: Colors.white.withOpacity(0.45),
              fontSize: 13,
            ),
          ),
        ],

        const SizedBox(height: 28),
        _ConnectedStatsRow(ws: ws),
        const SizedBox(height: 28),

        GestureDetector(
          onTap: () async {
            await ws.disconnect();
            if (Get.isBottomSheetOpen ?? false) Get.back();
          },
          child: Container(
            height: 46,
            decoration: BoxDecoration(
              color: txIconOutgoingBg.withOpacity(0.12),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: txIconOutgoingBg.withOpacity(0.4),
                width: 1,
              ),
            ),
            child: const Center(
              child: Text(
                'Disconnect Wallet',
                style: TextStyle(
                  color: txIconOutgoingBg,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  CONNECTED STATS ROW
// ─────────────────────────────────────────────
class _ConnectedStatsRow extends StatelessWidget {
  final WalletService ws;
  const _ConnectedStatsRow({required this.ws});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        children: [
          _StatCard(
            label: 'Wallet Balance',
            value: ws.walletBalance.value,
            icon: Icons.account_balance_wallet_outlined,
          ),
          const SizedBox(width: 12),
          _StatCard(
            label: 'Network',
            value: ws.connectedChain.value.isEmpty
                ? 'Unknown'
                : ws.connectedChain.value,
            icon: Icons.hub_outlined,
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: primaryColor, size: 18),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: textWhite,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.45),
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  FEATURE PILLS
// ─────────────────────────────────────────────
class _FeaturePills extends StatelessWidget {
  const _FeaturePills();

  static const _features = [
    (Icons.lock_outline_rounded, 'Secure & Non-custodial'),
    (Icons.flash_on_rounded, 'Instant Deposits'),
    (Icons.emoji_events_outlined, 'Win Real Rewards'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _features.map((f) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1DB800), Color(0xFF0B826F)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(f.$1, color: Colors.white, size: 17),
              ),
              const SizedBox(width: 12),
              Text(
                f.$2,
                style: const TextStyle(
                  color: textWhite,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ─────────────────────────────────────────────
//  GLOW WALLET ICON
// ─────────────────────────────────────────────
class _GlowIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [primaryColor.withOpacity(0.30), Colors.transparent],
            ),
          ),
        ),
        Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [playMatchStart, playMatchEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: playMatchStart.withOpacity(0.45),
                blurRadius: 20,
                spreadRadius: 1,
              ),
            ],
          ),
          child: const Icon(
            Icons.account_balance_wallet_rounded,
            color: Colors.white,
            size: 32,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  GRADIENT CTA BUTTON
// ─────────────────────────────────────────────
class _GradientButton extends StatelessWidget {
  final String label;
  final Widget icon;
  final VoidCallback? onTap;

  const _GradientButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: onTap == null ? 0.55 : 1.0,
        child: Container(
          height: 54,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [playMatchStart, playMatchEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: playMatchStart.withOpacity(0.35),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.2,
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
//  SPINNING ICON
// ─────────────────────────────────────────────
class _SpinIcon extends StatefulWidget {
  const _SpinIcon();

  @override
  State<_SpinIcon> createState() => _SpinIconState();
}

class _SpinIconState extends State<_SpinIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  )..repeat();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _ctrl,
      child: const Icon(Icons.refresh_rounded, color: Colors.white, size: 20),
    );
  }
}
