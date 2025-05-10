import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:storymate/components/book_app_bar.dart';
import 'package:storymate/components/theme.dart';
import 'package:storymate/view_models/read/book_more_controller.dart';
import 'package:storymate/view_models/read/book_read_controller.dart';

class BookMorePage extends StatelessWidget {
  const BookMorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final BookMoreController controller = Get.put(BookMoreController());
    final BookReadController bookReadController =
        Get.find<BookReadController>();

    // Get.arguments로 전달받은 데이터를 title로 사용
    final arguments = Get.arguments;
    final String title =
        (arguments is Map<String, dynamic> && arguments.containsKey('title'))
            ? arguments['title']
            : '작품 제목';
    final int bookId =
        (arguments is Map<String, dynamic> && arguments.containsKey('bookId'))
            ? arguments['bookId']
            : -1;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: BookAppBar(
          title: title,
          onLeadingTap: () => controller.goBack(),
        ),
        floatingActionButton: Obx(() {
          if (controller.currentTabIndex.value == 2) {
            // 메모 탭일 경우 플로팅 버튼 표시
            return GestureDetector(
              onTap: () => controller.toAddMemo(bookId),
              child: Container(
                width: 70.w,
                height: 70.h,
                decoration: ShapeDecoration(
                  color: const Color(0xFF9B9ECF),
                  shape: const OvalBorder(),
                  shadows: [
                    const BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 4,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 30.w,
                ),
              ),
            );
          } else {
            // 다른 탭일 경우 플로팅 버튼 숨기기
            return SizedBox.shrink(); // 빈 위젯 반환
          }
        }),
        body: Column(
          children: [
            // 탭바
            TabBar(
              onTap: (index) => controller.setTabIndex(index),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 2.5,
              indicatorColor: AppTheme.primaryColor,
              labelColor: AppTheme.primaryColor,
              unselectedLabelColor: Colors.black,
              labelStyle: TextStyle(
                fontSize: 15.sp,
                fontFamily: 'Nanum',
                fontWeight: FontWeight.w600,
                height: 1.33.h,
                letterSpacing: -0.23.w,
              ),
              tabs: [
                Tab(
                  text: '하이라이트',
                ),
                Tab(
                  text: '책갈피',
                ),
                Tab(
                  text: '메모',
                ),
              ],
            ),
            // 탭바 컨텐츠
            Expanded(
              child: TabBarView(
                children: [
                  // 하이라이트 탭
                  TabContents(
                    controller: controller,
                    tab: controller.highlights,
                    bookId: bookId,
                  ),
                  // 책갈피 탭
                  BookmarkTabContents(
                    controller: controller,
                    bookReadController: bookReadController,
                    bookId: bookId,
                  ),
                  // 메모 탭
                  MemoTabContents(
                    controller: controller,
                    bookId: bookId,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 책갈피 탭 내용
class BookmarkTabContents extends StatelessWidget {
  final int bookId;
  final dynamic bookReadController;

  const BookmarkTabContents({
    super.key,
    required this.controller,
    required this.bookReadController,
    required this.bookId,
  });

  final BookMoreController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 30.w,
          mainAxisSpacing: 20.h,
          childAspectRatio: 0.8,
        ),
        itemCount: controller.bookmarks.length,
        itemBuilder: (context, index) {
          final bookmark = controller.bookmarks[index];
          final position = bookmark['position'];
          final id = bookmark['id'];

          return GestureDetector(
            onTap: () => controller.navigateToPage(
                bookId, position), // 책갈피 클릭 시 해당 페이지로 이동
            child: Column(
              children: [
                Stack(
                  children: [
                    // 배경 컨테이너
                    Container(
                      height: 165.h,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(width: 1, color: Colors.black),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Stack(
                          children: [
                            // 책갈피 내용 미리보기 (어둡게 처리)
                            Positioned.fill(
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 5.w, sigmaY: 5.h),
                                child: Container(
                                  color: Colors.black.withOpacity(0.1),
                                ),
                              ),
                            ),
                            // 내용 텍스트
                            Positioned.fill(
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    bookReadController.getPagePreview(position),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12.sp,
                                      fontFamily: 'Nanum',
                                      fontWeight: FontWeight.w400,
                                      height: 1.33.h,
                                      letterSpacing: -0.23.w,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    maxLines: 4, // 미리보기 최대 줄 수
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // 삭제 버튼
                    Positioned(
                      right: 10.w,
                      top: 10.h,
                      child: GestureDetector(
                        onTap: () {
                          controller.removeBookmark(bookId, id, index);
                        },
                        child: const Icon(
                          Icons.delete,
                          color: Color.fromARGB(255, 245, 90, 79),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.h,
                ),
                // 페이지 번호
                Text(
                  'p.$position',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontFamily: 'Nanum',
                    fontWeight: FontWeight.w600,
                    height: 1.33.h,
                    letterSpacing: -0.23.w,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// 하이라이트 탭 내용
class TabContents extends StatelessWidget {
  final dynamic tab;
  final int bookId;

  const TabContents({
    super.key,
    required this.controller,
    required this.tab,
    required this.bookId,
  });

  final BookMoreController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
        itemCount: controller.highlights.length,
        itemBuilder: (context, index) {
          final highlight = controller.highlights[index];
          final int highlightId = highlight["id"]; // 하이라이트 ID
          final int page = highlight["pageNumber"]; // 시작 쪽수
          final String paragraph = highlight["paragraph"]; // 하이라이트 내용

          return Container(
            margin: EdgeInsets.symmetric(vertical: 10.h),
            padding: EdgeInsets.all(10),
            decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    color: AppTheme.primaryColor,
                  ),
                  borderRadius: BorderRadius.circular(10),
                )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 쪽수와 내용
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.w, vertical: 5.h),
                          decoration: ShapeDecoration(
                            color: AppTheme.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            'p.$page',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.sp,
                              fontFamily: 'Nanum',
                              fontWeight: FontWeight.w400,
                              height: 1.33,
                              letterSpacing: -0.23,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        // 하이라이트 내용
                        SizedBox(
                          width: 220.w,
                          child: Text(
                            paragraph,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.sp,
                              fontFamily: 'Nanum',
                              fontWeight: FontWeight.w600,
                              height: 1.33,
                              letterSpacing: -0.23,
                            ),
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        // 삭제
                        controller.removeHighlights(bookId, highlightId, index);
                      },
                      child: Icon(
                        Icons.delete,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// 메모 탭 UI (실제 API 데이터와 연동)
class MemoTabContents extends StatelessWidget {
  final BookMoreController controller;
  final int bookId;

  const MemoTabContents({
    super.key,
    required this.controller,
    required this.bookId,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
        itemCount: controller.memos.length,
        itemBuilder: (context, index) {
          final memo = controller.memos[index];
          final int noteId = memo["id"]; // 메모 ID
          final int position = memo["position"]; // 쪽수
          final String content = memo["content"]; // 메모 내용

          return GestureDetector(
            onTap: () {
              // 메모 클릭 시 수정 페이지로 이동
              Get.toNamed(
                '/memo',
                arguments: {
                  'isEdit': true, // 수정 모드 활성화
                  'bookId': bookId,
                  'noteId': noteId,
                  'position': position,
                  'content': content,
                },
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10.h),
              padding: EdgeInsets.all(10),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: AppTheme.primaryColor),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 쪽수 표시
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.w, vertical: 5.h),
                        decoration: ShapeDecoration(
                          color: AppTheme.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          "p.$position",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontFamily: 'Nanum',
                            fontWeight: FontWeight.w400,
                            height: 1.33,
                            letterSpacing: -0.23,
                          ),
                        ),
                      ),
                      SizedBox(width: 20.w),
                      // 메모 내용
                      Expanded(
                        child: Text(
                          content,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.sp,
                            fontFamily: 'Nanum',
                            fontWeight: FontWeight.w600,
                            height: 1.33,
                            letterSpacing: -0.23,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      // 삭제 버튼
                      GestureDetector(
                        onTap: () {
                          controller.removeMemo(bookId, noteId, index);
                        },
                        child: Icon(
                          Icons.delete,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
