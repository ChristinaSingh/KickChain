import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../common/wallet_controller.dart';
import '../common/wallet_service.dart';

enum StakeMode { funCoins, realMoney }

class StakeController extends GetxController {
  // ── Refresh trigger ─────────────────────────
  final count = 0.obs;

  // ── Loading state ───────────────────────────
  final isLoading = false.obs;
  final loadingMessage = ''.obs;

  // ── Mode ────────────────────────────────────
  final mode = StakeMode.funCoins.obs;
  bool get isFunCoins => mode.value == StakeMode.funCoins;

  // ── Match type toggle ───────────────────────
  final isRandomMatch = true.obs;
  void selectRandomMatch()  => isRandomMatch.value = true;
  void selectInviteFriend() => isRandomMatch.value = false;

  // ── Selected stake ───────────────────────────
  final selectedStakeIndex = Rx<int?>(null);
  final selectedTier       = ''.obs;

  void selectStake(String tier, int index, BuildContext context) {
    // Gate: require wallet when balance is 0
    if (coinBalance.value == 0) {
      _showWalletGate(
        context: context,
        onConnected: () {
          selectedTier.value       = tier;
          selectedStakeIndex.value = index;
          count.value++;
        },
      );
      return;
    }
    selectedTier.value       = tier;
    selectedStakeIndex.value = index;
    count.value++;
  }

  bool isSelected(String tier, int index) =>
      selectedTier.value == tier && selectedStakeIndex.value == index;

  // ── Coin balance ─────────────────────────────
  final coinBalance = 0.obs;

  // ── Fun Coins tiers ─────────────────────────
  final Map<String, List<String>> funCoinStakes = {
    'Micro'      : ['100', '250', '500', '1k'],
    'LOW'        : ['2k', '5k', '10k'],
    'MID'        : ['25k', '50k', '100k'],
    'HIGH / VIP' : ['250k', '500k', '1000k'],
  };

  // ── Real Money tiers ─────────────────────────
  final Map<String, List<String>> realMoneyStakes = {
    'Micro'      : ['\$0.10', '\$0.25', '\$0.50', '\$1.00', '\$2.00'],
    'LOW'        : ['\$5.00', '\$10.00', '\$20.00'],
    'MID'        : ['\$50.00', '\$100.00'],
    'HIGH / VIP' : ['\$100.00', '\$500.00', '\$1,000.00'],
  };

  Map<String, List<String>> get currentStakes =>
      isFunCoins ? funCoinStakes : realMoneyStakes;

  // ── Free match ───────────────────────────────
  void onFreeMatch() {
    // Get.toNamed('/match-lobby', arguments: {'stake': 0, 'mode': 'free'});
  }

  // ── Start match ───────────────────────────────
  Future<void> onStartMatch(BuildContext context) async {
    if (selectedStakeIndex.value == null) {
      Get.snackbar(
        'Select Stake',
        'Please pick a stake amount to continue.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
      );
      return;
    }

    final ws = _walletService;

    // Check if wallet service exists
    if (ws == null) {
      Get.snackbar(
        'Error',
        'Wallet service not available',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    // Check if wallet is connected
    if (!ws.isConnected.value) {
      _showWalletGate(
        context: context,
        onConnected: () => _proceedToMatch(),
      );
      return;
    }

    await _proceedToMatch();
  }

  Future<void> _proceedToMatch() async {
    try {
      isLoading.value = true;
      loadingMessage.value = 'Finding opponent...';

      // Simulate matchmaking delay
      await Future.delayed(const Duration(seconds: 2));

      loadingMessage.value = 'Setting up match...';
      await Future.delayed(const Duration(seconds: 1));

      isLoading.value = false;
      loadingMessage.value = '';

      // Navigate to match
      // Get.toNamed('/match-lobby');

      Get.snackbar(
        'Match Ready!',
        'Entering the arena...',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
      );
    } catch (e) {
      isLoading.value = false;
      loadingMessage.value = '';
      debugPrint('[StakeController] Error: $e');

      Get.snackbar(
        'Error',
        'Failed to start match. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  // ── Show wallet connect sheet ─────────────────
  void _showWalletGate({required BuildContext context, VoidCallback? onConnected}) {
    WalletConnectSheet.show(
      context: context,
      onConnected: onConnected,
    );
  }

  // ── Safe wallet service getter ────────────────
  WalletService? get _walletService {
    try {
      return WalletService.to;
    } catch (_) {
      return null;
    }
  }

  void increment() => count.value++;
}