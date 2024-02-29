import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoadingEffect extends StatelessWidget {
  const ShimmerLoadingEffect({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5, // Number of shimmer items you want to show
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: ListTile(
            title: Container(
              height: 16.0,
              color: Colors.white,
            ),
            subtitle: Container(
              height: 12.0,
              color: Colors.white,
            ),
            leading: Container(
              width: 100.0,
              height: 100.0,
              color: Colors.white, // Shimmer background color
            ),
          ),
        );
      },
    );
  }
}
