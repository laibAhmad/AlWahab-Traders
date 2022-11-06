import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class TextLoading extends StatelessWidget {
  const TextLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(color: Colors.grey.shade300, width: 100, height: 20),
    );
  }
}
