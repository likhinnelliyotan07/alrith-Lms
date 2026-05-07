import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import '../constants/app_gradients.dart';
import '../constants/app_assets.dart';
import '../constants/app_text_styles.dart';

class PremiumSplashView extends StatelessWidget {
  final String appName;
  final String logoAsset;

  const PremiumSplashView({
    super.key,
    required this.appName,
    required this.logoAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppGradients.premium,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'app_logo',
              child: Image.asset(
                logoAsset,
                height: 120.h,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.school_rounded,
                  size: 100.sp,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              appName,
              style: AppTextStyles.h1.white,
            ),
            SizedBox(height: 60.h),
            Lottie.asset(
              AppAssets.loadingAnimation,
              height: 100.h,
              errorBuilder: (context, error, stackTrace) => const CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
