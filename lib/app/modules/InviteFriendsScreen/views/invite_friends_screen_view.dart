import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glass_kit/glass_kit.dart';

import '../../../common/colors.dart';
import '../../../data/apis/api_models/user_list_response_model.dart';
import '../controllers/invite_friends_screen_controller.dart';

class InviteFriendsScreenView extends GetView<InviteFriendsController> {
  const InviteFriendsScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<InviteFriendsController>()) {
      Get.put(InviteFriendsController());
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const _Background(),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(22, 20, 22, 24),
                  child: Text(
                    'Invite Friends',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: _GlassTabBar(ctrl: controller),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: _GlassSearchBar(ctrl: controller),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Obx(
                        () => _TabContent(
                      tab: controller.selectedTab.value,
                      ctrl: controller,
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

class _Background extends StatelessWidget {
  const _Background();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(-0.25, -0.65),
          radius: 1.35,
          colors: [Color(0xFF1DB800), Color(0xFF0A6400), Color(0xFF041A0B)],
          stops: [0.0, 0.42, 1.0],
        ),
      ),
    );
  }
}

class _GlassTabBar extends StatelessWidget {
  final InviteFriendsController ctrl;
  const _GlassTabBar({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final sel = ctrl.selectedTab.value;
      return LayoutBuilder(
        builder: (context, constraints) {
          return GlassContainer(
            height: 52,
            width: constraints.maxWidth,
            borderRadius: BorderRadius.circular(50),
            blur: 18,
            color: Colors.black.withOpacity(0.25),
            borderColor: Colors.white.withOpacity(0.22),
            borderWidth: 1.2,
            borderGradient: LinearGradient(
              colors: [
                const Color(0xFFa2dba2).withValues(alpha: 0.80),
                const Color(0xFFa2dba2).withValues(alpha: 0.10),
                const Color(0xFFa2dba2).withValues(alpha: 0.10),
                const Color(0xFFa2dba2).withValues(alpha: 0.80),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: const [0.0, 0.10, 0.40, 1.0],
            ),
            padding: const EdgeInsets.all(4),
            child: Row(
              children: List.generate(ctrl.tabs.length, (i) {
                final active = i == sel;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => ctrl.selectTab(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        gradient: active
                            ? const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF5DCF00),
                            Color(0xFF0B826F),
                          ],
                        )
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        ctrl.tabs[i],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          );
        },
      );
    });
  }
}

class _GlassSearchBar extends StatelessWidget {
  final InviteFriendsController ctrl;
  const _GlassSearchBar({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GlassContainer(
          height: 52,
          width: constraints.maxWidth,
          borderRadius: BorderRadius.circular(50),
          blur: 18,
          color: Colors.black.withOpacity(0.20),
          borderColor: const Color(0xFFa2dba2),
          borderGradient: LinearGradient(
            colors: [
              const Color(0xFFa2dba2).withValues(alpha: 0.80),
              const Color(0xFFa2dba2).withValues(alpha: 0.10),
              const Color(0xFFa2dba2).withValues(alpha: 0.10),
              const Color(0xFFa2dba2).withValues(alpha: 0.80),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.0, 0.10, 0.40, 1.0],
          ),
          borderWidth: 1.2,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Icon(Icons.search, color: primaryColor, size: 25),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: ctrl.searchController,
                  onChanged: ctrl.onSearchChanged,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: const InputDecoration(
                    hintText: 'Search by username or ID',
                    hintStyle: TextStyle(color: Colors.white, fontSize: 14),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  cursorColor: const Color(0xFF5DCF00),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TabContent extends StatelessWidget {
  final int tab;
  final InviteFriendsController ctrl;

  const _TabContent({required this.tab, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    switch (tab) {
      case 0:
        return _FriendsTab(ctrl: ctrl);
      case 1:
        return _InvitesTab(ctrl: ctrl);
      case 2:
        return _AddFriendTab(ctrl: ctrl);
      default:
        return const SizedBox.shrink();
    }
  }
}

class _FriendsTab extends StatelessWidget {
  final InviteFriendsController ctrl;
  const _FriendsTab({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (ctrl.isLoadingFriends.value) {
        return const Center(child: CircularProgressIndicator(color: Colors.white));
      }

      final list = ctrl.filteredFriends;
      if (list.isEmpty) {
        return const _EmptyState(
          title: 'No friends yet',
          subtitle: 'Invite players to play together',
        );
      }

      return ListView.separated(
        padding: const EdgeInsets.fromLTRB(22, 4, 22, 28),
        physics: const BouncingScrollPhysics(),
        itemCount: list.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) => _FriendTile(
          friend: list[i],
          onInvite: () => ctrl.onInviteToMatch(list[i]),
          onUnfriend: () => ctrl.onUnfriend(list[i]),
        ),
      );
    });
  }
}

class _FriendTile extends StatelessWidget {
  final UserData friend;
  final VoidCallback onInvite;
  final VoidCallback onUnfriend;

  const _FriendTile({
    required this.friend,
    required this.onInvite,
    required this.onUnfriend,
  });

  @override
  Widget build(BuildContext context) {
    final name = friend.name ?? 'Unknown';
    final email = friend.email ?? '';

    return LayoutBuilder(
      builder: (context, constraints) {
        return GlassContainer(
          height: 76,
          width: constraints.maxWidth,
          borderRadius: BorderRadius.circular(20),
          blur: 14,
          color: Colors.black.withOpacity(0.22),
          borderColor: const Color(0xFFa2dba2),
          borderGradient: LinearGradient(
            colors: [
              const Color(0xFFa2dba2).withValues(alpha: 0.55),
              const Color(0xFFa2dba2).withValues(alpha: 0.08),
              const Color(0xFFa2dba2).withValues(alpha: 0.08),
              const Color(0xFFa2dba2).withValues(alpha: 0.55),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.0, 0.15, 0.60, 1.0],
          ),
          borderWidth: 1.0,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: [
              _Avatar(url: friend.avatar ?? '', name: name, radius: 26),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      email,
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onInvite,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF72E000), Color(0xFF3AAA00)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Text(
                    'Invite to Match',
                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onUnfriend,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white70, width: 1.4),
                  ),
                  child: const Text(
                    'Unfriend',
                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _InvitesTab extends StatelessWidget {
  final InviteFriendsController ctrl;
  const _InvitesTab({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (ctrl.isLoadingInvites.value) {
        return const Center(child: CircularProgressIndicator(color: Colors.white));
      }

      final list = ctrl.filteredInvites;
      final incoming = list.where((i) => i.isIncoming).toList();
      final outgoing = list.where((i) => !i.isIncoming).toList();

      return ListView(
        padding: const EdgeInsets.fromLTRB(22, 4, 22, 28),
        physics: const BouncingScrollPhysics(),
        children: [
          if (incoming.isNotEmpty) ...[
            const _SectionHeader(title: 'Incoming Invites'),
            const SizedBox(height: 12),
            ...incoming.map(
                  (inv) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _IncomingInviteTile(
                  invite: inv,
                  onAccept: () => ctrl.onAcceptInvite(inv),
                  onDecline: () => ctrl.onDeclineInvite(inv),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
          if (outgoing.isNotEmpty) ...[
            const _SectionHeader(title: 'Outgoing Invites'),
            const SizedBox(height: 12),
            ...outgoing.map(
                  (inv) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _OutgoingInviteTile(invite: inv),
              ),
            ),
          ],
          if (incoming.isEmpty && outgoing.isEmpty)
            const _EmptyState(
              title: 'No Invites yet',
              subtitle: "Friend requests will appear here",
            ),
        ],
      );
    });
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
      ),
    );
  }
}

class _IncomingInviteTile extends StatelessWidget {
  final InviteModel invite;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const _IncomingInviteTile({
    required this.invite,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GlassContainer(
          height: 80,
          width: constraints.maxWidth,
          borderRadius: BorderRadius.circular(20),
          blur: 14,
          color: Colors.black.withOpacity(0.22),
          borderColor: const Color(0xFFa2dba2),
          borderGradient: LinearGradient(
            colors: [
              const Color(0xFFa2dba2).withValues(alpha: 0.55),
              const Color(0xFFa2dba2).withValues(alpha: 0.08),
              const Color(0xFFa2dba2).withValues(alpha: 0.08),
              const Color(0xFFa2dba2).withValues(alpha: 0.55),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.0, 0.15, 0.60, 1.0],
          ),
          borderWidth: 1.0,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: [
              _Avatar(url: invite.avatarUrl, name: invite.name, radius: 26),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      invite.name,
                      style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 3),
                    Text(invite.playerId, style: const TextStyle(color: Colors.white60, fontSize: 11)),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onAccept,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF72E000), Color(0xFF3AAA00)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Text('Accept', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onDecline,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white70, width: 1.4),
                  ),
                  child: const Text('Decline', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _OutgoingInviteTile extends StatelessWidget {
  final InviteModel invite;
  const _OutgoingInviteTile({required this.invite});

  @override
  Widget build(BuildContext context) {
    final isPending = invite.outgoingStatus == InviteStatus.pending;

    return LayoutBuilder(
      builder: (context, constraints) {
        return GlassContainer(
          height: 76,
          width: constraints.maxWidth,
          borderRadius: BorderRadius.circular(20),
          blur: 14,
          color: Colors.black.withOpacity(0.22),
          borderColor: const Color(0xFFa2dba2),
          borderGradient: LinearGradient(
            colors: [
              const Color(0xFFa2dba2).withValues(alpha: 0.55),
              const Color(0xFFa2dba2).withValues(alpha: 0.08),
              const Color(0xFFa2dba2).withValues(alpha: 0.08),
              const Color(0xFFa2dba2).withValues(alpha: 0.55),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.0, 0.15, 0.60, 1.0],
          ),
          borderWidth: 1.0,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: [
              _Avatar(url: invite.avatarUrl, name: invite.name, radius: 26),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(invite.name, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 3),
                    Text(invite.playerId, style: const TextStyle(color: Colors.white60, fontSize: 11)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isPending ? const Color(0xFFF97316) : const Color(0xFF4ADE80),
                    width: 1.6,
                  ),
                ),
                child: Text(
                  isPending ? 'Pending' : 'Accepted',
                  style: TextStyle(
                    color: isPending ? const Color(0xFFF97316) : const Color(0xFF4ADE80),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AddFriendTab extends StatelessWidget {
  final InviteFriendsController ctrl;
  const _AddFriendTab({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(22, 4, 22, 28),
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _ManualGlassCard(
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(right: -24, top: -24, child: _SoccerBallDecoration()),
                    const SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Invite via Telegram',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                _FullWidthButton(
                  label: 'Share Invite Link',
                  icon: Icons.chat_bubble_rounded,
                  gradientColors: const [Color(0xFF72E000), Color(0xFF3AAA00)],
                  onTap: ctrl.onShareInviteLink,
                ),
                const SizedBox(height: 14),
                _FullWidthButton(
                  label: 'Open Telegram Contacts',
                  icon: Icons.send_rounded,
                  gradientColors: const [Color(0xFF2AABEE), Color(0xFF0C80C7)],
                  onTap: ctrl.onOpenTelegramContacts,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _ManualGlassCard(
            child: Column(
              children: [
                const Text(
                  'Manual Add Friend',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.1,
                  ),
                ),
                const SizedBox(height: 22),
                _ManualGlassInputField(
                  controller: ctrl.manualAddController,
                  hint: 'Enter Username or Player ID',
                  icon: Icons.person_add_rounded,
                ),
                const SizedBox(height: 18),
                _FullWidthButton(
                  label: 'Send Friend Request',
                  gradientColors: const [Color(0xFF72E000), Color(0xFF3AAA00)],
                  onTap: ctrl.onSendFriendRequest,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.only(left: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Recommended Users',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.1,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Obx(() {
            if (ctrl.isLoadingUsers.value) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              );
            }

            final list = ctrl.filteredRecommendedUsers;
            if (list.isEmpty) {
              return const Center(
                child: Text('No users found', style: TextStyle(color: Colors.white70)),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _UserDataTile(
                user: list[i],
                ctrl: ctrl,
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _UserDataTile extends StatelessWidget {
  final UserData user;
  final InviteFriendsController ctrl;

  const _UserDataTile({required this.user, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final isFriend = ctrl.isFriend(user.id);
    final isPending = ctrl.isOutgoingPending(user.id);

    String label;
    VoidCallback? onTap;
    List<Color> gradient;

    if (isFriend) {
      label = 'Invite to Match';
      onTap = () => ctrl.onInviteToMatch(user);
      gradient = const [Color(0xFF72E000), Color(0xFF3AAA00)];
    } else if (isPending) {
      label = 'Requested';
      onTap = null; // disabled
      gradient = const [Color(0xFFF97316), Color(0xFFB45309)];
    } else {
      label = 'Add Friend';
      onTap = () => ctrl.onSendFriendRequestToUser(user);
      gradient = const [Color(0xFF72E000), Color(0xFF3AAA00)];
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return GlassContainer(
          height: 76,
          width: constraints.maxWidth,
          borderRadius: BorderRadius.circular(20),
          blur: 14,
          color: Colors.black.withOpacity(0.22),
          borderColor: const Color(0xFFa2dba2),
          borderGradient: LinearGradient(
            colors: [
              const Color(0xFFa2dba2).withValues(alpha: 0.55),
              const Color(0xFFa2dba2).withValues(alpha: 0.08),
              const Color(0xFFa2dba2).withValues(alpha: 0.08),
              const Color(0xFFa2dba2).withValues(alpha: 0.55),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.0, 0.15, 0.60, 1.0],
          ),
          borderWidth: 1.0,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: [
              _Avatar(url: user.avatar ?? '', name: user.name ?? '?', radius: 26),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name ?? 'Unknown User',
                      style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '@${user.id ?? ''}',
                      style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w400),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Opacity(
                opacity: onTap == null ? 0.55 : 1,
                child: GestureDetector(
                  onTap: onTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                        colors: gradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Text(
                      label,
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ---- Shared widgets (same as your code) ----

class _ManualGlassCard extends StatelessWidget {
  final Widget child;
  const _ManualGlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: CustomPaint(
          painter: _GlassCardBorderPainter(),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Colors.black.withOpacity(0.30),
            ),
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _ManualGlassInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;

  const _ManualGlassInputField({
    required this.controller,
    required this.hint,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: Colors.black.withOpacity(0.25),
            border: Border.all(
              color: const Color(0xFFa2dba2).withOpacity(0.45),
              width: 1.0,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(
            children: [
              Icon(icon, color: Colors.white54, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: controller,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(color: Colors.white38, fontSize: 14),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  cursorColor: const Color(0xFF5DCF00),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlassCardBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(24));
    final borderPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0x99a2dba2), Color(0x14a2dba2), Color(0x14a2dba2), Color(0x99a2dba2)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0.0, 0.15, 0.60, 1.0],
      ).createShader(rect.outerRect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    canvas.drawRRect(rect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FullWidthButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final List<Color> gradientColors;
  final VoidCallback onTap;

  const _FullWidthButton({
    required this.label,
    this.icon,
    required this.gradientColors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: gradientColors),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class _SoccerBallDecoration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.08),
            border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
          ),
          child: const Icon(Icons.sports_soccer, color: Colors.white30, size: 72),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String url;
  final String name;
  final double radius;

  const _Avatar({required this.url, required this.name, required this.radius});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: const Color(0xFF1A6B00),
      backgroundImage: url.isNotEmpty ? NetworkImage(url) : null,
      onBackgroundImageError: url.isNotEmpty ? (_, __) {} : null,
      child: url.isEmpty
          ? Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: TextStyle(color: Colors.white, fontSize: radius * 0.7, fontWeight: FontWeight.w700),
      )
          : null,
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String title;
  final String subtitle;

  const _EmptyState({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xCCFFFFFF), fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
