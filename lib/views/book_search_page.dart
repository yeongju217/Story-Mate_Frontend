import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:storymate/components/custom_card.dart';
import 'package:storymate/components/theme.dart';
import 'package:storymate/view_models/book_search_controller.dart';

class BookSearchPage extends StatelessWidget {
  const BookSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final BookSearchController controller = Get.put(BookSearchController());

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 66.h),
        child: Column(
          children: [
            SizedBox(
              height: 60.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: controller.goBack,
                    child: Icon(Icons.arrow_back_ios_new,
                        color: Color(0xff090A0A)),
                  ),
                  Container(
                    width: 300.w,
                    height: 56.h,
                    decoration: ShapeDecoration(
                      color: Color(0xFF9B9ECF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 20.w,
                        ),
                        Expanded(
                          child: TextField(
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontFamily: 'Jua',
                              fontWeight: FontWeight.w400,
                            ),
                            controller: controller.searchController,
                            decoration: InputDecoration(
                              hintText: '검색어를 입력하세요',
                              hintStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontFamily: 'Jua',
                                fontWeight: FontWeight.w400,
                              ),
                              border: InputBorder.none,
                            ),
                            onChanged: controller.searchBooks,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 10.w),
                          child: GestureDetector(
                            onTap: () {
                              controller.searchBooks(
                                  controller.searchController.text);
                            },
                            child: Icon(Icons.search, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Obx(
              () => controller.keywords.isNotEmpty
                  ? Padding(
                      padding: EdgeInsets.only(left: 20.w),
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: controller.keywords.map((keyword) {
                          return GestureDetector(
                            onTap: () {
                              controller.searchController.text = keyword;
                              controller.searchBooks(keyword);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15.w, vertical: 5.h),
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 1.w, color: AppTheme.primaryColor),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Text(
                                keyword,
                                style: TextStyle(
                                  color: Color(0xFF7C7C7C),
                                  fontSize: 18.sp,
                                  fontFamily: 'Jua',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  : SizedBox(),
            ),
            SizedBox(height: 20.h),
            // 검색 결과 리스트
            Obx(
              () => controller.searchResults.isNotEmpty
                  ? Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.all(10),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              MediaQuery.of(context).size.width > 600 ? 3 : 2,
                          crossAxisSpacing: 30,
                          mainAxisSpacing: 30,
                          childAspectRatio: 3 / 4,
                        ),
                        itemCount: controller.searchResults.length,
                        itemBuilder: (context, index) {
                          final book = controller.searchResults[index];
                          return CustomCard(
                            title: book.title!,
                            tags: book.tags!,
                            coverImage: book.coverImage!,
                            onTap: () {
                              controller.toIntroPage(book.title!);
                            },
                          );
                        },
                      ),
                    )
                  : SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
