import 'package:get/get.dart';
import 'package:storymate/view_models/onboarding/terms_controller.dart';

class TermsDetailController extends GetxController {
  var title = ''.obs;
  var content = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Get.arguments로 받아온 데이터 설정
    final arguments = Get.arguments as Map<String, String>? ?? {};
    setTermsData(
        arguments['title'] ?? '약관', arguments['content'] ?? '내용이 없습니다.');
  }

  void setTermsData(String termsTitle, String termsContent) {
    title.value = termsTitle;
    content.value = termsContent;
  }

  // 동의 버튼 클릭 시 해당 약관 체크
  void agreeToTerms() {
    final TermsController termsController = Get.find<TermsController>();

    if (title.value == '서비스 이용 약관') {
      termsController.serviceAgreement.value = true;
    } else {
      termsController.privacyAgreement.value = true;
    }

    termsController.updateAllCheckedStatus(); // 전체 동의 여부 업데이트
    Get.back(); // 'home'
  }
}
