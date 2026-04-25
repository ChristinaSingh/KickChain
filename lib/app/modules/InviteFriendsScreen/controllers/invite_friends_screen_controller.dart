import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../../common/storage_service.dart';
import '../../../data/apis/api_methods/friend_api_service.dart';
import '../../../data/apis/user_api_service.dart';
import '../../../data/apis/api_models/user_list_response_model.dart';

// UI helper enums (for outgoing chip)
enum InviteStatus { pending, accepted }

class InviteModel {
  final String requestId;
  final String otherUserId; // important for UI state
  final String name;
  final String playerId; // display like @<id>
  final String avatarUrl;
  final bool isIncoming;
  final InviteStatus? outgoingStatus;

  const InviteModel({
    required this.requestId,
    required this.otherUserId,
    required this.name,
    required this.playerId,
    required this.avatarUrl,
    required this.isIncoming,
    this.outgoingStatus,
  });
}

class InviteFriendsController extends GetxController {
  final UserApiService _userApi = UserApiService();
  final FriendApiService _friendApi = FriendApiService();
  final _storage = StorageService();
  final RxInt selectedTab = 0.obs;
  final RxString searchQuery = ''.obs;

  final TextEditingController searchController = TextEditingController();
  final TextEditingController manualAddController = TextEditingController();

  final List<String> tabs = const ['Friends', 'Invites', 'Add Friend'];

  final RxList<UserData> allUsers = <UserData>[].obs;
  final RxBool isLoadingUsers = false.obs;

  final RxList<UserData> friends = <UserData>[].obs;
  final RxList<InviteModel> invites = <InviteModel>[].obs;

  final RxBool isLoadingFriends = false.obs;
  final RxBool isLoadingInvites = false.obs;

  // quick lookup sets
  final RxSet<String> friendIdSet = <String>{}.obs;
  final RxSet<String> outgoingPendingSet = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    final String? userToken = _storage.getToken();

    print("User Token::::::::::: $userToken");

