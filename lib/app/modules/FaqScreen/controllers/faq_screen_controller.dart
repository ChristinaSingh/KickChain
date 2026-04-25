import 'package:get/get.dart';
import '../../../data/apis/user_api_service.dart';
import '../../../data/apis/api_models/faq_response_model.dart';

// ─────────────────────────────────────────────
//  FAQ MODEL (Now using FaqData from response)
// ─────────────────────────────────────────────

// ─────────────────────────────────────────────
//  FAQ CONTROLLER
// ─────────────────────────────────────────────

class FaqController extends GetxController {
  final UserApiService _apiService = UserApiService();
  
  // Currently expanded index; -1 means all collapsed
  final RxInt expandedIndex = (-1).obs;
  
  final RxList<FaqData> faqs = <FaqData>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFaqs();
  }

  Future<void> fetchFaqs() async {
    try {
      isLoading.value = true;
      final response = await _apiService.getFaqs();
      if (response.success == true && response.data != null) {
        faqs.assignAll(response.data!);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load FAQs: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void toggleFaq(int index) {
    expandedIndex.value = expandedIndex.value == index ? -1 : index;
  }
}