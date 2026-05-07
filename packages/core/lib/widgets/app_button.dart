import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';
import '../constants/app_gradients.dart';
import '../constants/app_text_styles.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final Gradient? gradient;
  final Color? color;
  final double? width;
  final double? height;
  final double borderRadius;
  final Widget? icon;
  final bool isOutlined;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.gradient,
    this.color,
    this.width,
    this.height,
    this.borderRadius = 12,
    this.icon,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveGradient = isOutlined ? null : (gradient ?? AppGradients.primary);
    final effectiveColor = isOutlined ? Colors.transparent : (color ?? (gradient == null ? null : Colors.transparent));

    return SizedBox(
      width: isFullWidth ? double.infinity : width,
      height: height ?? 56.h,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: onPressed == null ? null : effectiveGradient,
          color: onPressed == null ? AppColors.textTertiary.withOpacity(0.3) : effectiveColor,
          borderRadius: BorderRadius.circular(borderRadius.r),
          border: isOutlined ? Border.all(color: AppColors.primary, width: 2) : null,
          boxShadow: (onPressed == null || isOutlined)
              ? null
              : [
                  BoxShadow(
                    color: (gradient?.colors.first ?? AppColors.primary).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isLoading ? null : onPressed,
            borderRadius: BorderRadius.circular(borderRadius.r),
            child: Center(
              child: isLoading
                  ? SizedBox(
                      height: 24.h,
                      width: 24.h,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isOutlined ? AppColors.primary : Colors.white,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (icon != null) ...[
                          icon!,
                          SizedBox(width: 8.w),
                        ],
                        Text(
                          text,
                          style: AppTextStyles.button.copyWith(
                            color: isOutlined ? AppColors.primary : Colors.white,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
