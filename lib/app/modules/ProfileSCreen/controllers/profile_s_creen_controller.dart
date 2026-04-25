import 'package:get/get.dart';

class ProfileScreenController extends GetxController {

  final RxInt count = 0.obs;
  // ── Profile data ─────────────────────────────────────────────────────────
  final RxString username   = '@AlexGoal'.obs;
  final RxInt    level      = 6.obs;
  final RxInt    currentXP  = 340.obs;
  final RxInt    maxXP      = 500.obs;

  // ── Statistics ────────────────────────────────────────────────────────────
  final RxInt    totalMatches   = 124.obs;
  final RxInt    totalWins      = 68.obs;
  final RxString winRate        = '55%'.obs;
  final RxString totalEarnings  = '0'.obs;

  // ── Achievements ─────────────────────────────────────────────────────────
  final RxList<AchievementModel> achievements = <AchievementModel>[
    AchievementModel(label: 'First Win',     emoji: '🏆', unlocked: true),
    AchievementModel(label: '10 Matches',    emoji: '🎯', unlocked: true),
    AchievementModel(label: 'Crypto Player', emoji: '🦊', unlocked: false),
    AchievementModel(label: 'Win Streak 5',  emoji: '🔥', unlocked: false),
    AchievementModel(label: '100 Wins',      emoji: '⭐', unlocked: false),
    AchievementModel(label: 'Legendary',     emoji: '👑', unlocked: false),
  ].obs;

  // ── Recent Matches ────────────────────────────────────────────────────────
  final RxList<MatchModel> recentMatches = <MatchModel>[
    MatchModel(won: true,  timeAgo: '2 Hours Ago', score: '3-2', coins:  450),
    MatchModel(won: false, timeAgo: '2 Hours Ago', score: '4-1', coins: -100),
    MatchModel(won: false, timeAgo: '3 Hours Ago', score: '4-1', coins: -100),
    MatchModel(won: true,  timeAgo: '5 Hours Ago', score: '1-2', coins:  800),
    MatchModel(won: true,  timeAgo: '2 Hours Ago', score: '3-2', coins:  450),
  ].obs;

  // ── XP progress (0.0 → 1.0) ──────────────────────────────────────────────
  double get xpProgress => currentXP.value / maxXP.value;




  void onEditProfile() {
    // TODO: navigate to edit profile
  }

  void increment() => count.value++;
}

// ── Data models ───────────────────────────────────────────────────────────────
class AchievementModel {
  final String label;
  final String emoji;
  final bool   unlocked;
  AchievementModel({required this.label, required this.emoji, required this.unlocked});
}

class MatchModel {
  final bool   won;
  final String timeAgo;
  final String score;
  final int    coins;
  MatchModel({required this.won, required this.timeAgo, required this.score, required this.coins});
}