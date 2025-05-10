import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:storymate/services/api_service.dart';
import 'package:storymate/views/read/book_read_page.dart';

class BookMoreController extends GetxController {
  final ApiService apiService = ApiService();

  var memos = <dynamic>[].obs;
  var highlights = <dynamic>[].obs;
  var bookmarks = <dynamic>[].obs;

  // 뒤로 가기
  void goBack() {
    Get.back();
  }

  // 현재 탭 인덱스 관리
  var currentTabIndex = 0.obs;
  void setTabIndex(int index) {
    currentTabIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments as Map<String, dynamic>?;
    final int bookId = arguments?['bookId'] ?? -1;

    if (bookId != -1) {
      fetchMemos(bookId); // 화면 초기화 시 메모 불러오기
      fetchHighlights(bookId);
      fetchBookmarks(bookId);
    }
  }

  /// 메모 목록 불러오기 (API 연동)
  Future<void> fetchMemos(int bookId) async {
    try {
      List<Map<String, dynamic>> fetchedMemos =
          await apiService.getBookNotes(bookId);

      // API에서 받아온 메모를 업데이트
      memos.assignAll(fetchedMemos);
      print("[DEBUG] 메모 목록 불러오기 완료: $memos");
    } catch (e) {
      print("[ERROR] 메모 불러오기 실패: $e");
    }
  }

  // 메모 삭제 (API 연동)
  Future<void> removeMemo(int bookId, int noteId, int index) async {
    try {
      await apiService.deleteBookNote(bookId, noteId);
      memos.removeAt(index); // UI 업데이트
      print("[DEBUG] 메모 삭제 완료 (ID: $noteId)");
    } catch (e) {
      print("[ERROR] 메모 삭제 실패: $e");
    }
  }

  /// 하이라이트 목록 불러오기 (API 연동)
  Future<void> fetchHighlights(int bookId) async {
    try {
      List<Map<String, dynamic>> fetchedHighlights =
          await apiService.getBookHighlights(bookId);

      // API에서 받아온 하이라이트를 업데이트
      highlights.assignAll(fetchedHighlights);
      print("[DEBUG] 하이라이트 목록 불러오기 완료: $highlights");
    } catch (e) {
      print("[ERROR] 하이라이트 불러오기 실패: $e");
    }
  }

  // 하이라이트 삭제 (API 연동)
  Future<void> removeHighlights(int bookId, int highlightId, int index) async {
    try {
      await apiService.deleteBookHighlights(bookId, highlightId);
      highlights.removeAt(index); // UI 업데이트
      print("[DEBUG] 하이라이트 삭제 완료 (ID: $highlightId)");
    } catch (e) {
      print("[ERROR] 하이라이트 삭제 실패: $e");
    }
  }

  /// 책갈피 목록 불러오기 (API 연동)
  Future<void> fetchBookmarks(int bookId) async {
    try {
      List<Map<String, dynamic>> fetchedBookmarks =
          await apiService.getBookBookmarks(bookId);

      // API에서 받아온 책갈피를 업데이트
      bookmarks.assignAll(fetchedBookmarks);
      print("[DEBUG] 책갈피 목록 불러오기 완료: $bookmarks");
    } catch (e) {
      print("[ERROR] 책갈피 불러오기 실패: $e");
    }
  }

  // 책갈피 삭제 (API 연동)
  Future<void> removeBookmark(int bookId, int bookmarkId, int index) async {
    try {
      await apiService.deleteBookBookmarks(bookId, bookmarkId);
      bookmarks.removeAt(index); // UI 업데이트
      print("[DEBUG] 책갈피 삭제 완료 (ID: $bookmarkId)");
    } catch (e) {
      print("[ERROR] 책갈피 삭제 실패: $e");
    }
  }

  /// 책갈피 클릭 시 해당 책의 해당 페이지로 이동
  void navigateToPage(int bookId, int position) {
    Get.to(
      () => const BookReadPage(),
      arguments: {
        'bookId': bookId,
        'startPage': position, // 초기 페이지 지정
      },
    );
  }

  // // DateTime -> String 변환 함수
  // String formatDate(DateTime date) {
  //   return DateFormat('yyyy/MM/dd').format(date);
  // }

  // 메모 작성창으로 이동
  void toAddMemo(int bookId) {
    Get.toNamed('/memo', arguments: {
      'bookId': bookId,
    });
  }

  // 메모 추가 메서드 (임시)
  void addMemo(Map<String, dynamic> memo) {
    memos.add(memo);
  }
}
