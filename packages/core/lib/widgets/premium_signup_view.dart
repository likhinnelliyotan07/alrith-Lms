import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import '../constants/app_colors.dart';
import '../constants/app_gradients.dart';
import '../strings/app_strings.dart';
import 'glass_card.dart';
import 'app_button.dart';

class PremiumSignupView extends StatefulWidget {
  final Function(String name, String email, String password) onSignup;
  final VoidCallback onBackToLogin;
  final String? lottieAsset;
  final bool isLoading;
  final String? errorMessage;

  const PremiumSignupView({
    super.key,
    required this.onSignup,
    required this.onBackToLogin,
    this.lottieAsset,
    this.isLoading = false,
    this.errorMessage,
  });

  @override
  State<PremiumSignupView> createState() => _PremiumSignupViewState();
}

class _PremiumSignupViewState extends State<PremiumSignupView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.lottieAsset != null)
                      Lottie.asset(
                        widget.lottieAsset!,
                        height: 150.h,
                      ),
                    SizedBox(height: 20.h),
                    GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            AppStrings.signUp,
                            style: TextStyle(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8.h),
                           Text(
                            "Create your account to get started",
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.white70,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 32.h),
                          if (widget.errorMessage != null) ...[
                            Container(
                              padding: EdgeInsets.all(12.w),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.red.withOpacity(0.3)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.error_outline, color: Colors.redAccent),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Text(
                                      widget.errorMessage!,
                                      style: const TextStyle(color: Colors.redAccent),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16.h),
                          ],
                          _buildGlassTextField(
                            controller: _nameController,
                            hint: "Full Name",
                            icon: Icons.person_outline,
                          ),
                          SizedBox(height: 16.h),
                          _buildGlassTextField(
                            controller: _emailController,
                            hint: AppStrings.emailLabel,
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(height: 16.h),
                          _buildGlassTextField(
                            controller: _passwordController,
                            hint: AppStrings.passwordLabel,
                            icon: Icons.lock_outline,
                            obscureText: true,
                          ),
                          SizedBox(height: 16.h),
                          _buildGlassTextField(
                            controller: _confirmPasswordController,
                            hint: "Confirm Password",
                            icon: Icons.lock_reset_outlined,
                            obscureText: true,
                            validator: (value) {
                              if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return value == null || value.isEmpty ? 'Required' : null;
                            },
                          ),
                          SizedBox(height: 24.h),
                          AppButton(
                            text: "Register",
                            isLoading: widget.isLoading,
                            gradient: AppGradients.accent,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                widget.onSignup(
                                  _nameController.text,
                                  _emailController.text,
                                  _passwordController.text,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account?",
                          style: TextStyle(color: Colors.white70),
                        ),
                        TextButton(
                          onPressed: widget.onBackToLogin,
                          child: const Text(
                            AppStrings.loginButton,
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
      ),
    );
  }

  Widget _buildGlassTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white54),
          prefixIcon: Icon(icon, color: Colors.white70),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        ),
        validator: validator ?? (value) => value == null || value.isEmpty ? 'Required' : null,
      ),
    );
  }
}
