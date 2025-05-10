import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  final Dio dio = Dio(BaseOptions(baseUrl: dotenv.env['API_URL']!));

  ApiClient() {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        String? accessToken = prefs.getString('accessToken');

        if (accessToken != null && accessToken.isNotEmpty) {
          options.headers["Authorization"] = "Bearer $accessToken";
        }

        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401) {
          // 401 에러 발생 시 토큰 갱신 후 재시도
          bool success = await refreshAccessToken();
          if (success) {
            return handler.resolve(await dio.fetch(e.requestOptions));
          }
        }
        return handler.next(e);
      },
    ));
  }

  /// 토큰 갱신
  Future<bool> refreshAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? refreshToken = prefs.getString('refreshToken');

    if (refreshToken == null) {
      print("리프레시 토큰 없음. 로그아웃 필요.");
      return false;
    }

    try {
      final response =
          await dio.post("/auth/reissue", data: {"refreshToken": refreshToken});

      if (response.statusCode == 200) {
        String newAccessToken = response.data["accessToken"];
        await prefs.setString('accessToken', newAccessToken);
        print("새 accessToken 발급 완료");
        return true;
      } else {
        print("accessToken 갱신 실패: ${response.data}");
        return false;
      }
    } catch (e) {
      print("토큰 갱신 중 오류 발생: $e");
      return false;
    }
  }
}
