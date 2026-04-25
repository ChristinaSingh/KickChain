import 'package:dio/dio.dart';
import 'api_constants/api_url_constants.dart';
import 'api_methods/dio_client.dart';
import 'api_models/faq_response_model.dart';
import 'api_models/policy_response_model.dart';
import 'api_models/shop_items_response_model.dart';
import 'api_models/user_list_response_model.dart';

class UserApiService {
  final Dio _dio = DioClient().dio;

  Future<FaqResponseModel> getFaqs() async {
    try {
      final response = await _dio.get(ApiUrlConstants.endPointOfFaqs);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return FaqResponseModel.fromJson(response.data);
      } else {
        throw Exception('Unexpected status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<PolicyResponseModel> getPrivacyPolicy() async {
    try {
      final response = await _dio.get(ApiUrlConstants.endPointOfPrivacyPolicy);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return PolicyResponseModel.fromJson(response.data);
      } else {
        throw Exception('Unexpected status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<PolicyResponseModel> getTermsConditions() async {
    try {
      final response = await _dio.get(
        ApiUrlConstants.endPointOfTermsAndConditions,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return PolicyResponseModel.fromJson(response.data);
      } else {
        throw Exception('Unexpected status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<UserListResponseModel> getAllUsers() async {
    try {
      final response = await _dio.get(ApiUrlConstants.endPointOfAllUsers);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserListResponseModel.fromJson(response.data);
      } else {
        throw Exception('Unexpected status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<ShopItemsResponseModel> getShopItems(String category) async {
    try {
      final response = await _dio.get(_shopEndpointForCategory(category));
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ShopItemsResponseModel.fromJson(response.data);
      } else {
        throw Exception('Unexpected status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  String _shopEndpointForCategory(String category) {
    switch (category) {
      case 'theme':
        return ApiUrlConstants.endPointOfShopThemes;
      case 'ball':
        return ApiUrlConstants.endPointOfShopBalls;
      case 'puck':
        return ApiUrlConstants.endPointOfShopPucks;
      case 'currency':
        return ApiUrlConstants.endPointOfShopCurrency;
      default:
        return '${ApiUrlConstants.endPointOfShopItems}/$category';
    }
  }

  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Connection timed out. Please try again.');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'] ?? 'Something went wrong.';
        return Exception('Error $statusCode: $message');
      case DioExceptionType.connectionError:
        return Exception('No internet connection. Please check your network.');
      default:
        return Exception('An error occurred: ${e.message}');
    }
  }
}
