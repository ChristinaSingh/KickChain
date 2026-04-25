import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kickchain/app/data/apis/api_models/shop_items_response_model.dart';
import 'package:kickchain/app/data/apis/user_api_service.dart';

// ─────────────────────────────────────────────
//  DATA MODELS
// ─────────────────────────────────────────────

enum ItemStatus { equipped, buy, owned }

class ShopItem {
  final String id;
  final String name;
  final String imagePath;
  final int price;
  final String description;
  final bool isFree;
  ItemStatus status;

  ShopItem({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.price,
    this.description = '',
    this.isFree = false,
    this.status = ItemStatus.buy,
  });

  factory ShopItem.fromApi(ShopApiItem item) {
    return ShopItem(
      id: item.id,
      name: item.name,
      imagePath: Uri.encodeFull(item.image),
      price: item.price.toInt(),
      description: item.description,
      isFree: item.isFree,
      status: item.isEquipped ? ItemStatus.equipped : ItemStatus.buy,
    );
  }
}

class CurrencyPack {
  final String id;
  final String coinsLabel; // "1,000 Coins"
  final String valueLabel; // "Best value! 1010.1 coins per $"
  final String priceLabel; // "$0.99"
  final int coins;
  final String coinImagePath; // asset path for coin-stack image
  final String description;

  const CurrencyPack({
    required this.id,
    required this.coinsLabel,
    required this.valueLabel,
    required this.priceLabel,
    required this.coins,
    required this.coinImagePath,
    this.description = '',
  });

  factory CurrencyPack.fromApi(ShopApiItem item) {
    final price = item.price.toDouble();
    return CurrencyPack(
      id: item.id,
      coinsLabel: item.name,
      valueLabel: item.description,
      priceLabel: '\$${price.toStringAsFixed(2)}',
      coins: item.coinAmount,
      coinImagePath: Uri.encodeFull(item.image),
      description: item.description,
    );
  }
}

// ─────────────────────────────────────────────
//  CONTROLLER
// ─────────────────────────────────────────────

class ShopController extends GetxController {
  final UserApiService _apiService = UserApiService();

  final selectedTab = 0.obs;
  final coinBalance = 3200.obs;
  final count = 0.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final tabs = const ['Themes', 'Balls', 'Pucks', 'Currency'];

  // ── Themes ──────────────────────────────────
  final themes = <ShopItem>[].obs;

  // ── Balls ────────────────────────────────────
  final balls = <ShopItem>[].obs;

  // ── Pucks ────────────────────────────────────
  final pucks = <ShopItem>[].obs;

  // ── Currency packs ───────────────────────────
  final currencyPacks = <CurrencyPack>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchShopItems();
  }

  Future<void> fetchShopItems() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final responses = await Future.wait([
        _apiService.getShopItems('theme'),
        _apiService.getShopItems('ball'),
        _apiService.getShopItems('puck'),
        _apiService.getShopItems('currency'),
      ]);

      themes.assignAll(_activeShopItems(responses[0]));
      balls.assignAll(_activeShopItems(responses[1]));
      pucks.assignAll(_activeShopItems(responses[2]));
      currencyPacks.assignAll(_activeCurrencyPacks(responses[3]));
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  List<ShopItem> _activeShopItems(ShopItemsResponseModel response) {
    return response.data
        .where((item) => item.isActive)
        .map(ShopItem.fromApi)
        .toList();
  }

  List<CurrencyPack> _activeCurrencyPacks(ShopItemsResponseModel response) {
    return response.data
        .where((item) => item.isActive)
        .map(CurrencyPack.fromApi)
        .toList();
  }

  List<ShopItem> get currentItems {
    switch (selectedTab.value) {
      case 0:
        return themes;
      case 1:
        return balls;
      case 2:
        return pucks;
      default:
        return [];
    }
  }

  void onTabTap(int index) {
    if (selectedTab.value == index) return;
    selectedTab.value = index;
  }

  void onBuyItem(ShopItem item) {
    if (item.status == ItemStatus.equipped) return;
    if (coinBalance.value < item.price) {
      Get.snackbar(
        'Not enough coins',
        'You need ${item.price - coinBalance.value} more coins.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1A5C00),
        colorText: Colors.white,
      );
      return;
    }
    coinBalance.value -= item.price;
    item.status = ItemStatus.owned;
    count.value++;
    Get.snackbar(
      'Purchased!',
      '${item.name} added to your collection.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF1A5C00),
      colorText: Colors.white,
    );
  }

  void onEquipItem(ShopItem item) {
    for (final i in currentItems) {
      if (i.status == ItemStatus.equipped) i.status = ItemStatus.owned;
    }
    item.status = ItemStatus.equipped;
    count.value++;
  }

  void onItemTap(ShopItem item) {
    if (item.status == ItemStatus.buy) {
      onBuyItem(item);
    } else if (item.status == ItemStatus.owned) {
      onEquipItem(item);
    }
  }

  void onBuyCurrencyPack(CurrencyPack pack) {
    // Replace with real IAP flow
    coinBalance.value += pack.coins;
    count.value++;
    Get.snackbar(
      'Purchase Successful!',
      '+${pack.coinsLabel} added to your wallet.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF1A5C00),
      colorText: Colors.white,
    );
  }

  void onBackTap() => Get.back();
}
