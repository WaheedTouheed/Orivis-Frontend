import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import 'grower_login_screen.dart';
import 'login_screen.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  final String role; // 'Grower' or 'Vendor'
  final String email;

  const CreateNewPasswordScreen({
    super.key,
    required this.role,
    required this.email,
  });

  @override
  State<CreateNewPasswordScreen> createState() =>
      _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleResetPassword() {
    if (!_formKey.currentState!.validate()) return;

    // Demo Mode Notification (Frontend only, no backend connection)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Demo mode: password reset is not connected yet.'),
        backgroundColor: AppColors.darkGreen,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _navigateToLogin() {
    if (widget.role.toLowerCase() == 'grower') {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => const GrowerLoginScreen(),
        ),
        (route) => route.isFirst,
      );
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => const LoginScreen(role: 'vendor'),
        ),
        (route) => route.isFirst,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark, // Dark status bar icons on warm cream
        statusBarBrightness: Brightness.light,    // Dark status bar text on iOS
      ),
      child: Scaffold(
        backgroundColor: AppColors.warmCream,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(
              top: topPadding > 0 ? topPadding + 8.h : 16.h,
              left: 20.w,
              right: 20.w,
              bottom: 16.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ==========================================
                // 1. TOP HEADER SECTION (Warm Cream BG)
                // ==========================================
                Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      borderRadius: BorderRadius.circular(12.r),
                      child: Container(
                        height: 40.r,
                        width: 40.r,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: AppColors.cardBorder,
                            width: 1.w,
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 20.r,
                          color: AppColors.darkGreen,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12.h),

                // ORIVIS Logo
                Center(
                  child: Image.asset(
                    AppAssets.logo,
                    height: 60.h,
                    width: 60.w,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.eco,
                        size: 56.r,
                        color: AppColors.darkGreen,
                      );
                    },
                  ),
                ),

                SizedBox(height: 18.h),

                // Main Heading
                Text(
                  'Create new password',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkGreen,
                  ),
                ),

                SizedBox(height: 6.h),

                // Subtitle
                Text(
                  'Choose a strong password for your account.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.secondaryText,
                  ),
                ),

                SizedBox(height: 24.h),

                // ==========================================
                // 2. FORM CARD
                // ==========================================
                Container(
                  width: double.infinity,
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
                        // FIELD 1 — NEW PASSWORD
                        // ----------------------------------------
                        _buildFieldLabel('New password', isRequired: true),
                        SizedBox(height: 8.h),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: AppColors.primaryText,
                          ),
                          decoration: _buildInputDecoration(
                            hintText: 'Enter your new password',
                            iconData: Icons.lock_outline_rounded,
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
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a new password.';
                            }
                            if (value.trim().length < 8) {
                              return 'Password must be at least 8 characters.';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 6.h),

                        // Password Helper Text
                        Text(
                          'Use at least 8 characters.',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.secondaryText,
                          ),
                        ),

                        SizedBox(height: 18.h),

                        // ----------------------------------------
                        // FIELD 2 — CONFIRM NEW PASSWORD
                        // ----------------------------------------
                        _buildFieldLabel('Confirm new password', isRequired: true),
                        SizedBox(height: 8.h),
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: _obscureConfirmPassword,
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: AppColors.primaryText,
                          ),
                          decoration: _buildInputDecoration(
                            hintText: 'Re-enter your new password',
                            iconData: Icons.lock_outline_rounded,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                size: 22.r,
                                color: AppColors.iconColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword =
                                      !_obscureConfirmPassword;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please confirm your new password.';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match.';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 24.h),

                        // ----------------------------------------
                        // RESET PASSWORD BUTTON
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
                            onPressed: _handleResetPassword,
                            child: Text(
                              'Reset password',
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 20.h),

                        // ----------------------------------------
                        // BACK TO LOGIN LINK
                        // ----------------------------------------
                        Center(
                          child: InkWell(
                            onTap: _navigateToLogin,
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
                                      text: 'Remember your password? ',
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.secondaryText,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Sign in',
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

                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String labelText, {required bool isRequired}) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: labelText,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryText,
            ),
          ),
          if (isRequired)
            TextSpan(
              text: ' *',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.errorRed,
              ),
            ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hintText,
    required IconData iconData,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        fontSize: 15.sp,
        color: AppColors.placeholderColor,
      ),
      prefixIcon: Icon(
        iconData,
        size: 20.r,
        color: AppColors.iconColor,
      ),
      suffixIcon: suffixIcon,
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
    );
  }
}
