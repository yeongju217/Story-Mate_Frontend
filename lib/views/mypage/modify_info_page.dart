import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:storymate/components/theme.dart';
import 'package:storymate/view_models/mypage/modify_info_controller.dart';

class ModifyInfoPage extends StatelessWidget {
  const ModifyInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ModifyInfoController controller = Get.put(ModifyInfoController());

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        backgroundColor: AppTheme.backgroundColor,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Icon(Icons.arrow_back_ios_new),
        ),
        centerTitle: true,
        title: Text(
          '내 정보 수정',
          style: TextStyle(
            color: Colors.black,
            fontSize: 25.sp,
            fontFamily: 'Jua',
            fontWeight: FontWeight.w400,
            height: 0.80.h,
            letterSpacing: -0.23.w,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 0.5.h,
            color: Color(0xffa2a2a2),
          ),
          Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.4.h),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 40.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '이름 : ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25.sp,
                          fontFamily: 'Jua',
                          fontWeight: FontWeight.w400,
                          height: 0.80.h,
                          letterSpacing: -0.23.w,
                        ),
                      ),
                      Container(
                        width: 190.w,
                        height: 50.h,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                width: 1.w, color: AppTheme.primaryColor),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: TextField(
                            controller: controller.nameController, // 변경된 부분
                            onChanged: (value) {
                              controller.username.value = value;
                            },
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25.sp,
                              fontFamily: 'Jua',
                              fontWeight: FontWeight.w400,
                              height: 0.80.h,
                              letterSpacing: -0.23.w,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '생년월일 : ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25.sp,
                        fontFamily: 'Jua',
                        fontWeight: FontWeight.w400,
                        height: 0.80.h,
                        letterSpacing: -0.23.w,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => controller.selectDate(context),
                      child: Container(
                        width: 190.w,
                        height: 50.h,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                width: 1.w, color: AppTheme.primaryColor),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 13.h),
                          child: Obx(
                            () => Text(
                              // 기존 생년월일이 있으면 표시, 없으면 기본값
                              controller.selectedDate.value != null
                                  ? controller.getFormattedDate()
                                  : "0000.00.00",
                              style: TextStyle(
                                color: controller.selectedDate.value != null
                                    ? Colors.black
                                    : Color(0xFF7C7C7C),
                                fontSize: 25.sp,
                                fontFamily: 'Jua',
                                fontWeight: FontWeight.w400,
                                height: 0.80.h,
                                letterSpacing: -0.23.w,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Container(
                  width: 164.w,
                  height: 50.h,
                  decoration: ShapeDecoration(
                    color: AppTheme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      controller.updateUserInfo();
                    },
                    child: Center(
                      child: Text(
                        '수정하기',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.h,
                          fontFamily: 'Jua',
                          fontWeight: FontWeight.w400,
                          letterSpacing: -0.23.w,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
