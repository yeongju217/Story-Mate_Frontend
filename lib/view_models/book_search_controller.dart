import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:storymate/models/book.dart';
import 'package:storymate/view_models/home_controller.dart';
import 'package:storymate/views/read/book_intro_page.dart';

class BookSearchController extends GetxController {
  final HomeController homeController =
      Get.find<HomeController>(); // HomeController 인스턴스 가져오기
  final TextEditingController searchController = TextEditingController();

  var selectedCategory = '전체'.obs; // 선택된 검색 카테고리
  var categories = ['전체', '서명', '태그']; // 검색 카테고리 목록
  var keywords = ['동화', '교훈', '안데르센', '사랑', '모험', '전통'].obs; // 검색 추천 키워드

  // 검색 결과 리스트 (Book 객체 저장)
  var searchResults = RxList<Book>([]); // RxList<Book>을 명확하게 초기화

  void goBack() {
    Get.back();
  }

  void changeCategory(String category) {
    selectedCategory.value = category;
  }

  // 검색 기능 (제목 & 태그 포함)
  void searchBooks(String query) {
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }

    List<Book> results = homeController.books.where((book) {
      bool matchesTitle =
          book.title!.toLowerCase().contains(query.toLowerCase());
      bool matchesTags = book.tags!
          .any((tag) => tag.toLowerCase().contains(query.toLowerCase()));

      // 검색 카테고리 선택에 따른 필터링
      if (selectedCategory.value == '서명') {
        return matchesTitle;
      } else if (selectedCategory.value == '태그') {
        return matchesTags;
      }
      return matchesTitle || matchesTags; // '전체' 카테고리
    }).toList();

    searchResults.assignAll(results);
  }

  // 작품 소개 페이지로 이동
  void toIntroPage(String title) {
    Get.to(
      () => BookIntroPage(),
      arguments: {
        'title': title,
      },
    );
  }
}
