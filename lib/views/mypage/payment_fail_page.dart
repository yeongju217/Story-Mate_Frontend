import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storymate/components/theme.dart';

class PaymentFailPage extends StatelessWidget {
  const PaymentFailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String reason = Get.arguments?['reason'] ?? "알 수 없는 오류가 발생했습니다.";

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text(
          '결제 실패',
          style: TextStyle(fontFamily: 'Jua'),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, color: Colors.red, size: 80),
            const SizedBox(height: 20),
            const Text(
              '결제에 실패하였습니다.',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('사유: $reason'),
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
              onPressed: () => Get.back(),
              child: const Text(
                '다시 시도',
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
