import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:storymate/components/theme.dart';
import 'package:storymate/view_models/onboarding/terms_controller.dart';

class TermsPage extends StatefulWidget {
  const TermsPage({super.key});

  @override
  State<TermsPage> createState() => _TermsPageState();
}

class _TermsPageState extends State<TermsPage> {
  final TermsController controller = Get.put(TermsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 35.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30.h,
            ),
            Center(
              child: Image.asset(
                'assets/logo_terms.png',
                width: 300.w,
              ),
            ),
            SizedBox(
              height: 42.h,
            ),
            SvgPicture.asset('assets/terms_text.svg'),
            SizedBox(
              height: 42.h,
            ),
            // 전체 동의 체크박스
            Row(
              children: [
                Obx(() {
                  return GestureDetector(
                    onTap: controller.toggleAllAgreement,
                    child: Icon(
                      controller.allChecked.value
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      size: 30.w,
                    ),
                  );
                }),
                SizedBox(
                  width: 16.w,
                ),
                Text(
                  '모두 동의합니다.',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22.sp,
                    fontFamily: 'Jua',
                    fontWeight: FontWeight.w400,
                    height: 1.40.h,
                    letterSpacing: -0.23.w,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 42.h,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 19.5),
              child: Column(
                children: [
                  // 서비스 이용 약관 동의 체크박스
                  Obx(
                    () => DetailTermsCheckBox(
                      terms: '[필수] 서비스 이용 약관 동의',
                      isChecked: controller.serviceAgreement.value,
                      onTap: () => controller.toServiceTermsDetail(),
                      onCheckToggle: controller.toggleServiceAgreement,
                    ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  // 개인정보 수집 및 이용 동의 체크박스
                  Obx(
                    () => DetailTermsCheckBox(
                      terms: '[필수] 개인정보 수집 및 이용 동의',
                      isChecked: controller.privacyAgreement.value,
                      onTap: () => controller.toPersonalInfoTermsDetail(),
                      onCheckToggle: controller.togglePrivacyAgreement,
                    ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  // 마케팅 정보 수신 동의 체크박스
                  Obx(
                    () => DetailTermsCheckBox(
                      terms: '[선택] 마케팅 정보 수신 동의',
                      isChecked: controller.marketingAgreement.value,
                      isDetailVisible: false,
                      onCheckToggle: controller.toggleMarketingAgreement,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50.h,
            ),
            Center(
              child: Obx(
                () => GestureDetector(
                  onTap: controller.isAllRequiredChecked()
                      ? () {
                          Get.toNamed('/home');
                        }
                      : null,
                  child: Container(
                    width: 300.w,
                    height: 55.h,
                    decoration: ShapeDecoration(
                      color: controller.isAllRequiredChecked()
                          ? AppTheme.primaryColor
                          : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '확인',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.sp,
                          fontFamily: 'Jua',
                          fontWeight: FontWeight.w400,
                          height: 1.40.h,
                          letterSpacing: -0.23.w,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailTermsCheckBox extends StatelessWidget {
  final String terms;
  final bool isChecked;
  final bool? isDetailVisible;
  final Function()? onTap;
  final Function() onCheckToggle;

  const DetailTermsCheckBox({
    super.key,
    required this.terms,
    this.isDetailVisible = true,
    this.onTap,
    required this.onCheckToggle,
    required this.isChecked,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onCheckToggle,
          child: Icon(
            isChecked ? Icons.check_box : Icons.check_box_outline_blank,
            size: 20.w,
          ),
        ),
        SizedBox(
          width: 5.w,
        ),
        Text(
          terms,
          style: TextStyle(
            color: Colors.black,
            fontSize: 14.sp,
            fontFamily: 'Jua',
            fontWeight: FontWeight.w400,
            height: 1.94.h,
            letterSpacing: -0.23.w,
          ),
        ),
        SizedBox(
          width: 5.w,
        ),
        isDetailVisible!
            ? // 세부 내용 보기 버튼
            GestureDetector(
                onTap: onTap,
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 15.sp,
                ),
              )
            : SizedBox(),
      ],
    );
  }
}
