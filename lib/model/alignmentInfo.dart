import 'package:flutter/material.dart';

class AlignmentInfo {
  final String name;
  final Color color;

  const AlignmentInfo._({
    required this.name,
    required this.color,
  });

  static const AlignmentInfo good = AlignmentInfo._(
    name: 'good',
    color: Colors.green,
  );

  static const AlignmentInfo bad = AlignmentInfo._(
    name: 'bad',
    color: Colors.red,
  );

  static const AlignmentInfo neutral = AlignmentInfo._(
    name: 'neutral',
    color: Colors.grey,
  );

  static AlignmentInfo? fromAlignment(String alignment) {
    switch (alignment) {
      case 'good':
        return good;
      case 'bad':
        return bad;
      case 'neutral':
        return neutral;
      default:
        return null;
    }
  }



}