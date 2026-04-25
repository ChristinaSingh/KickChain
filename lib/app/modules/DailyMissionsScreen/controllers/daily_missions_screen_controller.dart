import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ─────────────────────────────────────────────
//  MISSION MODEL
// ─────────────────────────────────────────────

enum MissionState { inProgress, claimable, claimed }

class MissionModel {
  final String id;
  final String title;
  final String description;
  final int reward;
  final int current;
  final int total;
  final RxInt rxCurrent;
  final Rx<MissionState> state;

  MissionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.reward,
    required this.current,
    required this.total,
    required MissionState initialState,
  })  : rxCurrent = current.obs,
        state = initialState.obs;

  double get progress => total == 0 ? 0 : (rxCurrent.value / total).clamp(0.0, 1.0);

  bool get isComplete => rxCurrent.value >= total;
}

// ─────────────────────────────────────────────
//  DAILY MISSIONS CONTROLLER
// ─────────────────────────────────────────────

class DailyMissionsController extends GetxController {

  final count = 0.obs;
  // ── Countdown timer ──────────────────────────
  final RxString resetTimer = '8h 32m'.obs;
  Timer? _timer;
  int _secondsLeft = 8 * 3600 + 32 * 60;

  // ── Missions list ────────────────────────────
  final missions = <MissionModel>[
    MissionModel(
      id: 'play_3',
      title: 'Play 3 Matches',
      description: 'Complete any 3 matches today',
      reward: 200,
      current: 2,
      total: 3,
      initialState: MissionState.inProgress,
    ),
    MissionModel(
      id: 'win_2',
      title: 'Win 2 Games',
      description: 'Win 2 matches in any mode',
      reward: 350,
      current: 1,
      total: 2,
      initialState: MissionState.inProgress,
    ),
    MissionModel(
      id: 'score_5',
      title: 'Score 5 Goals',
      description: 'Score a total of 5 goals',
      reward: 150,
      current: 5,
      total: 5,
      initialState: MissionState.claimable,
    ),
    MissionModel(
      id: 'daily_login',
      title: 'Daily Login',
      description: 'Login to the game today',
      reward: 100,
      current: 1,
      total: 1,
      initialState: MissionState.claimable,
    ),
  ];

  void claimReward(MissionModel mission) {
    if (mission.state.value != MissionState.claimable) return;
    mission.state.value = MissionState.claimed;
    Get.snackbar(
      '🎉 Reward Claimed!',
      'You earned ${mission.reward} coins for "${mission.title}"',
      backgroundColor: const Color(0xFF1D8C01),
      colorText: Colors.white,
      borderRadius: 16,
      margin: const EdgeInsets.all(16),
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void onInit() {
    super.onInit();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_secondsLeft <= 0) {
        _timer?.cancel();
        resetTimer.value = '0h 0m';
        return;
      }
      _secondsLeft--;
      final h = _secondsLeft ~/ 3600;
      final m = (_secondsLeft % 3600) ~/ 60;
      resetTimer.value = '${h}h ${m}m';
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void increment() => count.value++;
}