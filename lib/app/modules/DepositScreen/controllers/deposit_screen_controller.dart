import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

// ─────────────────────────────────────────────
//  TOKEN MODEL
// ─────────────────────────────────────────────

class TokenModel {
  final String symbol;
  final String name;
  final String network;
  final String walletAddress;

  const TokenModel({
    required this.symbol,
    required this.name,
    required this.network,
    required this.walletAddress,
  });
}

// ─────────────────────────────────────────────
//  DEPOSIT CONTROLLER
// ─────────────────────────────────────────────

class DepositController extends GetxController {
  final RxInt selectedTokenIndex = 0.obs;
  final count = 0.obs;

  final List<TokenModel> tokens = const [
    TokenModel(
      symbol: 'USDT',
      name: 'Tether',
      network: 'ERC-20',
      walletAddress: '0x742d35Cc6634C0532925a3b844Bc9e7595f',
    ),
    TokenModel(
      symbol: 'USDC',
      name: 'USD Coin',
      network: 'ERC-20',
      walletAddress: '0x8A3f21Dd7823C1452BD9f3e4E90cA7B21fA5Bc01',
    ),
    TokenModel(
      symbol: 'ETH',
      name: 'Ethereum',
      network: 'Mainnet',
      walletAddress: '0x3Cd1F6B22cEc4Db5F8e7B9aC3d7eD8A44e9Fc210',
    ),
    TokenModel(
      symbol: 'BNB',
      name: 'BNB',
      network: 'BSC',
      walletAddress: '0xF1a4D9Cb3e8B7A5C62d19e0F3B8c7dE9A4b5F3c2',
    ),
  ];

  TokenModel get selectedToken => tokens[selectedTokenIndex.value];

  void selectToken(int index) => selectedTokenIndex.value = index;

  void copyAddress() {
    Clipboard.setData(ClipboardData(text: selectedToken.walletAddress));
    Get.snackbar(
      'Copied!',
      'Wallet address copied to clipboard',
      backgroundColor: const Color(0xFF1D8C01),
      colorText: const Color(0xFFFFFFFF),
      borderRadius: 16,
      margin: const EdgeInsets.all(16),
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void increment() => count.value++;
}