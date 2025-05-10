import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storymate/routes/app_routes.dart';
import 'package:storymate/view_models/onboarding/login_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final LoginController loginController = Get.find<LoginController>();

  @override
  void initState() {
    super.initState();

    // 앱이 실행된 후 프레임이 그려진 다음 자동 로그인 체크
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAutoLogin();
    });
  }

  /// 저장된 토큰을 확인하여 자동 로그인 여부 판단
  Future<void> _checkAutoLogin() async {
    bool isValid = await loginController.checkAutoLogin();
    if (isValid) {
      Get.offAllNamed(AppRoutes.HOME); // 자동 로그인 성공 시 홈 화면 이동
    } else {
      Get.offAllNamed(AppRoutes.SIGNUP); // 토큰이 없거나 만료되면 회원가입 화면으로 이동
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/logo.png',
          width: 264,
        ),
      ),
    );
  }
}
