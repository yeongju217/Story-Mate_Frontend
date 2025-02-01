import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // flutter_svg 패키지 import

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

// StatefulWidget으로 수정
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // SVG 이미지 추가

          // 두 번째 PNG 이미지 추가
          Image.asset(
            'assets/images/logo.png', // 두 번째 PNG 파일 경로
            height: 300,
          ),
          // 첫 번째 PNG 이미지 추가
          Image.asset(
            'assets/images/kakaotalk.png', // 첫 번째 PNG 파일 경로
            height: 100,
          ),

          SvgPicture.asset('assets/images/account.svg', // SVG 파일 경로
              height: 25),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}
