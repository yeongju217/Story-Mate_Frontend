import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ModifyInfoController extends GetxController {
  final box = GetStorage(); // GetStorage 인스턴스 생성
  final String baseUrl = dotenv.env['API_URL']!;

  // 사용자 정보 상태
  var username = ''.obs;
  var selectedDate = Rxn<DateTime>();

  TextEditingController nameController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadUserInfo();
  }

  /// 저장된 사용자 정보를 불러오기
  void loadUserInfo() {
    username.value = box.read("userName") ?? "사용자";
    nameController.text = username.value;

    String birthDate = box.read("userBirth") ?? "0000-00-00";

    // 생년월일이 존재하면 DateTime 객체로 변환하여 selectedDate에 반영
    if (birthDate != "0000-00-00" && birthDate.contains('-')) {
      List<String> parts = birthDate.split('-');
      if (parts.length == 3) {
        int year = int.tryParse(parts[0]) ?? DateTime.now().year;
        int month = int.tryParse(parts[1]) ?? 1;
        int day = int.tryParse(parts[2]) ?? 1;

        selectedDate.value = DateTime(year, month, day);
      }
    } else {
      selectedDate.value = null; // 기본값 유지
    }
  }

  /// 생년월일 선택 함수
  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      selectedDate.value = picked; // 선택된 날짜 저장
    }
  }

  /// 선택된 날짜를 YYYY.MM.DD 형식으로 반환
  String getFormattedDate() {
    if (selectedDate.value == null) {
      return "0000-00-00"; // 기본값
    }
    final date = selectedDate.value!;
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// 회원 정보 수정 API 호출
  Future<void> updateUserInfo() async {
    String formattedBirthDate = getFormattedDate();

    if (formattedBirthDate == "0000.00.00") {
      Get.snackbar("오류", "생년월일을 선택해주세요.",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      // 저장된 accessToken 가져오기
      final prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      if (accessToken == null || accessToken.isEmpty) {
        print("Access Token 없음");
        Get.snackbar("오류", "로그인이 필요합니다.",
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      final response = await http.put(
        Uri.parse('$baseUrl/member/info'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode({
          "nickname": username.value,
          "birthDate": formattedBirthDate,
        }),
      );

      if (response.statusCode == 200) {
        // 성공 시, 로컬 저장소에도 저장
        box.write("userName", username.value);
        box.write("userBirth", formattedBirthDate);

        print("회원 정보 수정 성공: 이름=${username.value}, 생년월일=$formattedBirthDate");

        Get.snackbar("성공", "회원 정보가 수정되었습니다.",
            backgroundColor: Colors.green, colorText: Colors.white);
        Get.offAllNamed('/my_page'); // 마이페이지로 이동
      } else {
        print("회원 정보 수정 실패: ${response.body}");
        Get.snackbar("실패", "회원 정보 수정에 실패했습니다.",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      print("API 오류 발생: $e");
      Get.snackbar("오류", "서버와 연결할 수 없습니다.",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
