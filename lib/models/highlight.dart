import 'package:flutter/material.dart';

/// 하이라이트 데이터 모델
class Highlight {
  final int id;
  final int startOffset;
  final int endOffset;
  final String content;
  final Color color;

  Highlight({
    required this.id,
    required this.startOffset,
    required this.endOffset,
    required this.content,
    this.color = Colors.yellow,
  });

  @override
  String toString() {
    return 'Highlight(start: $startOffset, end: $endOffset, content: "$content")';
  }
}
