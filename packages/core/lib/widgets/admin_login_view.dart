import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';
import '../constants/app_gradients.dart';

class AdminLoginView extends StatefulWidget {
  final Function(String email, String password) onEmailLogin;
  final Function(String phone) onPhoneSignIn;
  final Function(String phone, String otp) onVerifyOTP;
  final VoidCallback onGoogleLogin;
  final VoidCallback onAppleLogin;
  final bool isLoading;
  final String? errorMessage;

  const AdminLoginView({
    super.key,
    required this.onEmailLogin,
    required this.onPhoneSignIn,
    required this.onVerifyOTP,
    required this.onGoogleLogin,
    required this.onAppleLogin,
    this.isLoading = false,
    this.errorMessage,
  });

  @override
  State<AdminLoginView> createState() => _AdminLoginViewState();
}

class _AdminLoginViewState extends State<AdminLoginView> {
  bool _isEmailLogin = true;
  bool _otpSent = false;
  bool _isDarkMode = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: _isDarkMode ? AppColors.adminDarkBg : Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 900) {
            return _buildDesktopLayout();
          } else {
            return _buildMobileLayout();
          }
        },
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Left Branding Section
        Expanded(
          flex: 4,
          child: Container(
            decoration: BoxDecoration(
              gradient: _isDarkMode ? AppGradients.adminLeftSectionDark : AppGradients.adminLeftSection,
            ),
            padding: EdgeInsets.all(60.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLogo(),
                const Spacer(),
                Text(
                  "Welcome Back,\nAdmin!",
                  style: TextStyle(
                    fontSize: 48.sp,
                    fontWeight: FontWeight.bold,
                    color: _isDarkMode ? Colors.white : AppColors.adminPrimary,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  "Sign in to access the admin dashboard and manage Arlith Learning Solutions efficiently.",
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: _isDarkMode ? Colors.white70 : Colors.black54,
                    height: 1.5,
                  ),
                ),
                const Spacer(),
                Center(
                  child: Image.asset(
                    'assets/images/illustration.png',
                    package: 'core',
                    height: 400.h,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.dashboard_rounded,
                      size: 200.sp,
                      color: AppColors.adminPrimary.withOpacity(0.1),
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  "© 2025 Arlith Learning Solutions\nAll rights reserved.",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: _isDarkMode ? Colors.white38 : Colors.black26,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Right Login Form Section
        Expanded(
          flex: 5,
          child: Container(
            color: _isDarkMode ? AppColors.adminDarkBg : Colors.white,
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 100.w),
                child: _buildLoginForm(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 300.h,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: _isDarkMode ? AppGradients.adminLeftSectionDark : AppGradients.adminLeftSection,
            ),
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLogo(),
                SizedBox(height: 20.h),
                Text(
                  "Admin Login",
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                    color: _isDarkMode ? Colors.white : AppColors.adminPrimary,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(24.w),
            child: _buildLoginForm(),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Row(
      children: [
        Image.asset(
          'assets/images/logo.png',
          package: 'core',
          height: 60.h,
          errorBuilder: (context, error, stackTrace) => Icon(
            Icons.school_rounded,
            size: 40.sp,
            color: AppColors.adminPrimary,
          ),
        ),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Arlith",
              style: TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
                color: _isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            Text(
              "Learning Solutions",
              style: TextStyle(
                fontSize: 14.sp,
                color: _isDarkMode ? Colors.white60 : Colors.black45,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              Row(
                children: [
                  Icon(
                    _isDarkMode ? Icons.dark_mode : Icons.light_mode,
                    size: 20.sp,
                    color: _isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    _isDarkMode ? "Dark Mode" : "Light Mode",
                    style: TextStyle(
                      color: _isDarkMode ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  Switch(
                    value: _isDarkMode,
                    onChanged: (val) {
                      // Note: In a real app, this would call ThemeCubit
                    },
                    activeColor: AppColors.adminSecondary,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Center(
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: _isDarkMode ? Colors.white.withOpacity(0.05) : Colors.blue.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.lock_outline_rounded,
                size: 40.sp,
                color: _isDarkMode ? AppColors.adminSecondary : AppColors.adminPrimary,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                fontSize: 36.sp,
                fontWeight: FontWeight.bold,
                color: _isDarkMode ? Colors.white : Colors.black87,
              ),
              children: [
                const TextSpan(text: "Admin "),
                TextSpan(
                  text: "Login",
                  style: TextStyle(
                    color: AppColors.adminPrimary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "Sign in to continue to Admin Panel",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.sp,
              color: _isDarkMode ? Colors.white60 : Colors.black45,
            ),
          ),
          SizedBox(height: 40.h),
          _buildTabs(),
          SizedBox(height: 30.h),
          if (widget.errorMessage != null) ...[
            Text(
              widget.errorMessage!,
              style: const TextStyle(color: Colors.redAccent),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.h),
          ],
          if (_isEmailLogin) ...[
            _buildInputField(
              label: "Email Address",
              controller: _emailController,
              hint: "Enter your email address",
              icon: Icons.email_outlined,
            ),
            SizedBox(height: 20.h),
            _buildInputField(
              label: "Password",
              controller: _passwordController,
              hint: "Enter your password",
              icon: Icons.lock_outline,
              obscureText: true,
              suffixIcon: Icons.visibility_outlined,
            ),
          ] else ...[
             _buildInputField(
              label: "Phone Number",
              controller: _phoneController,
              hint: "Enter your phone number",
              icon: Icons.phone_android_outlined,
            ),
            if (_otpSent) ...[
              SizedBox(height: 20.h),
              _buildInputField(
                label: "OTP",
                controller: _otpController,
                hint: "Enter the OTP sent to your phone",
                icon: Icons.security,
              ),
            ],
          ],
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: true,
                    onChanged: (val) {},
                    activeColor: AppColors.adminPrimary,
                  ),
                  Text(
                    "Remember me",
                    style: TextStyle(
                      color: _isDarkMode ? Colors.white60 : Colors.black54,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(color: AppColors.adminPrimary),
                ),
              ),
            ],
          ),
          SizedBox(height: 30.h),
          _buildLoginButton(),
          SizedBox(height: 24.h),
          _buildDivider(),
          SizedBox(height: 24.h),
          _buildGoogleButton(),
          SizedBox(height: 30.h),
          _buildSecurityBox(),
          SizedBox(height: 24.h),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Need help? ",
                  style: TextStyle(color: _isDarkMode ? Colors.white60 : Colors.black54),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    "Contact Support",
                    style: TextStyle(
                      color: AppColors.adminPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Row(
      children: [
        _buildTabItem("Email", Icons.email_outlined, _isEmailLogin, () {
          setState(() => _isEmailLogin = true);
        }),
        _buildTabItem("Phone", Icons.phone_android_outlined, !_isEmailLogin, () {
          setState(() => _isEmailLogin = false);
        }),
      ],
    );
  }

  Widget _buildTabItem(String label, IconData icon, bool isActive, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 20.sp,
                  color: isActive
                      ? (_isDarkMode ? AppColors.adminSecondary : AppColors.adminPrimary)
                      : (_isDarkMode ? Colors.white38 : Colors.black38),
                ),
                SizedBox(width: 8.w),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    color: isActive
                        ? (_isDarkMode ? Colors.white : Colors.black87)
                        : (_isDarkMode ? Colors.white38 : Colors.black38),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Container(
              height: 2,
              color: isActive
                  ? (_isDarkMode ? AppColors.adminSecondary : AppColors.adminPrimary)
                  : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    IconData? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: _isDarkMode ? Colors.white70 : Colors.black87,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: _isDarkMode ? AppColors.adminInputDark : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isDarkMode ? Colors.white12 : Colors.black12,
            ),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black87),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: _isDarkMode ? Colors.white38 : Colors.black38,
                fontSize: 14.sp,
              ),
              prefixIcon: Icon(
                icon,
                color: _isDarkMode ? Colors.white38 : Colors.black38,
              ),
              suffixIcon: suffixIcon != null
                  ? Icon(
                      suffixIcon,
                      color: _isDarkMode ? Colors.white38 : Colors.black38,
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return Container(
      height: 56.h,
      decoration: BoxDecoration(
        gradient: _isDarkMode ? AppGradients.adminDarkButton : AppGradients.adminPrimaryGradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.adminPrimary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
             if (_isEmailLogin) {
                widget.onEmailLogin(_emailController.text, _passwordController.text);
              } else {
                if (!_otpSent) {
                  widget.onPhoneSignIn(_phoneController.text);
                  setState(() => _otpSent = true);
                } else {
                  widget.onVerifyOTP(_phoneController.text, _otpController.text);
                }
              }
          },
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: widget.isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.login_rounded, color: Colors.white),
                      SizedBox(width: 12.w),
                      Text(
                        _isEmailLogin ? "Login to Admin Panel" : (_otpSent ? "Verify OTP" : "Send OTP"),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            "OR",
            style: TextStyle(
              color: _isDarkMode ? Colors.white38 : Colors.black38,
              fontSize: 12.sp,
            ),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }

  Widget _buildGoogleButton() {
    return Container(
      height: 56.h,
      decoration: BoxDecoration(
        color: _isDarkMode ? AppColors.adminInputDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isDarkMode ? Colors.white12 : Colors.black12,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onGoogleLogin,
          borderRadius: BorderRadius.circular(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/1200px-Google_%22G%22_logo.svg.png",
                height: 24.h,
              ),
              SizedBox(width: 12.w),
              Text(
                "Continue with Google",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: _isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecurityBox() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: _isDarkMode ? Colors.white.withOpacity(0.05) : Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: _isDarkMode ? AppColors.adminSecondary.withOpacity(0.1) : AppColors.adminPrimary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.verified_user_outlined,
              color: _isDarkMode ? AppColors.adminSecondary : AppColors.adminPrimary,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Secure Admin Access",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: _isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "Your credentials are encrypted and protected with enterprise-grade security.",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: _isDarkMode ? Colors.white60 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
