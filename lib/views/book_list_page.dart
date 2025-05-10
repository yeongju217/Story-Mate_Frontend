import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:storymate/components/custom_app_bar.dart';
import 'package:storymate/components/custom_card.dart';
import 'package:storymate/components/theme.dart';
import 'package:storymate/view_models/book_list_controller.dart';

class BookListPage extends StatelessWidget {
  const BookListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final BookListController controller = Get.put(BookListController());

    final String category = Get.arguments ?? 'Unknown Category';

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: CustomAppBar(
        leading: Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: GestureDetector(
            onTap: controller.goBack,
            child: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            ),
          ),
        ),
        title: category,
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 정렬 순서 드롭다운
          Obx(() {
            return Padding(
              padding: EdgeInsets.only(top: 19.h, left: 18.w),
              child: Container(
                width: 130.w,
                height: 40.h,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: Color(0xFF9B9ECF)),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: controller.selectedSort.value,
                    icon: Icon(Icons.arrow_drop_down,
                        color: AppTheme.primaryColor),
                    dropdownColor: Colors.white,
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 18.sp,
                      fontFamily: 'Jua',
                      fontWeight: FontWeight.w400,
                      height: 1.10.h,
                    ),
                    menuMaxHeight: 300.h, // 드롭다운 최대 높이
                    borderRadius: BorderRadius.circular(20), // 드롭다운 모서리 둥글게 처리
                    items: controller.sortOptions.map((String value) {
                      final isSelected = value == controller.selectedSort.value;
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                            color: isSelected
                                ? AppTheme.primaryColor
                                : Colors.black, // 선택된 항목 텍스트 색상
                            fontSize: 18.sp,
                            fontFamily: 'Jua',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        controller.changeSortOrder(newValue);
                      }
                    },
                  ),
                ),
              ),
            );
          }),
          // 책 리스트
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 30.w),
              child: Obx(() {
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        MediaQuery.of(context).size.width > 600 ? 3 : 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 20,
                    childAspectRatio: 3 / 4,
                  ),
                  itemCount: controller.filteredBooks.length,
                  itemBuilder: (context, index) {
                    final book = controller.filteredBooks[index];
                    return CustomCard(
                      title: book.title!,
                      tags: book.tags!,
                      coverImage: book.coverImage!,
                      onTap: () {
                        controller.toIntroPage(book.title!);
                      },
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
