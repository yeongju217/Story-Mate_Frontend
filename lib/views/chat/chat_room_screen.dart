import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({super.key});

  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  List<dynamic> messages = [];
  bool isLoading = true;
  late int roomId;
  String bookTitle = "채팅방"; // 기본값 설정
  String myName = "나"; // 기본 사용자 이름 설정

  @override
  void initState() {
    super.initState();
    initializeArguments();
    fetchChatMessages();
    fetchUserName();
  }

  // Get.arguments 초기화 및 예외 처리
  void initializeArguments() {
    final arguments = Get.arguments;

    if (arguments == null || arguments is! Map<String, dynamic>) {
      print("Get.arguments가 null이거나 올바르지 않은 형식입니다!");
      roomId = 0;
      bookTitle = "채팅방"; // 기본값
      return;
    }

    roomId = arguments["roomId"] ?? 0;
    bookTitle = arguments["bookTitle"] ?? "채팅방";

    print("채팅방 ID: $roomId | 책 제목: $bookTitle");
  }

  // SharedPreferences에서 토큰 가져오기
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  // SharedPreferences에서 로그인한 사용자의 이름 가져오기
  Future<void> fetchUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      myName = prefs.getString('userName') ?? "나";
    });
  }

  // 채팅 메시지 가져오기 (GET /api/chat-messages/{roomId})
  Future<void> fetchChatMessages() async {
    setState(() {
      isLoading = true;
    });

    final token = await getToken();
    if (token == null) {
      print("토큰이 없습니다. 로그인 후 다시 시도해주세요.");
      setState(() => isLoading = false);
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(
            'https://be.dev.storymate.site/api/chat-messages/$roomId?page=0&size=20'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      String decodedResponse = utf8.decode(response.bodyBytes);
      final responseData = json.decode(decodedResponse);

      print("서버 응답: $decodedResponse"); // 디버깅용

      if (response.statusCode == 200) {
        final List<dynamic> chatMessages =
            responseData['data']['chatMessages'] ?? [];

        setState(() {
          messages = chatMessages;
          print("불러온 메시지 개수: ${messages.length}");
        });
      } else {
        print("채팅 메시지 조회 실패: ${response.statusCode}");
        print("서버 응답: $decodedResponse");
      }
    } catch (e) {
      print("채팅 메시지 조회 중 오류 발생: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(bookTitle)),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : messages.isEmpty
              ? const Center(child: Text("이전 대화가 없습니다."))
              : ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final sender = message['sender'] ?? "알 수 없음";
                    final content = message['content'] ?? "";
                    final timestamp = message['timestamp'] ?? "";

                    // `testUser` 또는 로그인한 사용자의 이름이면 "나"로 변경
                    bool isMyMessage = sender == "testUser" || sender == myName;
                    String displaySender = isMyMessage ? "나" : sender;

                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(displaySender[0]),
                      ),
                      title: Text(
                        displaySender,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(content),
                      trailing: timestamp.contains("T")
                          ? Text(timestamp
                              .split("T")[1]
                              .substring(0, 5)) // HH:mm 형식으로 시간 표시
                          : null,
                    );
                  },
                ),
    );
  }
}
