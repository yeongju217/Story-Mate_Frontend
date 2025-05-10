import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:storymate/components/custom_app_bar.dart';
import 'package:storymate/components/custom_bottom_bar.dart';
import 'package:storymate/components/custom_card.dart';
import 'package:storymate/components/recommend_card_item.dart';
import 'package:storymate/components/theme.dart';
import 'package:storymate/view_models/home_controller.dart';
import 'package:storymate/models/book.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: CustomAppBar(
        title: 'StoryMate',
        backgroundColor: AppTheme.primaryColor,
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: 1,
      ),
      body: ListView(
        children: [
          SizedBox(height: 20.h),
          Obx(() => _buildCategorySection(
              '동화', controller.getBooksByCategory('동화'), controller)),
          Obx(() => _buildCategorySection(
              '단편 소설', controller.getBooksByCategory('단편 소설'), controller)),
          Obx(() => _buildCategorySection(
              '중/장편 소설', controller.getBooksByCategory('중/장편 소설'), controller)),
          _buildRecommendedSection(),
          SizedBox(
            height: 10.h,
          ),
          _buildPopularByAgeAndGender(),
          SizedBox(height: 25.h),
        ],
      ),
    );
  }

  Widget _buildCategorySection(
      String title, List<Book> books, HomeController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: GestureDetector(
            onTap: () {
              controller.setCategory(title);
            },
            child: Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.sp,
                    fontFamily: 'Jua',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(width: 10.w),
                Icon(Icons.arrow_forward_ios, size: 15.w),
              ],
            ),
          ),
        ),
        SizedBox(height: 180.h, child: _buildBookList(books, controller)),
        SizedBox(height: 20.h),
      ],
    );
  }

  Widget _buildBookList(List<Book> books, HomeController controller) {
    return Padding(
      padding: EdgeInsets.only(left: 10.w),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return Padding(
            padding: EdgeInsets.all(5),
            child: CustomCard(
              title: book.title!,
              tags: book.tags!,
              coverImage: book.coverImage!,
              onTap: () {
                controller.toIntroPage(book.title!);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecommendedSection() {
    final recommendedBook = controller.getRandomBook();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Text(
            '${controller.userName}님을 위한 추천 작품',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.sp,
              fontFamily: 'Jua',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Center(
          child: RecommendCardItem(
            book: recommendedBook,
            isCharacter: false,
          ),
        ),
      ],
    );
  }

  Widget _buildPopularByAgeAndGender() {
    final recommendedBook = controller.getRecommendedBookForAgeAndGender();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            children: [
              Text(
                '${controller.userAgeGroup}',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontSize: 18.sp,
                  fontFamily: 'Jua',
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                '대에게 인기 많아요',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.sp,
                  fontFamily: 'Jua',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        Center(
          child: RecommendCardItem(
            book: recommendedBook,
            isCharacter: true,
            characterId: recommendedBook.characterId,
          ),
        ),
      ],
    );
  }
}
