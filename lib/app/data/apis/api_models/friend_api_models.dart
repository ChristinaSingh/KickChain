import 'user_list_response_model.dart';

class BasicResponseModel {
  final int? statusCode;
  final dynamic data;
  final String? message;
  final bool? success;

  BasicResponseModel({this.statusCode, this.data, this.message, this.success});

  factory BasicResponseModel.fromJson(Map<String, dynamic> json) {
    return BasicResponseModel(
      statusCode: json['statusCode'] as int?,
      data: json['data'],
      message: json['message'] as String?,
      success: json['success'] as bool?,
    );
  }
}

class FriendRequestActionResponseModel {
  final int? statusCode;
  final FriendRequestItem? data;
  final String? message;
  final bool? success;

  FriendRequestActionResponseModel({
    this.statusCode,
    this.data,
    this.message,
    this.success,
  });

  factory FriendRequestActionResponseModel.fromJson(Map<String, dynamic> json) {
    return FriendRequestActionResponseModel(
      statusCode: json['statusCode'] as int?,
      data: (json['data'] is Map<String, dynamic>)
          ? FriendRequestItem.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      message: json['message'] as String?,
      success: json['success'] as bool?,
    );
  }
}

class FriendRequestsListResponseModel {
  final int? statusCode;
  final List<FriendRequestItem> data;
  final String? message;
  final bool? success;

  FriendRequestsListResponseModel({
    this.statusCode,
    required this.data,
    this.message,
    this.success,
  });

  factory FriendRequestsListResponseModel.fromJson(Map<String, dynamic> json) {
    final raw = json['data'];

    final list = (raw is List)
        ? raw
        .whereType<Map<String, dynamic>>()
        .map(FriendRequestItem.fromJson)
        .toList()
        : <FriendRequestItem>[];

    return FriendRequestsListResponseModel(
      statusCode: json['statusCode'] as int?,
      data: list,
      message: json['message'] as String?,
      success: json['success'] as bool?,
    );
  }
}

class FriendsListResponseModel {
  final int? statusCode;
  final List<UserData> data;
  final String? message;
  final bool? success;

  FriendsListResponseModel({
    this.statusCode,
    required this.data,
    this.message,
    this.success,
  });

  factory FriendsListResponseModel.fromJson(Map<String, dynamic> json) {
    final raw = json['data'];

    final list = (raw is List)
        ? raw.whereType<Map<String, dynamic>>().map(UserData.fromJson).toList()
        : <UserData>[];

    return FriendsListResponseModel(
      statusCode: json['statusCode'] as int?,
      data: list,
      message: json['message'] as String?,
      success: json['success'] as bool?,
    );
  }
}

/// incoming: sender is object, receiver is string
/// outgoing: sender is string, receiver is object
class FriendRequestItem {
  final String? id;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  final String? senderId;
  final String? receiverId;

  final UserData? senderUser;
  final UserData? receiverUser;

  FriendRequestItem({
    this.id,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.senderId,
    this.receiverId,
    this.senderUser,
    this.receiverUser,
  });

  factory FriendRequestItem.fromJson(Map<String, dynamic> json) {
    final sender = json['sender'];
    final receiver = json['receiver'];

    String? senderId;
    UserData? senderUser;
    if (sender is String) {
      senderId = sender;
    } else if (sender is Map<String, dynamic>) {
      senderUser = UserData.fromJson(sender);
      senderId = senderUser.id;
    }

    String? receiverId;
    UserData? receiverUser;
    if (receiver is String) {
      receiverId = receiver;
    } else if (receiver is Map<String, dynamic>) {
      receiverUser = UserData.fromJson(receiver);
      receiverId = receiverUser.id;
    }

    return FriendRequestItem(
      id: json['_id'] as String?,
      status: json['status'] as String?,
      createdAt: json['createdAt'] == null ? null : DateTime.tryParse(json['createdAt']),
      updatedAt: json['updatedAt'] == null ? null : DateTime.tryParse(json['updatedAt']),
      senderId: senderId,
      receiverId: receiverId,
      senderUser: senderUser,
      receiverUser: receiverUser,
    );
  }
}