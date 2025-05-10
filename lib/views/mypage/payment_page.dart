import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storymate/components/theme.dart';
import 'package:storymate/view_models/mypage/payment_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final PaymentController controller = Get.put(PaymentController());
  late final WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
    final int productId = Get.arguments?['productId'] ?? 0;
    controller.preparePayment(productId);
  }

  void _initializeWebView() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) async {
            controller.currentUrl.value = request.url; // 현재 URL 상태 업데이트
            print("현재 요청된 URL: ${request.url}");

            // 실제 pg_token 포함된 리디렉션 감지
            if (request.url.contains('pg_token')) {
              final Uri uri = Uri.parse(request.url);
              final String? pgToken = uri.queryParameters['pg_token'];
              if (pgToken != null) {
                print("결제 승인용 pg_token 수신: $pgToken");
                controller.approvePayment(pgToken);
              }
              return NavigationDecision.prevent;
            }

            // 카카오톡 딥링크 처리
            else if (request.url.startsWith('kakaotalk://')) {
              print("카카오톡 딥링크 감지: ${request.url}");
              if (await canLaunchUrl(Uri.parse(request.url))) {
                await launchUrl(Uri.parse(request.url));
              } else {
                print("카카오톡 앱이 설치되어 있지 않음, 대체 URL로 이동");
                String fallbackUrl = Uri.decodeComponent(
                    Uri.parse(request.url).queryParameters['url'] ?? '');
                if (fallbackUrl.isNotEmpty) {
                  _webViewController.loadRequest(Uri.parse(fallbackUrl));
                }
              }
              return NavigationDecision.prevent;
            }

            // 카카오페이 내부 명령 처리
            else if (request.url.startsWith('app://kakaopay/')) {
              print("카카오페이 내부 명령 처리: ${request.url}");

              // 결제 완료 후 닫기 명령어 처리
              if (request.url.contains('close')) {
                print("결제 창 닫기 명령어 수신");
                // 성공 또는 실패 페이지로 이동 (결제 성공 처리 가정)
                Get.offNamed('my_page/payments/success');
                return NavigationDecision.prevent;
              }

              // UI 설정 관련 명령어는 무시
              else if (request.url.contains('navigation_bar_hidden')) {
                print("UI 설정 명령어 감지 - 무시");
                return NavigationDecision.prevent;
              }

              return NavigationDecision.prevent;
            }

            // 결제 실패 감지
            else if (request.url.contains('fail')) {
              print("결제 실패 URL 감지");
              Get.offNamed('my_page/payments/fail');
              return NavigationDecision.prevent;
            }

            // 잘못된 URL 로드 시 차단
            else if (request.url.isEmpty || !request.url.startsWith('https')) {
              print("잘못된 URL 형식 감지: ${request.url}");
              return NavigationDecision.prevent;
            }

            // 기본적으로 이동 허용
            return NavigationDecision.navigate;
          },

          // 페이지 로딩 완료 로그 출력
          onPageFinished: (String url) {
            print("페이지 로딩 완료: $url");
          },

          // 웹 리소스 로딩 에러 처리
          onWebResourceError: (WebResourceError error) {
            print("웹 리소스 에러 발생: ${error.description}");
          },
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text(
          '카카오페이 결제',
          style: TextStyle(
            fontFamily: 'Jua',
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.paymentUrl.value.isNotEmpty) {
          _webViewController
              .loadRequest(Uri.parse(controller.paymentUrl.value));
          return WebViewWidget(controller: _webViewController);
        } else {
          return const Center(child: Text('유효한 결제 URL을 받지 못했습니다.'));
        }
      }),
    );
  }
}
