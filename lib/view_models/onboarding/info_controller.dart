import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storymate/components/theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InfoController extends GetxController {
  final box = GetStorage(); // GetStorage 인스턴스 생성
  final String baseUrl = dotenv.env['API_URL']!;

  // 사용자 정보 상태
  var userName = ''.obs;
  var selectedDate = Rxn<DateTime>();
  TextEditingController nameController = TextEditingController();

  /// 초기 정보 설정 (카카오에서 받은 값 적용)
  void setInitialInfo(String name, String birth) {
    userName.value = name;
    nameController.text = name;

    if (birth != "0000-00-00") {
      List<String> birthParts = birth.split('-');
      if (birthParts.length == 3) {
        int year = int.tryParse(birthParts[0]) ?? DateTime.now().year;
        int month = int.tryParse(birthParts[1]) ?? 1;
        int day = int.tryParse(birthParts[2]) ?? 1;
        selectedDate.value = DateTime(year, month, day);
      }
    }
  }

  /// 생년월일 선택 함수
  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppTheme.primaryColor,
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      selectedDate.value = picked;
    }
  }

  /// 선택된 날짜를 YYYY.MM.DD 형식으로 반환
  String getFormattedDate() {
    if (selectedDate.value == null) {
      return '0000.00.00'; // 기본값
    }
    final date = selectedDate.value!;
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }

  /// 생년월일 등록 API 호출
  Future<void> registerBirthDate() async {
    if (selectedDate.value == null) {
      Get.snackbar("오류", "생년월일을 선택해주세요.",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      // 저장된 accessToken 불러오기
      final prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      if (accessToken == null || accessToken.isEmpty) {
        print("Access Token 없음");
        Get.snackbar("오류", "로그인이 필요합니다.",
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/member/register-birth-date'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken', // accessToken 추가
        },
        body: json.encode({"birthDate": getFormattedDate()}),
      );

      if (response.statusCode == 200) {
        // 성공 시, 로컬 저장소에도 저장
        box.write("userBirth", getFormattedDate());

        print("생년월일 등록 성공: ${getFormattedDate()}");

        // 다음 화면으로 이동
        Get.toNamed('/terms');
      } else {
        print("생년월일 등록 실패: ${response.body}");
        Get.snackbar("등록 실패", "다시 시도해주세요.",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      print("API 오류 발생: $e");
      Get.snackbar("오류", "서버와 연결할 수 없습니다.",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
