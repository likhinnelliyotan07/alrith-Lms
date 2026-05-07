import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import '../constants/app_colors.dart';
import '../constants/app_gradients.dart';
import '../strings/app_strings.dart';
import 'glass_card.dart';

class PremiumLoginView extends StatelessWidget {
  final VoidCallback onLogin;
  final String? lottieAsset;

  const PremiumLoginView({
    super.key,
    required this.onLogin,
    this.lottieAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.premium,
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (lottieAsset != null)
                    Lottie.asset(
                      lottieAsset!,
                      height: 200.h,
                    ),
                  SizedBox(height: 40.h),
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          AppStrings.welcomeBack,
                          style: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          AppStrings.loginTitle,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 32.h),
                        _buildTextField(
                          label: AppStrings.emailLabel,
                          icon: Icons.email_outlined,
                        ),
                        SizedBox(height: 16.h),
                        _buildTextField(
                          label: AppStrings.passwordLabel,
                          icon: Icons.lock_outline,
                          isPassword: true,
                        ),
                        SizedBox(height: 12.h),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: const Text(
                              AppStrings.forgotPassword,
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),
                        Container(
                          height: 56.h,
                          decoration: BoxDecoration(
                            gradient: AppGradients.accent,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: onLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              AppStrings.loginButton,
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        AppStrings.dontHaveAccount,
                        style: TextStyle(color: Colors.white70),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          AppStrings.signUp,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        obscureText: isPassword,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          prefixIcon: Icon(icon, color: Colors.white70),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white24),
          ),
        ),
      ),
    );
  }
}
