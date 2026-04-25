import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class WalletScreenController extends GetxController {
  final RxString totalBalance = r'$2,450.75'.obs;
  final RxString ethBalance = '≈ 0.0845 ETH'.obs;
  final RxString available = r'$2,200.50'.obs;
  final RxString locked = r'$250.25'.obs;
  final RxString todayPbl = '+\$125.50'.obs;
  final RxString winRate = '68%'.obs;
  final RxString matches = '47'.obs;

  final RxList<TxItem> transactions = <TxItem>[
    const TxItem(
      title: 'Match Win',
      time: '2h Ago',
      amount: '+\$50.00',
      type: TxType.income,
    ),
    const TxItem(
      title: 'Match Stake',
      time: '2h Ago',
      amount: '-\$25.00',
      type: TxType.outgoing,
    ),
    const TxItem(
      title: 'Deposit',
      time: '1d Ago',
      amount: '+\$500.00',
      type: TxType.income,
    ),
    const TxItem(
      title: 'Deposit',
      time: '1d Ago',
      amount: '-\$100.00',
      type: TxType.outgoing,
    ),
  ].obs;

  void onDeposit() {
    Get.toNamed(Routes.DEPOSIT_SCREEN);
  }

  void onWithdraw() {
    Get.toNamed(Routes.WITHDRAW_SCREEN);
  }

  void onViewAll() => Get.snackbar(
    'Activity',
    'Coming soon!',
    backgroundColor: const Color(0xFF1D8C01),
    colorText: Colors.white,
    snackPosition: SnackPosition.BOTTOM,
  );

  final count = 0.obs;






  void increment() => count.value++;
}


enum TxType { income, outgoing }

class TxItem {
  final String title;
  final String time;
  final String amount;
  final TxType type;
  const TxItem({
    required this.title,
    required this.time,
    required this.amount,
    required this.type,
  });
}