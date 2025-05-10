import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:storymate/routes/app_routes.dart';
import 'package:storymate/services/api_service.dart';

class LoginController extends GetxController {
  final ApiService _apiService = ApiService();

  RxString accessToken = ''.obs;
  RxString userName = ''.obs;
  RxString userBirth = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadStoredToken();
    _loadUserInfo();
  }

  /// 저장된 토큰 불러오기
  Future<void> _loadStoredToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? storedToken = prefs.getString('accessToken');

    if (storedToken != null && storedToken.isNotEmpty) {
      accessToken.value = storedToken;
      print("저장된 액세스 토큰 로드: $storedToken");
    } else {
      print("저장된 액세스 토큰 없음");
    }
  }

  /// 저장된 사용자 정보 불러오기
  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    userName.value = prefs.getString('userName') ?? ""; // 기본값 ""
    userBirth.value = prefs.getString('userBirth') ?? ""; // 기본값 ""
    print("저장된 사용자 정보 로드 완료: 이름=${userName.value}, 생년월일=${userBirth.value}");
  }

  /// 자동 로그인 체크 (토큰이 유효하면 true 반환, 아니면 false 반환)
  Future<bool> checkAutoLogin() async {
    await _loadStoredToken();

    if (accessToken.isNotEmpty) {
      bool isValid = await _apiService.refreshAccessToken();
      return isValid;
    }
    return false;
  }

  /// 카카오 로그인 처리
  Future<void> loginWithKakao({required bool isSignUp}) async {
    try {
      OAuthToken token;
      if (await isKakaoTalkInstalled()) {
        token = await UserApi.instance.loginWithKakaoTalk();
      } else {
        token = await UserApi.instance.loginWithKakaoAccount();
      }

      String accessTokenValue = token.accessToken;
      print("카카오 로그인 성공, accessToken: $accessTokenValue");

      await fetchUserInfo();
      await _apiService.socialLogin("kakao", accessTokenValue);

      // 로그인 후 토큰 저장 및 자동 로그인 체크
      await _loadStoredToken();

      if (isSignUp) {
        Get.offAllNamed(AppRoutes.INFO, arguments: {
          "userName": userName.value,
          "userBirth": userBirth.value,
        });
      } else {
        Get.offAllNamed(AppRoutes.HOME);
      }
    } catch (error) {
      print("카카오 로그인 실패: $error");
    }
  }

  /// 사용자 정보 불러오기
  Future<void> fetchUserInfo() async {
    try {
      User user = await UserApi.instance.me();
      if (user.kakaoAccount?.profile?.nickname != null) {
        userName.value = user.kakaoAccount!.profile!.nickname!;
      }

      // 사용자 이름을 SharedPreferences에 저장
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', userName.value);

      print("사용자 정보: 이름=${userName.value}");
    } catch (error) {
      print("사용자 정보 가져오기 실패: $error");
    }
  }

  /// 로그아웃 (토큰 삭제)
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');

    accessToken.value = '';
    userName.value = '';
    userBirth.value = '';

    print("로그아웃 완료, 저장된 토큰 삭제됨");
    Get.offAllNamed(AppRoutes.SIGNUP);
  }
}
