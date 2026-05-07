import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppShimmer extends StatelessWidget {
  final double? width;
  final double? height;
  final ShapeBorder shapeBorder;

  const AppShimmer.rectangular({
    super.key,
    this.width,
    required this.height,
  }) : shapeBorder = const RoundedRectangleBorder();

  const AppShimmer.circular({
    super.key,
    required double size,
  })  : width = size,
        height = size,
        shapeBorder = const CircleBorder();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          color: Colors.grey[400]!,
          shape: shapeBorder,
        ),
      ),
    );
  }
}

class AppTableShimmer extends StatelessWidget {
  const AppTableShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        5,
        (index) => Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            children: [
              AppShimmer.rectangular(height: 40.h, width: 40.w),
              SizedBox(width: 16.w),
              Expanded(child: AppShimmer.rectangular(height: 20.h)),
              SizedBox(width: 16.w),
              Expanded(child: AppShimmer.rectangular(height: 20.h)),
              SizedBox(width: 16.w),
              AppShimmer.rectangular(height: 20.h, width: 80.w),
            ],
          ),
        ),
      ),
    );
  }
}
