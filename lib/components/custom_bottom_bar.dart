import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:storymate/components/theme.dart';
import 'package:storymate/routes/app_routes.dart';

class CustomBottomBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5.h),
      child: BottomNavigationBar(
        backgroundColor: Colors.white,
        unselectedLabelStyle: TextStyle(
          color: Color(0xFF7C7C7C),
          fontSize: 12.sp,
          fontFamily: 'Jua',
          fontWeight: FontWeight.w400,
          height: 1.67.h,
          letterSpacing: -0.23.w,
        ),
        selectedLabelStyle: TextStyle(
          color: AppTheme.primaryColor,
          fontSize: 12.sp,
          fontFamily: 'Jua',
          fontWeight: FontWeight.w400,
          height: 1.67.h,
          letterSpacing: -0.23.w,
        ),
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/chat.svg'),
            label: '대화하기',
            activeIcon: SvgPicture.asset('assets/chat_selected.svg'),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/home.svg'),
            label: '홈',
            activeIcon: SvgPicture.asset('assets/home_selected.svg'),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/user.svg'),
            label: '마이페이지',
            activeIcon: SvgPicture.asset('assets/user_selected.svg'),
          ),
        ],
        currentIndex: currentIndex,
        onTap: (index) {
          switch (index) {
            case 0:
              // 대화하기 탭
              Get.offNamed(AppRoutes.CHARACTER_SELECTION);
              break;
            case 1:
              // 홈 탭
              Get.offNamed(AppRoutes.HOME);
              break;
            default:
              // 마이페이지 탭
              Get.offNamed('/my_page');
              break;
          }
        },
      ),
    );
  }
}
