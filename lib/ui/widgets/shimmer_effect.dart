import 'package:flutter/material.dart';
import 'package:monirth_memories/ui/widgets/shimmer_pkg.dart';

// ignore: must_be_immutable
class ShimmerEffect extends StatelessWidget {
  double? height;
  ShimmerEffect({super.key, this.height});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height ?? 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
