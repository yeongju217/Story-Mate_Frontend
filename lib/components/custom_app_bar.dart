import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title; // 제목
  final Color backgroundColor; // 배경색
  final Widget? leading; // 왼쪽 아이콘 (옵션)

  const CustomAppBar({
    super.key,
    required this.title,
    required this.backgroundColor,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      automaticallyImplyLeading: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
      ),
      backgroundColor: backgroundColor,
      toolbarHeight: 50.h,
      title: Padding(
        padding: EdgeInsets.only(bottom: 10.h),
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 30.sp,
            fontFamily: 'Jua',
            fontWeight: FontWeight.w400,
            height: 0.73.h,
          ),
        ),
      ),
      leading: leading, // 왼쪽 아이콘
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 15.w, bottom: 10.h),
          child: GestureDetector(
            onTap: () {
              Get.toNamed('/book_search'); // 작품 검색 화면으로 이동
            },
            child: Icon(
              Icons.search,
              size: 30.w,
              color: Colors.white,
            ),
          ),
        ),
      ], // 오른쪽 아이콘들
    );
  }

  // AppBar의 크기 지정
  @override
  Size get preferredSize => Size.fromHeight(50.h);
}
