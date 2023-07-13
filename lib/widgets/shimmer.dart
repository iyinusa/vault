import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final double width, height;
  const ShimmerWidget.rectangle({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.2),
      highlightColor: Colors.grey.withOpacity(0.5),
      period: const Duration(seconds: 2),
      child: Container(
        width: width,
        height: height,
        color: Colors.grey.shade100,
      ),
    );
  }
}
