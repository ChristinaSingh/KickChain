// lib/data/apis/api_models/notification_settings_model.dart

class NotificationSettingsModel {
  final String? id;
  final String? user;
  final bool matchInvites;
  final bool matchResults;
  final bool payouts;
  final bool referralRewards;
  final bool systemUpdates;
  final bool other;
  final String? createdAt;
  final String? updatedAt;

  NotificationSettingsModel({
    this.id,
    this.user,
    this.matchInvites = true,
    this.matchResults = true,
    this.payouts = true,
    this.referralRewards = true,
    this.systemUpdates = true,
    this.other = true,
    this.createdAt,
    this.updatedAt,
  });

  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json) {
    return NotificationSettingsModel(
      id: json['_id'],
      user: json['user'],
      matchInvites: json['matchInvites'] ?? true,
      matchResults: json['matchResults'] ?? true,
      payouts: json['payouts'] ?? true,
      referralRewards: json['referralRewards'] ?? true,
      systemUpdates: json['systemUpdates'] ?? true,
      other: json['other'] ?? true,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'matchInvites': matchInvites,
      'matchResults': matchResults,
      'payouts': payouts,
      'referralRewards': referralRewards,
      'systemUpdates': systemUpdates,
    };
  }

  NotificationSettingsModel copyWith({
    bool? matchInvites,
    bool? matchResults,
    bool? payouts,
    bool? referralRewards,
    bool? systemUpdates,
    bool? other,
  }) {
    return NotificationSettingsModel(
      id: id,
      user: user,
      matchInvites: matchInvites ?? this.matchInvites,
      matchResults: matchResults ?? this.matchResults,
      payouts: payouts ?? this.payouts,
      referralRewards: referralRewards ?? this.referralRewards,
      systemUpdates: systemUpdates ?? this.systemUpdates,
      other: other ?? this.other,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}