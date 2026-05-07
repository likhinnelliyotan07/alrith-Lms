import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../constants/app_colors.dart';
import '../constants/app_gradients.dart';
import '../strings/app_strings.dart';
import 'glass_card.dart';
import 'app_button.dart';

class PremiumLoginView extends StatefulWidget {
  final Function(String email, String password) onEmailLogin;
  final Function(String phone) onPhoneSignIn;
  final Function(String phone, String otp) onVerifyOTP;
  final VoidCallback onGoogleLogin;
  final VoidCallback onAppleLogin;
  final String? lottieAsset;
  final bool isLoading;
  final String? errorMessage;

  const PremiumLoginView({
    super.key,
    required this.onEmailLogin,
    required this.onPhoneSignIn,
    required this.onVerifyOTP,
    required this.onGoogleLogin,
    required this.onAppleLogin,
    this.lottieAsset,
    this.isLoading = false,
    this.errorMessage,
  });

  @override
  State<PremiumLoginView> createState() => _PremiumLoginViewState();
}

class _PremiumLoginViewState extends State<PremiumLoginView> {
  bool _isEmailLogin = true;
  bool _otpSent = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
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
                        height: 180.h,
                      ),
                    SizedBox(height: 30.h),
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
                            _isEmailLogin ? AppStrings.loginTitle : AppStrings.loginWithPhone,
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
                          if (_isEmailLogin) ...[
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
                          ] else ...[
                            if (!_otpSent)
                              _buildGlassTextField(
                                controller: _phoneController,
                                hint: AppStrings.phoneLabel,
                                icon: Icons.phone_android_rounded,
                                keyboardType: TextInputType.phone,
                              )
                            else
                              _buildGlassTextField(
                                controller: _otpController,
                                hint: AppStrings.otpLabel,
                                icon: Icons.security_rounded,
                                keyboardType: TextInputType.number,
                              ),
                          ],
                          SizedBox(height: 24.h),
                          AppButton(
                            text: _isEmailLogin
                                ? AppStrings.loginButton
                                : (_otpSent ? AppStrings.verifyOTP : AppStrings.sendOTP),
                            isLoading: widget.isLoading,
                            gradient: AppGradients.accent,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                if (_isEmailLogin) {
                                  widget.onEmailLogin(
                                    _emailController.text,
                                    _passwordController.text,
                                  );
                                } else {
                                  if (!_otpSent) {
                                    widget.onPhoneSignIn(_phoneController.text);
                                    setState(() => _otpSent = true);
                                  } else {
                                    widget.onVerifyOTP(
                                      _phoneController.text,
                                      _otpController.text,
                                    );
                                  }
                                }
                              }
                            },
                          ),
                          SizedBox(height: 16.h),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isEmailLogin = !_isEmailLogin;
                                _otpSent = false;
                              });
                            },
                            child: Text(
                              _isEmailLogin ? AppStrings.loginWithPhone : AppStrings.loginWithEmail,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      AppStrings.orContinueWith,
                      style: TextStyle(color: Colors.white60, fontSize: 14.sp),
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _SocialButton(
                          icon: Icons.g_mobiledata_rounded,
                          onPressed: widget.onGoogleLogin,
                        ),
                        SizedBox(width: 20.w),
                        _SocialButton(
                          icon: Icons.apple_rounded,
                          onPressed: widget.onAppleLogin,
                        ),
                      ],
                    ),
                    SizedBox(height: 32.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          AppStrings.dontHaveAccount,
                          style: TextStyle(color: Colors.white70),
                        ),
                        TextButton(
                          onPressed: () => context.push('/signup'),
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
      ),
    );
  }

  Widget _buildGlassTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
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
        validator: (value) => value == null || value.isEmpty ? 'Required' : null,
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _SocialButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Icon(icon, color: Colors.white, size: 32.sp),
      ),
    );
  }
}
