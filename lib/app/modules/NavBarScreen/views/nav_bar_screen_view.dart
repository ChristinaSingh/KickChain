import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kickchain/app/modules/ProfileSCreen/views/profile_s_creen_view.dart';
import 'package:kickchain/app/modules/SettingScren/views/setting_scren_view.dart';

import '../../InviteFriendsScreen/views/invite_friends_screen_view.dart';
import '../../WalletScreen/views/wallet_screen_view.dart';
import '../../home/views/home_view.dart';
import '../../profile_screen/views/profile_screen_view.dart';
import '../controllers/nav_bar_screen_controller.dart';

// ─────────────────────────────────────────────
//  NAV BAR SCREEN  –  KickChain Soccer Clash
// ─────────────────────────────────────────────

class NavBarScreenView extends GetView<NavBarScreenController> {
  const NavBarScreenView({super.key});

  static const List<_NavItem> _navItems = [
    _NavItem(
      activeIcon: Icons.home_rounded,
      inactiveIcon: Icons.home_outlined,
      label: 'Home',
    ),
    _NavItem(
      activeIcon: Icons.person_add_rounded,
      inactiveIcon: Icons.person_add_outlined,
      label: 'Invite Friends',
    ),
    _NavItem(
      activeIcon: Icons.account_balance_wallet_rounded,
      inactiveIcon: Icons.account_balance_wallet_outlined,
      label: 'Wallet',
    ),
    _NavItem(
      activeIcon: Icons.settings_rounded,
      inactiveIcon: Icons.settings_outlined,
      label: 'Setting',
    ),
    _NavItem(
      activeIcon: Icons.person_rounded,
      inactiveIcon: Icons.person_outline_rounded,
      label: 'Profile',
    ),
  ];

  // ── All pages – IndexedStack keeps each screen's state alive ──
  static const List<Widget> _pages = [
    HomeScreen(),
    InviteFriendsScreenView(),
    WalletScreenView(),
    SettingsScreen(),
    ProfileScreenView2(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF041A0B),
      extendBody: true, // body renders behind the nav bar
      body: Obx(
        () => IndexedStack(
          index: controller.selectedIndex.value,
          children: _pages,
        ),
      ),
      bottomNavigationBar: _KickChainNavBar(
        items: _navItems,
        controller: controller,
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  CUSTOM BOTTOM NAV BAR
// ─────────────────────────────────────────────

class _KickChainNavBar extends StatelessWidget {
  final List<_NavItem> items;
  final NavBarScreenController controller;

  const _KickChainNavBar({required this.items, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selected = controller.selectedIndex.value;

      return Container(
        decoration: const BoxDecoration(
          color: Color(0xFF0A0A0A),
          boxShadow: [
            BoxShadow(
              color: Color(0x50000000),
              blurRadius: 24,
              offset: Offset(0, -6),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 72,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(
                items.length,
                (i) => _NavTile(
                  item: items[i],
                  isActive: i == selected,
                  onTap: () => controller.onNavTap(i),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

// ─────────────────────────────────────────────
//  SINGLE NAV TILE
// ─────────────────────────────────────────────

class _NavTile extends StatelessWidget {
  final _NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  const _NavTile({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        width: 72,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ── Icon with scale animation ─────────
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, anim) =>
                  ScaleTransition(scale: anim, child: child),
              child: isActive
                  ? _ActiveCircleIcon(
                      key: ValueKey('active_${item.label}'),
                      icon: item.activeIcon,
                    )
                  : Padding(
                      key: ValueKey('inactive_${item.label}'),
                      padding: const EdgeInsets.all(11),
                      child: Icon(
                        item.inactiveIcon,
                        color: const Color(0xFF8A8A8A),
                        size: 26,
                      ),
                    ),
            ),
            const SizedBox(height: 2),

            // ── Label ────────────────────────────
            Text(
              item.label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: isActive
                  ? const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.1,
                    )
                  : const TextStyle(
                      color: Color(0xFF8A8A8A),
                      fontSize: 10,
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
//  ACTIVE GREEN GRADIENT CIRCLE ICON
//
//  Matches the uploaded reference exactly:
//    • LinearGradient  #5DCF00 → #0B826F  (top-left to bottom-right)
//    • Solid white border  3.5 px
//    • Green glow box-shadow
// ─────────────────────────────────────────────

class _ActiveCircleIcon extends StatelessWidget {
  final IconData icon;

  const _ActiveCircleIcon({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // White border
        border: Border.all(color: Colors.white, width: 3.5),
        // Green gradient  (top-left bright → bottom-right teal)
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF5DCF00), // bright green
            Color(0xFF0B826F), // teal green
          ],
        ),
        // Soft green glow
        boxShadow: const [
          BoxShadow(
            color: Color(0x665DCF00),
            blurRadius: 14,
            spreadRadius: 1,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: 22),
    );
  }
}

// ─────────────────────────────────────────────
//  NAV ITEM DATA CLASS
// ─────────────────────────────────────────────

class _NavItem {
  final IconData activeIcon;
  final IconData inactiveIcon;
  final String label;

  const _NavItem({
    required this.activeIcon,
    required this.inactiveIcon,
    required this.label,
  });
}
