import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:storymate/models/book.dart';
import 'package:storymate/services/api_service.dart';
import 'package:storymate/views/read/book_intro_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MyController extends GetxController with WidgetsBindingObserver {
  final _apiService = ApiService();
  final box = GetStorage(); // GetStorage 인스턴스 생성
  final String baseUrl = dotenv.env['API_URL']!;

  // 사용자 정보 상태
  var userName = '사용자'.obs;
  var userBirth = '0000.00.00'.obs;
  var messageCount = 0.obs;

  var readingBooks = <Book>[].obs; // 감상 중인 작품
  var finishedBooks = <Book>[].obs; // 감상한 작품

  // 로컬에 저장된 작품 리스트
  final List<Book> localBooks = [
    Book(
        bookId: 7, title: "시골 쥐 서울 구경", coverImage: "assets/books/fairy_1.png"),
    Book(bookId: 8, title: "미운 아기 오리", coverImage: "assets/books/fairy_2.png"),
    Book(bookId: 3, title: "성냥팔이 소녀", coverImage: "assets/books/fairy_4.png"),
    Book(bookId: 5, title: "엄지공주", coverImage: "assets/books/fairy_5.png"),
    Book(bookId: 2, title: "인어공주", coverImage: "assets/books/fairy_6.png"),
    Book(bookId: 1, title: "운수 좋은 날", coverImage: "assets/books/long_1.png"),
    Book(bookId: 4, title: "심봉사", coverImage: "assets/books/short_2.png"),
    Book(bookId: 6, title: "동백꽃", coverImage: "assets/books/short_3.png"),
    Book(bookId: 9, title: "메밀꽃 필 무렵", coverImage: "assets/books/short_4.png"),
    Book(bookId: 10, title: "날개", coverImage: "assets/books/long_2.png"),
  ];

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    fetchAllData();
    // fetchUserInfo();
    // fetchReadingBooks();
    // fetchFinishedBooks();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  // 앱 상태 감지
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      fetchAllData(); // 앱이 다시 활성화되면 데이터를 새로 불러오기
    }
  }

  // 모든 데이터 새로고침
  Future<void> fetchAllData() async {
    await Future.wait([
      fetchUserInfo(),
      fetchReadingBooks(),
      fetchFinishedBooks(),
    ]);
  }

  /// 감상 중인 작품 목록 조회
  Future<void> fetchReadingBooks() async {
    try {
      final data = await _apiService.fetchBooks('/books/reading');
      readingBooks.assignAll(_mapBooksFromApi(data));

      // 서버 응답 데이터 로그 출력
      print("[DEBUG] 감상 중인 책 목록 응답 데이터: $data");
    } catch (e) {
      print("감상 중인 책 목록 로드 실패: $e");
    }
  }

  /// 감상한 작품 목록 조회
  Future<void> fetchFinishedBooks() async {
    try {
      final data = await _apiService.fetchBooks('/books/finished');
      finishedBooks.assignAll(_mapBooksFromApi(data));

      // 서버 응답 데이터 로그 출력
      print("[DEBUG] 감상한 책 목록 응답 데이터: $data");
    } catch (e) {
      print("감상한 책 목록 로드 실패: $e");
    }
  }

  /// 서버에서 받아온 데이터를 로컬 데이터와 매핑하는 함수
  List<Book> _mapBooksFromApi(List<dynamic> data) {
    return data.map((bookData) {
      String title = bookData['title'];
      List<String> tags = List<String>.from(bookData['tags'] ?? []);

      // 로컬 데이터에서 제목을 기준으로 일치하는 작품 찾기
      Book? matchedBook = localBooks.firstWhereOrNull(
        (book) => _normalizeString(book.title!) == _normalizeString(title),
      );

      return Book(
        bookId: bookData['id'],
        title: matchedBook?.title,
        tags: tags,
        coverImage: matchedBook?.coverImage ?? "assets/default.png",
      );
    }).toList();
  }

  /// 띄어쓰기 무시하고 문자열 비교를 위한 정규화 함수
  String _normalizeString(String text) {
    return text.replaceAll(' ', '').toLowerCase();
  }

  /// 회원 정보 조회 API 호출
  Future<void> fetchUserInfo() async {
    try {
      final userData = await _apiService.fetchUserInfo();

      if (userData != null) {
        userName.value = userData["nickname"] ?? "사용자";
        userBirth.value = userData["birthDate"] ?? "0000.00.00";
        messageCount.value = userData["messageCount"] ?? 0;

        // GetStorage에 저장
        box.write("userName", userName.value);
        box.write("userBirth", userBirth.value);
        box.write("messageCount", messageCount.value);

        print(
            "회원 정보 조회 성공: 이름=${userName.value}, 생년월일=${userBirth.value}, 메시지 개수=${messageCount.value}");
      } else {
        print("회원 정보 조회 실패");
      }
    } catch (e) {
      print("회원 정보 조회 중 오류 발생: $e");
    }
  }

  /// 회원 탈퇴 API 호출
  Future<void> deleteUserAccount() async {
    try {
      bool success = await _apiService.deleteUserAccount();

      if (success) {
        print("회원 탈퇴 성공");

        // 저장된 사용자 데이터 삭제
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        box.erase();

        // 로그아웃 처리 및 회원가입 화면 이동
        Get.snackbar("탈퇴 완료", "회원 탈퇴가 완료되었습니다.",
            backgroundColor: Colors.green, colorText: Colors.white);
        Get.offAllNamed('/sign_up');
      } else {
        Get.snackbar("실패", "회원 탈퇴에 실패했습니다.",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      print("회원 탈퇴 중 오류 발생: $e");
      Get.snackbar("오류", "서버와 연결할 수 없습니다.",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  /// 작품 소개 화면으로 이동
  void toIntroPage(String title) {
    Get.to(() => BookIntroPage(), arguments: {
      'title': title,
    });
  }
}
