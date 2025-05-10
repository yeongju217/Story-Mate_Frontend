import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storymate/components/custom_alert_dialog.dart';
import 'package:storymate/services/api_service.dart';
import 'package:storymate/view_models/read/book_more_controller.dart';

class AddMemoController extends GetxController {
  final ApiService apiService = ApiService();
  final TextEditingController pageController = TextEditingController();
  final TextEditingController memoController = TextEditingController();
  var characterCount = 0.obs;
  late int bookId;
  late bool isEdit;
  late int? noteId;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments as Map<String, dynamic>?;
    bookId = arguments?['bookId'] ?? -1;
    isEdit = arguments?['isEdit'] ?? false;
    noteId = arguments?['noteId'];

    // 수정 모드일 경우 기존 값 불러오기
    if (isEdit) {
      pageController.text = arguments?['position'].toString() ?? '';
      memoController.text = arguments?['content'] ?? '';
      characterCount.value = memoController.text.length;
    }
  }

  void updateCharacterCount(int count) {
    if (count <= 2000) {
      characterCount.value = count;
    } else {
      // 글자 수 초과 시 작성 중지
      memoController.text = memoController.text.substring(0, 2000);
      memoController.selection = TextSelection.fromPosition(
        TextPosition(offset: 2000),
      );
    }
  }

  void goBackWithPrompt(BuildContext context) async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => CustomAlertDialog(
        question: '메모 작성을 중단하시겠습니까?',
      ),
    );
    if (shouldExit ?? false) {
      Get.back();
    }
  }

  /// 메모 추가 또는 수정 (API 연동)
  Future<void> saveMemo() async {
    if (pageController.text.isEmpty || memoController.text.isEmpty) {
      Get.snackbar(
        '오류',
        '페이지와 메모 내용을 모두 입력해주세요.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final int? position = int.tryParse(pageController.text);
    if (position == null) {
      Get.snackbar(
        '오류',
        '유효한 페이지 번호를 입력해주세요.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      if (isEdit && noteId != null) {
        // 수정 모드: 기존 메모 수정
        await apiService.updateBookNote(bookId, noteId!, memoController.text);
      } else {
        // 추가 모드: 새 메모 추가
        await apiService.addBookNote(bookId, position, memoController.text);
      }

      // BookMoreController의 메모 목록 갱신
      final bookMoreController = Get.find<BookMoreController>();
      await bookMoreController.fetchMemos(bookId);

      Get.back(); // 이전 화면으로 돌아가기

      // 알림창 표시
      Get.snackbar(
        '성공',
        isEdit ? '메모가 수정되었습니다.' : '메모가 저장되었습니다.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        '오류',
        '메모 저장 중 오류가 발생했습니다: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
