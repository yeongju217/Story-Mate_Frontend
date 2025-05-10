// payment_controller.dart
import 'package:get/get.dart';
import 'package:storymate/services/api_service.dart';

class PaymentController extends GetxController {
  final ApiService apiService = ApiService();
  RxString? tid = ''.obs; // 결제 고유 ID
  RxString paymentUrl = ''.obs; // 결제 페이지 URL 저장
  RxString currentUrl = ''.obs;
  RxBool isLoading = false.obs;

  Future<void> preparePayment(int productId) async {
    isLoading.value = true;
    final response = await apiService.prepareKakaoPay(productId);
    print("결제 준비 응답: $response"); // 응답 로그 출력
    if (response != null) {
      tid!.value = response['tid'];
      paymentUrl.value = response['next_redirect_mobile_url'] ??
          response['next_redirect_pc_url'] ??
          '';
      print("모바일 리디렉션 URL: ${paymentUrl.value}");
    } else {
      print("결제 준비 실패 또는 응답 없음");
    }
    isLoading.value = false;
  }

  // 카카오페이 결제 승인 요청
  Future<void> approvePayment(String pgToken) async {
    print('서버로 결제 승인 요청 (pg_token): $pgToken');
    if (tid == null || tid!.isEmpty) return;

    final response = await apiService.approveKakaoPay(tid!.value, pgToken);

    if (response != null) {
      print("결제 승인 응답: $response");
      Get.offNamed('my_page/payments/success', arguments: response);
    } else {
      print("결제 승인 실패");
      Get.offNamed('my_page/payments/fail');
    }
  }
}
