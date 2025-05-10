// 작품 카드 위젯

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final List<String> tags;
  final String coverImage;
  final Function() onTap;

  const CustomCard({
    super.key,
    required this.title,
    required this.tags,
    required this.onTap,
    required this.coverImage,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 129.w,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: coverImage != ''
                ? AssetImage(coverImage)
                : AssetImage('assets/books/broken_image.png'),
          ),
        ),
      ),
    );
  }
}
