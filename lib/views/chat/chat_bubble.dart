import 'package:flutter/material.dart';
import '../../models/message.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatBubble extends StatelessWidget {
  final Message message;
  final TextStyle? textStyle;

  const ChatBubble({required this.message, super.key, this.textStyle});

  @override
  Widget build(BuildContext context) {
    final bool isUser = message.isUser;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isUser ? Color(0xFF9B9FD0) : Colors.grey[300],
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
          child: Text(
            message.content,
            style: TextStyle(
              color: isUser ? Colors.white : Colors.black,
              fontSize: 16.sp,
            ),
            softWrap: true, // 텍스트가 길어지면 자동 줄바꿈
          ),
        ),
      ),
    );
  }
}
