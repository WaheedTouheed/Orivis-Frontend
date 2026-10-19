import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import 'forgot_password_screen.dart';
import 'grower_create_account_screen.dart';
import 'otp_verification_screen.dart';
import 'vendor_create_account_screen.dart';

class LoginScreen extends StatefulWidget {
  final String? role;

  const LoginScreen({super.key, this.role});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    // Navigate to OtpVerificationScreen passing Vendor role & entered email
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => OtpVerificationScreen(
          role: widget.role == 'vendor' ? 'Vendor' : 'Account',
          email: _emailController.text.trim(),
        ),
      ),
    );
  }

  void _navigateToForgotPassword() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ForgotPasswordScreen(
          role: widget.role == 'vendor' ? 'Vendor' : 'Account',
          initialEmail: _emailController.text.trim(),
        ),
      ),
    );
  }

  void _showDemoMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.secondaryGreen,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _navigateToCreateAccount() {
    if (widget.role == 'vendor') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const VendorCreateAccountScreen(),
        ),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const GrowerCreateAccountScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final accountTypeLabel =
        widget.role == 'vendor' ? 'Vendor account' : 'Account login';
    final topPadding = MediaQuery.paddingOf(context).top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light, // White status bar icons on Android
        statusBarBrightness: Brightness.dark,      // White status bar text on iOS
      ),
      child: Scaffold(
        backgroundColor: AppColors.warmCream,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // ==========================================
              // 1. GREEN HEADER SECTION (~245 px height)
              // ==========================================
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.darkGreen,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(28.r),
                    bottomRight: Radius.circular(28.r),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    top: topPadding > 0 ? topPadding + 8.h : 16.h,
                    left: 20.w,
                    right: 20.w,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Row: Back Button
                      Row(
                        children: [
                          if (Navigator.canPop(context))
                            InkWell(
                              onTap: () => Navigator.of(context).pop(),
                              borderRadius: BorderRadius.circular(12.r),
                              child: Container(
                                height: 40.r,
                                width: 40.r,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  size: 20.r,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),

                      SizedBox(height: 16.h),

                      // Logo
                      Image.asset(
                        AppAssets.logo,
                        height: 44.h,
                        width: 44.w,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.eco,
                            size: 40.r,
                            color: Colors.white,
                          );
                        },
                      ),

                      SizedBox(height: 14.h),

                      // Main Heading
                      Text(
                        'Welcome back',
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),

                      SizedBox(height: 4.h),

                      // Subtitle (e.g. "Vendor account")
                      Text(
                        accountTypeLabel,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.subtitleLight,
                        ),
                      ),

                      SizedBox(height: 45.h), // Space for card overlap
                    ],
                  ),
                ),
              ),

              // ==========================================
              // 2. MAIN WHITE OVERLAPPING FORM CARD
              // ==========================================
              Transform.translate(
                offset: Offset(0, -28.h),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24.r),
                          border: Border.all(
                            color: AppColors.cardBorder,
                            width: 1.w,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ----------------------------------------
                              // A. EMAIL INPUT FIELD
                              // ----------------------------------------
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Email ',
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primaryText,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '*',
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.errorRed,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8.h),

                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: AppColors.primaryText,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'name@example.com',
                                  hintStyle: TextStyle(
                                    fontSize: 15.sp,
                                    color: AppColors.placeholderColor,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.mail_outline_rounded,
                                    size: 21.r,
                                    color: AppColors.iconColor,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 14.w,
                                    vertical: 15.h,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14.r),
                                    borderSide: BorderSide(
                                      color: AppColors.cardBorder,
                                      width: 1.w,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14.r),
                                    borderSide: BorderSide(
                                      color: AppColors.cardBorder,
                                      width: 1.w,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14.r),
                                    borderSide: BorderSide(
                                      color: AppColors.secondaryGreen,
                                      width: 1.5.w,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14.r),
                                    borderSide: BorderSide(
                                      color: AppColors.errorRed,
                                      width: 1.w,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (!value.contains('@') || !value.contains('.')) {
                                    return 'Please enter a valid email address';
                                  }
                                  return null;
                                },
                              ),

                              SizedBox(height: 18.h),

                              // ----------------------------------------
                              // B. PASSWORD INPUT FIELD
                              // ----------------------------------------
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Password ',
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primaryText,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '*',
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.errorRed,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8.h),

                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: AppColors.primaryText,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'At least 8 characters',
                                  hintStyle: TextStyle(
                                    fontSize: 15.sp,
                                    color: AppColors.placeholderColor,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.lock_outline_rounded,
                                    size: 21.r,
                                    color: AppColors.iconColor,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      size: 22.r,
                                      color: AppColors.iconColor,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 14.w,
                                    vertical: 15.h,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14.r),
                                    borderSide: BorderSide(
                                      color: AppColors.cardBorder,
                                      width: 1.w,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14.r),
                                    borderSide: BorderSide(
                                      color: AppColors.cardBorder,
                                      width: 1.w,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14.r),
                                    borderSide: BorderSide(
                                      color: AppColors.secondaryGreen,
                                      width: 1.5.w,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14.r),
                                    borderSide: BorderSide(
                                      color: AppColors.errorRed,
                                      width: 1.w,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  if (value.trim().length < 8) {
                                    return 'Password must be at least 8 characters';
                                  }
                                  return null;
                                },
                              ),

                              SizedBox(height: 12.h),

                              // ----------------------------------------
                              // C. FORGOT PASSWORD LINK
                              // ----------------------------------------
                              Align(
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                  onTap: _navigateToForgotPassword,
                                  borderRadius: BorderRadius.circular(4.r),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 2.h),
                                    child: Text(
                                      'Forgot password?',
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.secondaryGreen,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 20.h),

                              // ----------------------------------------
                              // D. SIGN IN BUTTON
                              // ----------------------------------------
                              SizedBox(
                                width: double.infinity,
                                height: 52.h,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.darkGreen,
                                    foregroundColor: Colors.white,
                                    elevation: 2,
                                    shadowColor: Colors.black.withValues(alpha: 0.15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14.r),
                                    ),
                                  ),
                                  onPressed: _handleLogin,
                                  child: Text(
                                    'Sign in',
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 18.h),

                              // ----------------------------------------
                              // E. SOCIAL LOGIN DIVIDER
                              // ----------------------------------------
                              Row(
                                children: [
                                  Expanded(
                                    child: Divider(
                                      color: AppColors.cardBorder,
                                      thickness: 1.w,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                                    child: Text(
                                      'or continue with',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: AppColors.dividerText,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(
                                      color: AppColors.cardBorder,
                                      thickness: 1.w,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 18.h),

                              // ----------------------------------------
                              // F. SOCIAL LOGIN BUTTONS (Google, Apple, Facebook)
                              // ----------------------------------------
                              Row(
                                children: [
                                  // 1. Google
                                  Expanded(
                                    child: _buildSocialButton(
                                      label: 'Google',
                                      iconWidget: Text(
                                        'G',
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w900,
                                          color: const Color(0xFFDB4437),
                                        ),
                                      ),
                                      onTap: () => _showDemoMessage(
                                        'Social login will be available later.',
                                      ),
                                    ),
                                  ),

                                  SizedBox(width: 10.w),

                                  // 2. Apple
                                  Expanded(
                                    child: _buildSocialButton(
                                      label: 'Apple',
                                      iconWidget: Icon(
                                        Icons.apple,
                                        size: 24.r,
                                        color: Colors.black,
                                      ),
                                      onTap: () => _showDemoMessage(
                                        'Social login will be available later.',
                                      ),
                                    ),
                                  ),

                                  SizedBox(width: 10.w),

                                  // 3. Facebook
                                  Expanded(
                                    child: _buildSocialButton(
                                      label: 'Facebook',
                                      iconWidget: Icon(
                                        Icons.facebook,
                                        size: 24.r,
                                        color: const Color(0xFF1877F2),
                                      ),
                                      onTap: () => _showDemoMessage(
                                        'Social login will be available later.',
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 20.h),

                              // ----------------------------------------
                              // G. CREATE ACCOUNT LINK
                              // ----------------------------------------
                              Center(
                                child: InkWell(
                                  onTap: _navigateToCreateAccount,
                                  borderRadius: BorderRadius.circular(4.r),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                      vertical: 4.h,
                                    ),
                                    child: Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'New here? ',
                                            style: TextStyle(
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w400,
                                              color: AppColors.secondaryText,
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'Create account',
                                            style: TextStyle(
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.secondaryGreen,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // ==========================================
                      // 3. CHANGE ROLE BUTTON (Outside White Card)
                      // ==========================================
                      if (Navigator.canPop(context))
                        Center(
                          child: InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            borderRadius: BorderRadius.circular(8.r),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 8.h,
                              ),
                              child: Text(
                                'Change role',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.secondaryGreen,
                                ),
                              ),
                            ),
                          ),
                        ),

                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required String label,
    required Widget iconWidget,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        height: 76.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: AppColors.cardBorder,
            width: 1.w,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 24.r,
              width: 24.r,
              child: Center(child: iconWidget),
            ),
            SizedBox(height: 6.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
