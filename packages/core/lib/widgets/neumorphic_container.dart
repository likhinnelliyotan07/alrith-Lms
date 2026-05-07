import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class NeumorphicContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double blur;
  final Offset offset;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const NeumorphicContainer({
    super.key,
    required this.child,
    this.borderRadius = 20,
    this.blur = 15,
    this.offset = const Offset(5, 5),
    this.color,
    this.padding,
    this.margin,
  });


  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = color ?? (isDark ? AppColors.darkSurface : AppColors.surface);

    return Container(
      margin: margin,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.5) : Colors.grey.shade400,
            offset: offset,
            blurRadius: blur,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
            offset: -offset,
            blurRadius: blur,
            spreadRadius: 1,
          ),
        ],
      ),
      child: child,
    );

  }
}
