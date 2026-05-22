import 'package:get/get.dart';
import '../../../common/storage_service.dart';
import '../../../data/apis/user_api_service.dart';
import '../../../data/apis/api_models/policy_response_model.dart';

class TermsOfServiceController extends GetxController {
  final UserApiService _apiService = UserApiService();
  final _storage = StorageService();
  final Rxn<PolicyData> termsData = Rxn<PolicyData>();
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTermsAndConditions();
  }

  Future<void> fetchTermsAndConditions() async {
    try {
      isLoading.value = true;
      final response = await _apiService.getTermsConditions();
      if (response.success == true && response.data != null) {
        termsData.value = response.data;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load Terms & Conditions: $e');
    } finally {
      isLoading.value = false;
    }
  }
}