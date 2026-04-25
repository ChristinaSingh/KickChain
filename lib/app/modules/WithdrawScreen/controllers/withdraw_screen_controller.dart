import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ─────────────────────────────────────────────
//  NETWORK MODEL
// ─────────────────────────────────────────────

class NetworkModel {
  final String label;
  final double fee;

  const NetworkModel({required this.label, required this.fee});

  String get display => '$label - Fee: \$${fee.toStringAsFixed(1)}';
}

// ─────────────────────────────────────────────
//  WITHDRAW CONTROLLER
// ─────────────────────────────────────────────

class WithdrawController extends GetxController {

  final count = 0.obs;

  void increment() => count.value++;
  // ── Balance ─────────────────────────────────
  final double totalBalance = 2450.75;

  // ── Amount input ────────────────────────────
  final TextEditingController amountController =
  TextEditingController(text: '');
  final RxDouble enteredAmount = 0.0.obs;
  final double minAmount = 20.0;

  // ── Address input ────────────────────────────
  final TextEditingController addressController = TextEditingController();

  // ── Network dropdown ─────────────────────────
  final List<NetworkModel> networks = const [
    NetworkModel(label: 'Ethereum (ERC-20)', fee: 2.5),
    NetworkModel(label: 'BNB Smart Chain (BSC)', fee: 1.0),
    NetworkModel(label: 'Tron (TRC-20)', fee: 0.5),
    NetworkModel(label: 'Polygon (MATIC)', fee: 0.3),
  ];

  final RxInt selectedNetworkIndex = 0.obs;
  final RxBool isDropdownOpen = false.obs;

  NetworkModel get selectedNetwork => networks[selectedNetworkIndex.value];

  double get networkFee => selectedNetwork.fee;
  double get youWillReceive {
    final amt = enteredAmount.value - networkFee;
    return amt < 0 ? 0.0 : amt;
  }

  void selectNetwork(int index) {
    selectedNetworkIndex.value = index;
    isDropdownOpen.value = false;
  }

  void toggleDropdown() => isDropdownOpen.value = !isDropdownOpen.value;

  void onAmountChanged(String v) {
    enteredAmount.value = double.tryParse(v) ?? 0.0;
  }

  void onConfirmWithdraw() {
    final amount = enteredAmount.value;
    final address = addressController.text.trim();

    if (amount < minAmount) {
      Get.snackbar(
        'Invalid Amount',
        'Minimum withdrawal is \$${minAmount.toStringAsFixed(2)}',
        backgroundColor: const Color(0xFFE53935),
        colorText: const Color(0xFFFFFFFF),
        borderRadius: 16,
        margin: const EdgeInsets.all(16),
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (amount > totalBalance) {
      Get.snackbar(
        'Insufficient Balance',
        'You do not have enough balance',
        backgroundColor: const Color(0xFFE53935),
        colorText: const Color(0xFFFFFFFF),
        borderRadius: 16,
        margin: const EdgeInsets.all(16),
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (address.isEmpty) {
      Get.snackbar(
        'Missing Address',
        'Please enter a withdrawal address',
        backgroundColor: const Color(0xFFE53935),
        colorText: const Color(0xFFFFFFFF),
        borderRadius: 16,
        margin: const EdgeInsets.all(16),
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Get.snackbar(
      'Withdrawal Submitted',
      'Your withdrawal of \$${amount.toStringAsFixed(2)} has been submitted',
      backgroundColor: const Color(0xFF1D8C01),
      colorText: const Color(0xFFFFFFFF),
      borderRadius: 16,
      margin: const EdgeInsets.all(16),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void onClose() {
    amountController.dispose();
    addressController.dispose();
    super.onClose();
  }
}