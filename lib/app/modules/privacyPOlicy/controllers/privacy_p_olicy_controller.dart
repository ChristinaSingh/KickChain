import 'package:get/get.dart';
import '../../../data/apis/user_api_service.dart';
import '../../../data/apis/api_models/policy_response_model.dart';

class PrivacyPOlicyController extends GetxController {
  final UserApiService _apiService = UserApiService();
  
  final Rxn<PolicyData> policyData = Rxn<PolicyData>();
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPrivacyPolicy();
  }

  Future<void> fetchPrivacyPolicy() async {
    try {
      isLoading.value = true;
      final response = await _apiService.getPrivacyPolicy();
      if (response.success == true && response.data != null) {
        policyData.value = response.data;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load Privacy Policy: $e');
    } finally {
      isLoading.value = false;
    }
  }
}