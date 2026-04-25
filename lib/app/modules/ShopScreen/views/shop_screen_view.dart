import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kickchain/app/common/common_widgets.dart';
import 'package:kickchain/app/data/constants/icons_constant.dart';

import '../controllers/shop_screen_controller.dart';

// ─── Colours ─────────────────────────────────────────────────────────────────
const Color _bgTop = Color(0xFF1DB800);
const Color _bgMid = Color(0xFF0A6400);
const Color _bgBottom = Color(0xFF256e03);
const Color _cardBg = Color(0xFF1A5C00);
const Color _cardBgLight = Color(0xFF206800);
const Color _tabActiveBg = Color(0xFF3DD000);
const Color _equippedBg = Color(0xFF2FC700);
const Color _buyBg = Color(0xFFFFA500); // orange — Equipped / Buy
const Color _priceBtnBg = Color(0xFF3B82F6); // blue  — currency price
const Color _coinYellow = Color(0xFFFFCC00);

// ─────────────────────────────────────────────────────────────────────────────
//  SHOP SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class ShopScreen extends GetView<ShopController> {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgBottom,
      body: Stack(
        children: [
          const _ShopBackground(),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // ── Back + Title ───────────────
                _buildHeader(),
                const SizedBox(height: 24),

                // ── Tab bar ────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Obx(
                    () => _TabBar(
                      selectedIndex: controller.selectedTab.value,
                      tabs: controller.tabs,
                      onTap: controller.onTabTap,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // ── Animated content ───────────
                Expanded(
                  child: Obx(() {
                    controller.count.value;
                    if (controller.isLoading.value) {
                      return const _ShopLoadingState();
                    }
                    if (controller.errorMessage.value.isNotEmpty) {
                      return _ShopErrorState(
                        message: controller.errorMessage.value,
                        onRetry: controller.fetchShopItems,
                      );
                    }
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 280),
                      transitionBuilder: (child, animation) {
                        final slide =
                            Tween<Offset>(
                              begin: const Offset(0.07, 0),
                              end: Offset.zero,
                            ).animate(
                              CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeOutCubic,
                              ),
                            );
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(position: slide, child: child),
                        );
                      },
                      child: controller.selectedTab.value == 3
                          ? _CurrencyTab(
                              key: const ValueKey('currency'),
                              controller: controller,
                            )
                          : _ItemListTab(
                              key: ValueKey(
                                'tab_${controller.selectedTab.value}',
                              ),
                              controller: controller,
                            ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: controller.onBackTap,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF4EE500), Color(0xFF1DB800)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                Icons.chevron_left_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'Shop',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.4,
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

class _ShopBackground extends StatelessWidget {
  const _ShopBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0.3, -0.7),
          radius: 1.3,
          colors: [_bgTop, _bgMid, _bgBottom],
          stops: [0.0, 0.45, 1.0],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  TAB BAR
// ─────────────────────────────────────────────

class _TabBar extends StatelessWidget {
  final int selectedIndex;
  final List<String> tabs;
  final ValueChanged<int> onTap;

  const _TabBar({
    required this.selectedIndex,
    required this.tabs,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(tabs.length, (i) {
        final active = i == selectedIndex;
        return Expanded(
          child: GestureDetector(
            onTap: () => onTap(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              margin: EdgeInsets.only(right: i < tabs.length - 1 ? 8 : 0),
              height: 42,
              decoration: BoxDecoration(
                color: active ? _tabActiveBg : Colors.transparent,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: active ? _tabActiveBg : Colors.white.withOpacity(0.25),
                  width: 1.5,
                ),
                boxShadow: active
                    ? [
                        BoxShadow(
                          color: _tabActiveBg.withOpacity(0.45),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 220),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: active ? FontWeight.bold : FontWeight.w500,
                    letterSpacing: 0.2,
                  ),
                  child: Text(tabs[i]),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────
//  SHARED: BOTTOM ILLUSTRATION + ICONS STACK
//  Used by both _ItemListTab and _CurrencyTab
// ─────────────────────────────────────────────

/// Wraps any scrollable [child] with a pinned bottom illustration
/// and a category-icon row sitting just above it.
class _ScrollWithBottomArt extends StatelessWidget {
  final Widget Function(BuildContext, ScrollController) builder;

  const _ScrollWithBottomArt({required this.builder});

  @override
  Widget build(BuildContext context) {
    final sc = ScrollController();
    return Stack(
      children: [
        // ── Fixed bottom illustration ──────────
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: IgnorePointer(
            child: SizedBox(
              height: 293,
              width: double.infinity,
              child: Image.asset(
                'assets/images/shop_bottom.png',
                fit: BoxFit.contain,
                alignment: Alignment.bottomCenter,
                errorBuilder: (_, _, _) => const SizedBox.shrink(),
              ),
            ),
          ),
        ),

        // ── Scrollable content ─────────────────
        builder(context, sc),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  ITEM LIST TAB  (Themes / Balls / Pucks)
// ─────────────────────────────────────────────

class _ItemListTab extends StatelessWidget {
  final ShopController controller;

  const _ItemListTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final items = controller.currentItems;

    return _ScrollWithBottomArt(
      builder: (_, _) => items.isEmpty
          ? const _ShopEmptyState()
          : ListView.builder(
              // bottom padding clears icons row (50) + illustration (293)
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 360),
              physics: const BouncingScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _ItemCard(
                  item: items[i],
                  onTap: () => controller.onItemTap(items[i]),
                ),
              ),
            ),
    );
  }
}

// ─────────────────────────────────────────────
//  ITEM CARD
// ─────────────────────────────────────────────

class _ItemCard extends StatelessWidget {
  final ShopItem item;
  final VoidCallback onTap;

  const _ItemCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: _cardBg.withAlpha(210),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          children: [
            _ItemAvatar(imagePath: item.imagePath),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  item.isFree
                      ? const Text(
                          'Free',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        )
                      : Row(
                          children: [
                            Text(
                              '${item.price}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 5),
                            const _CoinDot(size: 18),
                          ],
                        ),
                ],
              ),
            ),
            _ItemActionButton(item: item, onTap: onTap),
          ],
        ),
      ),
    );
  }
}

class _ItemAvatar extends StatelessWidget {
  final String imagePath;

  const _ItemAvatar({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final isNetworkImage = Uri.tryParse(imagePath)?.hasScheme ?? false;

    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: isNetworkImage
            ? Image.network(
                imagePath,
                fit: BoxFit.cover,
                loadingBuilder: (_, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const _ImagePlaceholder();
                },
                errorBuilder: (_, _, _) => const _ImagePlaceholder(),
              )
            : Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const _ImagePlaceholder(),
              ),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _cardBgLight,
      child: const Icon(Icons.sports_soccer, color: Colors.white54, size: 30),
    );
  }
}

class _ShopLoadingState extends StatelessWidget {
  const _ShopLoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator(color: Colors.white));
  }
}

class _ShopErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ShopErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: Colors.white,
              size: 42,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 18),
            GestureDetector(
              onTap: onRetry,
              child: Container(
                height: 42,
                padding: const EdgeInsets.symmetric(horizontal: 22),
                decoration: BoxDecoration(
                  color: _buyBg,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Center(
                  child: Text(
                    'Retry',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShopEmptyState extends StatelessWidget {
  const _ShopEmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Text(
          'No shop items available.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
      ),
    );
  }
}

class _ItemActionButton extends StatelessWidget {
  final ShopItem item;
  final VoidCallback onTap;

  const _ItemActionButton({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (item.status == ItemStatus.equipped) {
      return _PillButton(
        label: 'Equipped',
        icon: IconConstants.icRightSvg,
        color: _equippedBg,
        onTap: null,
      );
    }
    if (item.status == ItemStatus.owned) {
      return _PillButton(
        label: 'Equip',
        icon: IconConstants.icRightSvg,
        color: const Color(0xFF1565C0),
        onTap: onTap,
      );
    }
    return _PillButton(
      label: 'Buy',
      icon: IconConstants.icBuySvg,
      color: _buyBg,
      onTap: onTap,
    );
  }
}

// ─────────────────────────────────────────────
//  REUSABLE PILL BUTTON
// ─────────────────────────────────────────────

class _PillButton extends StatelessWidget {
  final String label;
  final String icon;
  final Color color;
  final VoidCallback? onTap;

  const _PillButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 6),
            CommonWidgets.appIconsSvg(assetName: icon, height: 16, width: 16),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  COIN DOT  (small yellow circle)
// ─────────────────────────────────────────────

class _CoinDot extends StatelessWidget {
  final double size;

  const _CoinDot({this.size = 18});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          colors: [Color(0xFFFFE566), Color(0xFFFFAA00)],
          center: Alignment(-0.3, -0.3),
        ),
        border: Border.all(color: const Color(0xFFFF8800), width: 1),
        boxShadow: [
          BoxShadow(color: _coinYellow.withOpacity(0.5), blurRadius: 4),
        ],
      ),
      child: Icon(
        Icons.monetization_on_rounded,
        color: const Color(0xFFCC6600),
        size: size * 0.65,
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  CATEGORY ICONS ROW
// ─────────────────────────────────────────────

// ─────────────────────────────────────────────
//  CURRENCY TAB
// ─────────────────────────────────────────────

class _CurrencyTab extends StatelessWidget {
  final ShopController controller;

  const _CurrencyTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final packs = controller.currencyPacks;

    return _ScrollWithBottomArt(
      builder: (_, _) => packs.isEmpty
          ? const _ShopEmptyState()
          : ListView.builder(
              // bottom padding clears icons row + illustration
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 360),
              physics: const BouncingScrollPhysics(),
              itemCount: packs.length,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _CurrencyCard(
                  pack: packs[i],
                  onTap: () => controller.onBuyCurrencyPack(packs[i]),
                ),
              ),
            ),
    );
  }
}

// ─────────────────────────────────────────────
//  CURRENCY CARD  — exact match to Figma
// ─────────────────────────────────────────────

class _CurrencyCard extends StatelessWidget {
  final CurrencyPack pack;
  final VoidCallback onTap;

  const _CurrencyCard({required this.pack, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isNetworkImage = Uri.tryParse(pack.coinImagePath)?.hasScheme ?? false;

    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            // ── Coin stack image ───────────────
            SizedBox(
              width: 64,
              height: 64,
              child: isNetworkImage
                  ? Image.network(
                      pack.coinImagePath,
                      fit: BoxFit.contain,
                      loadingBuilder: (_, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return _FallbackCoinStack();
                      },
                      errorBuilder: (_, _, _) => _FallbackCoinStack(),
                    )
                  : Image.asset(
                      pack.coinImagePath,
                      fit: BoxFit.contain,
                      errorBuilder: (_, _, _) => _FallbackCoinStack(),
                    ),
            ),
            const SizedBox(width: 14),

            // ── Coins label + value label ──────
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pack.coinsLabel,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    pack.valueLabel,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            // ── Blue price button ──────────────
            GestureDetector(
              onTap: onTap,
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                decoration: BoxDecoration(
                  color: _priceBtnBg,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: _priceBtnBg.withOpacity(0.45),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    pack.priceLabel,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Fallback painted coin stack (when image missing) ─

class _FallbackCoinStack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: List.generate(3, (i) {
        final bottom = (i * 10).toDouble();
        final width = 48.0 - (i * 4);
        return Positioned(
          bottom: bottom,
          child: Container(
            width: width,
            height: 14,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.lerp(
                    const Color(0xFFFFE566),
                    const Color(0xFFCC8800),
                    i * 0.3,
                  )!,
                  Color.lerp(
                    const Color(0xFFFFAA00),
                    const Color(0xFF885500),
                    i * 0.3,
                  )!,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
