import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:storymate/components/theme.dart';

class BookAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title; // 작품 제목
  final Function() onLeadingTap; // 뒤로가기 클릭 시
  final bool? isActionVisible; // action[] 가시성
  final bool? bookmarkActive; // 북마크 토글
  final Function()? onBookmarkTap; // 북마크 탭 클릭 시
  final Function()? onMoreTap; // 더보기 탭 클릭 시

  const BookAppBar({
    super.key,
    required this.title,
    required this.onLeadingTap,
    this.isActionVisible = false,
    this.onBookmarkTap,
    this.onMoreTap,
    this.bookmarkActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.backgroundColor,
      leading: GestureDetector(
        onTap: onLeadingTap,
        child: Icon(Icons.arrow_back_ios_new),
      ),
      centerTitle: false,
      title: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: 20.sp,
          fontFamily: 'Nanum',
          fontWeight: FontWeight.w600,
          height: 1.h,
          letterSpacing: -0.23.w,
        ),
      ),
      actions: isActionVisible!
          ? [
              Padding(
                padding: EdgeInsets.only(right: 10.w),
                child: GestureDetector(
                  onTap: onBookmarkTap,
                  child: Icon(
                    bookmarkActive! ? Icons.bookmark : Icons.bookmark_border,
                    color:
                        bookmarkActive! ? AppTheme.primaryColor : Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 10.w),
                child: GestureDetector(
                  onTap: onMoreTap,
                  child: Icon(Icons.more_vert),
                ),
              ),
            ]
          : null,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1.0),
        child: Container(
          height: 0.5.h,
          color: Color(0xffa2a2a2),
        ),
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight((56.0 + 1.0).h); // AppBar 높이 + Border
}
