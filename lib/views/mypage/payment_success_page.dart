import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storymate/components/theme.dart';

class PaymentSuccessPage extends StatelessWidget {
  const PaymentSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final int amount = Get.arguments?['amount'] ?? 0;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text(
          '결제 성공',
          style: TextStyle(fontFamily: 'Jua'),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 20),
            Text(
              '결제가 성공적으로 완료되었습니다!',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('충전된 메시지: ${amount == 500 ? "30개" : "70개"}'),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor, // 올바른 방법
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50), // 버튼 모서리 둥글게
                ),
              ),
              onPressed: () => Get.offAllNamed('/my_page'),
              child: const Text(
                '확인',
                style: TextStyle(
                  color: Colors.white, // 글자 색상 흰색으로 설정
                  fontSize: 16,
                  fontFamily: 'Jua',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
