import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/screens/forgot_password_screen.dart';
import '../widgets/vendor_bottom_navigation.dart';
import 'vendor_dashboard_screen.dart';

class VendorChangePasswordScreen extends StatefulWidget {
  const VendorChangePasswordScreen({super.key});

  @override
  State<VendorChangePasswordScreen> createState() =>
      _VendorChangePasswordScreenState();
}

class _VendorChangePasswordScreenState
    extends State<VendorChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleUpdatePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    setState(() => _isSubmitting = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Vendor account password updated successfully!',
        ),
        backgroundColor: AppColors.darkGreen,
        duration: Duration(seconds: 2),
      ),
    );

    Navigator.of(context).pop();
  }

  void _navigateToForgotPassword() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const ForgotPasswordScreen(role: 'vendor'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.warmCream,
        body: Column(
          children: [
            // ==========================================
            // 1. FIXED TOP APP BAR & HEADER
            // ==========================================
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: topPadding > 0 ? topPadding + 8.h : 16.h,
                left: 20.w,
                right: 20.w,
                bottom: 16.h,
              ),
              color: AppColors.warmCream,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          if (Navigator.of(context).canPop()) {
                            Navigator.of(context).pop();
                          } else {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => const VendorDashboardScreen(),
                              ),
                            );
                          }
                        },
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
                            size: 18.r,
                            color: AppColors.darkGreen,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE3EFE6),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          'Vendor Account',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Change password',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGreen,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Update password for Al-Noor Traders commercial account.',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),

            // ==========================================
            // 2. SCROLLABLE FORM CONTENT
            // ==========================================
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Current Password
                      _buildFieldLabel('Current password *'),
                      SizedBox(height: 8.h),
                      TextFormField(
                        controller: _currentPasswordController,
                        obscureText: _obscureCurrent,
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: AppColors.primaryText,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: _buildPasswordDecoration(
                          hintText: 'Enter current password',
                          isObscured: _obscureCurrent,
                          onToggle: () {
                            setState(() => _obscureCurrent = !_obscureCurrent);
                          },
                        ),
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Please enter current password.';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 8.h),

                      // Forgot Current Password Link
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: _navigateToForgotPassword,
                          borderRadius: BorderRadius.circular(6.r),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 4.h, horizontal: 2.w),
                            child: Text(
                              'Forgot current password?',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFF99A20),
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 16.h),

                      // New Password
                      _buildFieldLabel('New password *'),
                      SizedBox(height: 8.h),
                      TextFormField(
                        controller: _newPasswordController,
                        obscureText: _obscureNew,
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: AppColors.primaryText,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: _buildPasswordDecoration(
                          hintText: 'Enter new password',
                          isObscured: _obscureNew,
                          onToggle: () {
                            setState(() => _obscureNew = !_obscureNew);
                          },
                        ),
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Please enter new password.';
                          }
                          if (val.length < 8) {
                            return 'New password must contain at least 8 characters.';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 20.h),

                      // Confirm Password
                      _buildFieldLabel('Confirm new password *'),
                      SizedBox(height: 8.h),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirm,
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: AppColors.primaryText,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: _buildPasswordDecoration(
                          hintText: 'Re-enter new password',
                          isObscured: _obscureConfirm,
                          onToggle: () {
                            setState(() => _obscureConfirm = !_obscureConfirm);
                          },
                        ),
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Please confirm your new password.';
                          }
                          if (val != _newPasswordController.text) {
                            return 'Passwords do not match.';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 24.h),

                      // Security Requirements Card
                      Container(
                        padding: EdgeInsets.all(14.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: AppColors.cardBorder,
                            width: 1.w,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.shield_outlined,
                                  size: 18.r,
                                  color: AppColors.darkGreen,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'Password Requirements',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.darkGreen,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            _buildRequirementBullet('Minimum 8 characters'),
                            _buildRequirementBullet(
                                'Mix of letters, numbers, and special symbols'),
                            _buildRequirementBullet(
                                'Protects commercial bidding and payment authorization'),
                          ],
                        ),
                      ),

                      SizedBox(height: 28.h),

                      // Update Password Button
                      SizedBox(
                        width: double.infinity,
                        height: 52.h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.darkGreen,
                            foregroundColor: Colors.white,
                            elevation: 2,
                            shadowColor:
                                AppColors.darkGreen.withValues(alpha: 0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                          ),
                          onPressed: _isSubmitting ? null : _handleUpdatePassword,
                          child: _isSubmitting
                              ? SizedBox(
                                  height: 20.r,
                                  width: 20.r,
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Update password',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),

                      SizedBox(height: 16.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        // Fixed Vendor Bottom Navigation
        bottomNavigationBar: const VendorBottomNavigation(selectedIndex: 4),
      ),
    );
  }

  Widget _buildFieldLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryText,
      ),
    );
  }

  Widget _buildRequirementBullet(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.secondaryText,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.secondaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _buildPasswordDecoration({
    required String hintText,
    required bool isObscured,
    required VoidCallback onToggle,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        fontSize: 14.sp,
        color: const Color(0xFF929A92),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 14.h,
      ),
      suffixIcon: IconButton(
        icon: Icon(
          isObscured
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          size: 20.r,
          color: AppColors.secondaryText,
        ),
        onPressed: onToggle,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: BorderSide(color: AppColors.cardBorder, width: 1.w),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: BorderSide(color: AppColors.cardBorder, width: 1.w),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: BorderSide(color: AppColors.secondaryGreen, width: 1.5.w),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: BorderSide(color: AppColors.errorRed, width: 1.w),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: BorderSide(color: AppColors.errorRed, width: 1.w),
      ),
    );
  }
}
