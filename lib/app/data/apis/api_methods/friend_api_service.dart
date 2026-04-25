import 'package:dio/dio.dart';
import '../api_constants/api_url_constants.dart';
import 'dio_client.dart';
import '../api_models/friend_api_models.dart';

class FriendApiService {
  final Dio _dio = DioClient().dio;

  Map<String, dynamic> _json(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    return <String, dynamic>{};
  }

  T _parseFromDioException<T>(
    DioException e,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final res = e.response;
    if (res?.data != null) {
      return fromJson(_json(res!.data));
    }
    throw Exception('An unexpected error occurred: ${e.message}');
  }

  Future<FriendRequestActionResponseModel> sendFriendRequest(
    String receiverId,
  ) async {
    try {
      final res = await _dio.post(
        '${ApiUrlConstants.endPointOfSendFriendRequest}/$receiverId',
      );
      return FriendRequestActionResponseModel.fromJson(_json(res.data));
    } on DioException catch (e) {
      return _parseFromDioException(
        e,
        FriendRequestActionResponseModel.fromJson,
      );
    }
  }

  Future<FriendRequestActionResponseModel> updateFriendRequestStatus({
    required String requestId,
    required String status, // accepted | declined
  }) async {
    try {
      final res = await _dio.patch(
        ApiUrlConstants.endPointOfFriendRequestStatus,
        data: {'requestId': requestId, 'status': status},
      );
      return FriendRequestActionResponseModel.fromJson(_json(res.data));
    } on DioException catch (e) {
      return _parseFromDioException(
        e,
        FriendRequestActionResponseModel.fromJson,
      );
    }
  }

  Future<FriendRequestsListResponseModel> getIncomingRequests() async {
    try {
      final res = await _dio.get(
        ApiUrlConstants.endPointOfIncomingFriendRequests,
      );
      return FriendRequestsListResponseModel.fromJson(_json(res.data));
    } on DioException catch (e) {
      return _parseFromDioException(
        e,
        FriendRequestsListResponseModel.fromJson,
      );
    }
  }

  Future<FriendRequestsListResponseModel> getOutgoingRequests() async {
    try {
      final res = await _dio.get(
        ApiUrlConstants.endPointOfOutgoingFriendRequests,
      );
      return FriendRequestsListResponseModel.fromJson(_json(res.data));
    } on DioException catch (e) {
      return _parseFromDioException(
        e,
        FriendRequestsListResponseModel.fromJson,
      );
    }
  }

  Future<FriendsListResponseModel> getFriends() async {
    try {
      final res = await _dio.get(ApiUrlConstants.endPointOfFriends);
      return FriendsListResponseModel.fromJson(_json(res.data));
    } on DioException catch (e) {
      return _parseFromDioException(e, FriendsListResponseModel.fromJson);
    }
  }

  Future<BasicResponseModel> unfriend(String friendId) async {
    try {
      final res = await _dio.delete(
        '${ApiUrlConstants.endPointOfUnfriend}/$friendId',
      );
      return BasicResponseModel.fromJson(_json(res.data));
    } on DioException catch (e) {
      return _parseFromDioException(e, BasicResponseModel.fromJson);
    }
  }

  Future<BasicResponseModel> blockUser(String userId) async {
    try {
      final res = await _dio.post(
        '${ApiUrlConstants.endPointOfBlockUser}/$userId',
      );
      return BasicResponseModel.fromJson(_json(res.data));
    } on DioException catch (e) {
      return _parseFromDioException(e, BasicResponseModel.fromJson);
    }
  }

  Future<BasicResponseModel> unblockUser(String userId) async {
    try {
      final res = await _dio.patch(
        '${ApiUrlConstants.endPointOfUnblockUser}/$userId',
      );
      return BasicResponseModel.fromJson(_json(res.data));
    } on DioException catch (e) {
      return _parseFromDioException(e, BasicResponseModel.fromJson);
    }
  }
}
