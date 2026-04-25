import 'package:get/get.dart';

// ─────────────────────────────────────────────
//  PLAYER MODEL
// ─────────────────────────────────────────────

class LeaderboardPlayer {
  final int rank;
  final String name;
  final String avatarUrl;
  final int score;

  const LeaderboardPlayer({
    required this.rank,
    required this.name,
    required this.avatarUrl,
    required this.score,
  });

  String get formattedScore {
    if (score >= 1000) {
      final k = score / 1000;
      return '${k % 1 == 0 ? k.toInt() : k.toStringAsFixed(1)}k';
    }
    return score.toString();
  }
}

// ─────────────────────────────────────────────
//  LEADERBOARD CONTROLLER
// ─────────────────────────────────────────────

class LeaderboardController extends GetxController {

  final count = 0.obs;


  final RxInt selectedTab = 1.obs; // 0=All Time, 1=Monthly, 2=Today
  final List<String> tabs = ['All Time', 'Monthly', 'Today'];

  // ── Mock data — swap with API later ──────────
  final _allTime = <LeaderboardPlayer>[
    LeaderboardPlayer(rank: 1, name: 'Kaiya Saris',      avatarUrl: 'https://randomuser.me/api/portraits/men/75.jpg',   score: 200430),
    LeaderboardPlayer(rank: 2, name: 'Jocelyn Aminoff',  avatarUrl: 'https://randomuser.me/api/portraits/women/44.jpg', score: 23845),
    LeaderboardPlayer(rank: 3, name: 'Ryan Vetrovs',     avatarUrl: 'https://randomuser.me/api/portraits/women/12.jpg', score: 10450),
    LeaderboardPlayer(rank: 4, name: 'Brandon Aminoff',  avatarUrl: 'https://randomuser.me/api/portraits/men/32.jpg',   score: 11000),
    LeaderboardPlayer(rank: 5, name: 'Carla Culhane',    avatarUrl: 'https://randomuser.me/api/portraits/men/55.jpg',   score: 5600),
    LeaderboardPlayer(rank: 6, name: 'Ryan Culhane',     avatarUrl: 'https://randomuser.me/api/portraits/men/41.jpg',   score: 4200),
    LeaderboardPlayer(rank: 7, name: 'Davis Levin',      avatarUrl: 'https://randomuser.me/api/portraits/men/23.jpg',   score: 3500),
    LeaderboardPlayer(rank: 8, name: 'Sofia Mayer',      avatarUrl: 'https://randomuser.me/api/portraits/women/68.jpg', score: 3100),
    LeaderboardPlayer(rank: 9, name: 'Leo Fernandez',    avatarUrl: 'https://randomuser.me/api/portraits/men/61.jpg',   score: 2750),
    LeaderboardPlayer(rank: 10, name: 'Mia Thornton',   avatarUrl: 'https://randomuser.me/api/portraits/women/35.jpg', score: 2100),
  ];

  final _monthly = <LeaderboardPlayer>[
    LeaderboardPlayer(rank: 1, name: 'Kaiya Saris',      avatarUrl: 'https://randomuser.me/api/portraits/men/75.jpg',   score: 200430),
    LeaderboardPlayer(rank: 2, name: 'Jocelyn Aminoff',  avatarUrl: 'https://randomuser.me/api/portraits/women/44.jpg', score: 23845),
    LeaderboardPlayer(rank: 3, name: 'Ryan Vetrovs',     avatarUrl: 'https://randomuser.me/api/portraits/women/12.jpg', score: 10450),
    LeaderboardPlayer(rank: 4, name: 'Brandon Aminoff',  avatarUrl: 'https://randomuser.me/api/portraits/men/32.jpg',   score: 11000),
    LeaderboardPlayer(rank: 5, name: 'Carla Culhane',    avatarUrl: 'https://randomuser.me/api/portraits/men/55.jpg',   score: 5600),
    LeaderboardPlayer(rank: 6, name: 'Ryan Culhane',     avatarUrl: 'https://randomuser.me/api/portraits/men/41.jpg',   score: 4200),
    LeaderboardPlayer(rank: 7, name: 'Davis Levin',      avatarUrl: 'https://randomuser.me/api/portraits/men/23.jpg',   score: 3500),
    LeaderboardPlayer(rank: 8, name: 'Sofia Mayer',      avatarUrl: 'https://randomuser.me/api/portraits/women/68.jpg', score: 3100),
  ];

  final _today = <LeaderboardPlayer>[
    LeaderboardPlayer(rank: 1, name: 'Ryan Culhane',     avatarUrl: 'https://randomuser.me/api/portraits/men/41.jpg',   score: 4200),
    LeaderboardPlayer(rank: 2, name: 'Carla Culhane',    avatarUrl: 'https://randomuser.me/api/portraits/men/55.jpg',   score: 5600),
    LeaderboardPlayer(rank: 3, name: 'Davis Levin',      avatarUrl: 'https://randomuser.me/api/portraits/men/23.jpg',   score: 3500),
    LeaderboardPlayer(rank: 4, name: 'Kaiya Saris',      avatarUrl: 'https://randomuser.me/api/portraits/men/75.jpg',   score: 200430),
    LeaderboardPlayer(rank: 5, name: 'Jocelyn Aminoff',  avatarUrl: 'https://randomuser.me/api/portraits/women/44.jpg', score: 23845),
    LeaderboardPlayer(rank: 6, name: 'Mia Thornton',     avatarUrl: 'https://randomuser.me/api/portraits/women/35.jpg', score: 2100),
  ];

  List<LeaderboardPlayer> get currentList {
    switch (selectedTab.value) {
      case 0: return _allTime;
      case 2: return _today;
      default: return _monthly;
    }
  }

  // Top 3 always pulled from current list
  LeaderboardPlayer? get first  => currentList.isNotEmpty ? currentList[0] : null;
  LeaderboardPlayer? get second => currentList.length > 1 ? currentList[1] : null;
  LeaderboardPlayer? get third  => currentList.length > 2 ? currentList[2] : null;

  // Rows from rank 4 onward
  List<LeaderboardPlayer> get restList =>
      currentList.length > 3 ? currentList.sublist(3) : [];


  void increment() => count.value++;


  void selectTab(int i) => selectedTab.value = i;
}