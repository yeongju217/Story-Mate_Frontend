import 'package:get/get.dart';
import 'package:storymate/models/book.dart';
import 'package:storymate/view_models/home_controller.dart';

class BookListController extends GetxController {
  final HomeController homeController =
      Get.find<HomeController>(); // HomeController 인스턴스 가져오기
  var filteredBooks = <Book>[].obs;
  var selectedSort = "기본순".obs;

  final List<String> sortOptions = ["기본순", "인기순", "최신순"];

  @override
  void onInit() {
    super.onInit();
    String category = Get.arguments ?? "Unknown Category";
    loadCategoryBooks(category);
  }

  void loadCategoryBooks(String category) {
    filteredBooks.assignAll(homeController.books
        .where((book) => book.category == category)
        .toList());
  }

  // 정렬 기능 추가
  void changeSortOrder(String sortOrder) {
    selectedSort.value = sortOrder;

    if (sortOrder == "기본순") {
      filteredBooks.sort((a, b) => a.title!.compareTo(b.title!)); // 기본순: 제목순
    } else if (sortOrder == "인기순") {
      filteredBooks.shuffle(); // 예제: 랜덤 정렬 (실제 인기순 적용 필요)
    } else if (sortOrder == "최신순") {
      filteredBooks.sort((a, b) => b.title!.compareTo(a.title!)); // 역순 정렬
    }
  }

  void goBack() {
    Get.back();
  }

  void toIntroPage(String title) {
    Get.toNamed('/book_intro', arguments: {'title': title});
  }
}
