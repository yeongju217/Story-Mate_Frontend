import 'package:get/get.dart';
import '../models/message.dart';

class ChatController extends GetxController {
  var messages = <Message>[].obs; // 메시지 리스트
  final messageInput = ''.obs; // 입력 중인 메시지

  void sendMessage() {
    if (messageInput.value.isNotEmpty) {
      // 사용자 메시지 추가
      messages.add(Message(content: messageInput.value, isUser: true));
      messageInput.value = ''; // 입력창 초기화

      // 시스템 응답 (예시)
      Future.delayed(Duration(seconds: 1), () {
        messages.add(Message(content: '안녕하세요! 무엇을 도와드릴까요?', isUser: false));
      });
    }
  }
}