    if (userToken == null || userToken.isEmpty) {
      // _error('User not authenticated. Please log in again.');
      return;
    }
    fetchAllUsers();
    refreshFriends();
    refreshInvites();
  }

  // --------------------------
  // Search filtered lists
  // --------------------------
  List<UserData> get filteredFriends {
    final q = searchQuery.value.trim().toLowerCase();
    if (q.isEmpty) return friends;
    return friends.where((u) {
      final name = (u.name ?? '').toLowerCase();
      final email = (u.email ?? '').toLowerCase();
      final id = (u.id ?? '').toLowerCase();
      return name.contains(q) || email.contains(q) || id.contains(q);
    }).toList();
  }

  List<UserData> get filteredRecommendedUsers {
    final q = searchQuery.value.trim().toLowerCase();
    final list = allUsers;

    if (q.isEmpty) return list;

    return list.where((u) {
      final name = (u.name ?? '').toLowerCase();
      final email = (u.email ?? '').toLowerCase();
      final id = (u.id ?? '').toLowerCase();
      return name.contains(q) || email.contains(q) || id.contains(q);
    }).toList();
  }

  List<InviteModel> get filteredInvites {
    final q = searchQuery.value.trim().toLowerCase();
    if (q.isEmpty) return invites;
    return invites.where((i) {
      final name = i.name.toLowerCase();
      final pid = i.playerId.toLowerCase();
      final oid = i.otherUserId.toLowerCase();
      return name.contains(q) || pid.contains(q) || oid.contains(q);
    }).toList();
  }

  // --------------------------
  // Helpers for UI states
  // --------------------------
  bool isFriend(String? userId) =>
      userId != null && userId.isNotEmpty && friendIdSet.contains(userId);

  bool isOutgoingPending(String? userId) =>
      userId != null &&
      userId.isNotEmpty &&
      outgoingPendingSet.contains(userId);

  // --------------------------
  // API calls
  // --------------------------
  Future<void> fetchAllUsers() async {
    try {
      isLoadingUsers.value = true;
      final response = await _userApi.getAllUsers();
      if (response.success == true && response.data != null) {
        allUsers.assignAll(response.data!);
      } else {
        _error(response.message ?? 'Failed to load users');
      }
    } catch (e) {
      _error('Failed to load users: $e');
    } finally {
      isLoadingUsers.value = false;
    }
  }

  bool _isNoDataMessage(String? msg) {
    final m = (msg ?? '').toLowerCase();
    return m.contains('no friends found') ||
        m.contains('no incoming requests found') ||
        m.contains('no outgoing requests found') ||
        m.contains('no requests found');
  }

  Future<void> refreshFriends() async {
    try {
      isLoadingFriends.value = true;
      final res = await _friendApi.getFriends();

      if (res.success == true) {
        friends.assignAll(res.data);
        friendIdSet.assignAll(
          res.data
              .map((e) => e.id)
              .whereType<String>()
              .where((id) => id.isNotEmpty),
        );
        return;
      }

      if (_isNoDataMessage(res.message)) {
        friends.clear();
        friendIdSet.clear();
        return;
      }

      _error(res.message ?? 'Failed to load friends');
    } catch (e) {
      _error('Failed to load friends: $e');
    } finally {
      isLoadingFriends.value = false;
    }
  }

  Future<void> refreshInvites() async {
    try {
      isLoadingInvites.value = true;

      final incomingRes = await _friendApi.getIncomingRequests();
      final outgoingRes = await _friendApi.getOutgoingRequests();

      final incomingOk =
          incomingRes.success == true || _isNoDataMessage(incomingRes.message);
      final outgoingOk =
          outgoingRes.success == true || _isNoDataMessage(outgoingRes.message);

      if (!incomingOk)
        _error(incomingRes.message ?? 'Failed to load incoming requests');
      if (!outgoingOk)
        _error(outgoingRes.message ?? 'Failed to load outgoing requests');

      final merged = <InviteModel>[];
      final outgoingPendingIds = <String>{};

      // incoming: sender object
      for (final r in incomingRes.data) {
        final u = r.senderUser;
        final otherId = u?.id ?? r.senderId ?? '';
        merged.add(
          InviteModel(
            requestId: r.id ?? '',
            otherUserId: otherId,
            name: u?.name ?? 'Unknown',
            playerId: '@$otherId',
            avatarUrl: u?.avatar ?? '',
            isIncoming: true,
          ),
        );
      }

      // outgoing: receiver object
      for (final r in outgoingRes.data) {
        final u = r.receiverUser;
        final otherId = u?.id ?? r.receiverId ?? '';
        final st = (r.status ?? 'pending').toLowerCase();

        final outgoingStatus = st == 'pending'
            ? InviteStatus.pending
            : InviteStatus.accepted;

        if (outgoingStatus == InviteStatus.pending && otherId.isNotEmpty) {
          outgoingPendingIds.add(otherId);
        }

        merged.add(
          InviteModel(
            requestId: r.id ?? '',
            otherUserId: otherId,
            name: u?.name ?? 'Unknown',
            playerId: '@$otherId',
            avatarUrl: u?.avatar ?? '',
            isIncoming: false,
            outgoingStatus: outgoingStatus,
          ),
        );
      }

      outgoingPendingSet.assignAll(outgoingPendingIds);
      invites.assignAll(merged);
    } catch (e) {
      _error('Failed to load invites: $e');
    } finally {
      isLoadingInvites.value = false;
    }
  }

  // --------------------------
  // UI actions
  // --------------------------
  void selectTab(int idx) => selectedTab.value = idx;

  void onSearchChanged(String v) => searchQuery.value = v;

  /// Invite to Match should be used ONLY for friends
  void onInviteToMatch(UserData user) {
    if (!isFriend(user.id)) {
      _error('You can invite to match only after becoming friends.');
      return;
    }

    final name = user.name ?? 'User';
    Get.snackbar(
      'Invite Sent',
      '$name has been invited to a match!',
      backgroundColor: const Color(0xFF1D8C01),
      colorText: Colors.white,
      borderRadius: 16,
      margin: const EdgeInsets.all(16),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> onSendFriendRequestToUser(UserData user) async {
    final receiverId = user.id;
    if (receiverId == null || receiverId.isEmpty) {
      _error('User id not found');
      return;
    }

    if (isFriend(receiverId)) {
      _error('Already friends. You can invite to match.');
      return;
    }

    if (isOutgoingPending(receiverId)) {
      _error('Request already sent (pending).');
      return;
    }

    try {
      final res = await _friendApi.sendFriendRequest(receiverId);
      if (res.success == true) {
        Get.snackbar(
          'Request Sent',
          res.message ?? 'Friend request sent',
          backgroundColor: const Color(0xFF1D8C01),
          colorText: Colors.white,
          borderRadius: 16,
          margin: const EdgeInsets.all(16),
          snackPosition: SnackPosition.BOTTOM,
        );
        await refreshInvites();
      } else {
        // backend might return 400 with message
        if (_isNoDataMessage(res.message)) return;
        _error(res.message ?? 'Failed to send request');
      }
    } catch (e) {
      _error('Failed to send request: $e');
    }
  }

  // Manual add friend (search by id or name/email)
  Future<void> onSendFriendRequest() async {
    final text = manualAddController.text.trim();
    if (text.isEmpty) return;

    final raw = text.startsWith('@') ? text.substring(1) : text;
    final q = raw.toLowerCase();

    UserData? target;

    // 1) exact ID match
    for (final u in allUsers) {
      if ((u.id ?? '').toLowerCase() == q) {
        target = u;
        break;
      }
    }

    // 2) contains name/email match
    target ??= () {
      for (final u in allUsers) {
        final name = (u.name ?? '').toLowerCase();
        final email = (u.email ?? '').toLowerCase();
        if (name.contains(q) || email.contains(q)) return u;
      }
      return null;
    }();

    if (target == null) {
      _error('User not found. Enter valid Player ID / name / email.');
      return;
    }

    await onSendFriendRequestToUser(target);
    manualAddController.clear();
  }

  Future<void> onAcceptInvite(InviteModel inv) async {
    if (inv.requestId.isEmpty) return;

    try {
      final res = await _friendApi.updateFriendRequestStatus(
        requestId: inv.requestId,
        status: 'accepted',
      );

      if (res.success == true) {
        Get.snackbar(
          'Accepted',
          res.message ?? 'Request accepted',
          backgroundColor: const Color(0xFF1D8C01),
          colorText: Colors.white,
          borderRadius: 16,
          margin: const EdgeInsets.all(16),
          snackPosition: SnackPosition.BOTTOM,
        );
        await refreshInvites();
        await refreshFriends();
      } else {
        _error(res.message ?? 'Failed to accept request');
      }
    } catch (e) {
      _error('Failed to accept request: $e');
    }
  }

  Future<void> onDeclineInvite(InviteModel inv) async {
    if (inv.requestId.isEmpty) return;

    try {
      final res = await _friendApi.updateFriendRequestStatus(
        requestId: inv.requestId,
        status: 'declined',
      );

      if (res.success == true) {
        Get.snackbar(
          'Declined',
          res.message ?? 'Request declined',
          backgroundColor: const Color(0xFF8C0101),
          colorText: Colors.white,
          borderRadius: 16,
          margin: const EdgeInsets.all(16),
          snackPosition: SnackPosition.BOTTOM,
        );
        await refreshInvites();
      } else {
        _error(res.message ?? 'Failed to decline request');
      }
    } catch (e) {
      _error('Failed to decline request: $e');
    }
  }

  Future<void> onUnfriend(UserData friend) async {
    final id = friend.id;
    if (id == null || id.isEmpty) return;

    try {
      final res = await _friendApi.unfriend(id);
      if (res.success == true) {
        Get.snackbar(
          'Unfriended',
          res.message ?? 'User removed from friends',
          backgroundColor: const Color(0xFF1D8C01),
          colorText: Colors.white,
          borderRadius: 16,
          margin: const EdgeInsets.all(16),
          snackPosition: SnackPosition.BOTTOM,
        );
        await refreshFriends();
      } else {
        _error(res.message ?? 'Failed to unfriend');
      }
    } catch (e) {
      _error('Failed to unfriend: $e');
    }
  }

  void onShareInviteLink() {
    Share.share(
      'Join me on KickChain! Use my link to get a bonus: https://kickchain.io/invite/user123',
    );
  }

  void onOpenTelegramContacts() {
    Get.snackbar(
      'Telegram',
      'Opening Telegram contacts…',
      backgroundColor: const Color(0xFF0088CC),
      colorText: Colors.white,
      borderRadius: 16,
      margin: const EdgeInsets.all(16),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _error(String msg) {
    Get.snackbar(
      'Error',
      msg,
      backgroundColor: const Color(0xFF8C0101),
      colorText: Colors.white,
      borderRadius: 16,
      margin: const EdgeInsets.all(16),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    manualAddController.dispose();
    super.onClose();
  }
}
