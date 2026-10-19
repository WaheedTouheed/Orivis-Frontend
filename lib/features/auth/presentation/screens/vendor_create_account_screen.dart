import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';

class VendorCreateAccountScreen extends StatefulWidget {
  const VendorCreateAccountScreen({super.key});

  @override
  State<VendorCreateAccountScreen> createState() =>
      _VendorCreateAccountScreenState();
}

class _VendorCreateAccountScreenState
    extends State<VendorCreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _businessNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreedToTerms = false;
  bool _showTermsError = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _businessNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleCreateAccount() {
    setState(() {
      _showTermsError = !_agreedToTerms;
    });

    final isFormValid = _formKey.currentState!.validate();

    if (!isFormValid || !_agreedToTerms) {
      if (!_agreedToTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Please agree to the Terms of Service and Privacy Policy to continue.',
            ),
            backgroundColor: AppColors.errorRed,
            duration: Duration(seconds: 2),
          ),
        );
      }
      return;
    }

    // Demo Mode Notification (Frontend only, no API/DB connection)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Demo mode: vendor registration is not connected yet.'),
        backgroundColor: AppColors.darkGreen,
        duration: Duration(seconds: 3),
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

  @override
  Widget build(BuildContext context) {
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
              // 1. GREEN HEADER SECTION (~230 px height)
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

                      SizedBox(height: 14.h),

                      // Logo
                      Image.asset(
                        AppAssets.logo,
                        height: 42.h,
                        width: 42.w,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.eco,
                            size: 40.r,
                            color: Colors.white,
                          );
                        },
                      ),

                      SizedBox(height: 12.h),

                      // Main Heading
                      Text(
                        'Create your vendor account',
                        style: TextStyle(
                          fontSize: 25.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),

                      SizedBox(height: 4.h),

                      // Subtitle
                      Text(
                        'Connect with growers and discover fresh produce',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.subtitleLight,
                        ),
                      ),

                      SizedBox(height: 42.h), // Space for card overlap
                    ],
                  ),
                ),
              ),

              // ==========================================
              // 2. MAIN WHITE VENDOR REGISTRATION CARD
              // ==========================================
              Transform.translate(
                offset: Offset(0, -26.h),
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
                              // FIELD 1 — FULL NAME
                              // ----------------------------------------
                              _buildFieldLabel('Full name', isRequired: true),
                              SizedBox(height: 8.h),
                              TextFormField(
                                controller: _fullNameController,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: AppColors.primaryText,
                                ),
                                decoration: _buildInputDecoration(
                                  hintText: 'Enter your full name',
                                  iconData: Icons.person_outline_rounded,
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter your full name.';
                                  }
                                  return null;
                                },
                              ),

                              SizedBox(height: 16.h),

                              // ----------------------------------------
                              // FIELD 2 — BUSINESS NAME
                              // ----------------------------------------
                              _buildFieldLabel('Business name', isRequired: true),
                              SizedBox(height: 8.h),
                              TextFormField(
                                controller: _businessNameController,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: AppColors.primaryText,
                                ),
                                decoration: _buildInputDecoration(
                                  hintText: 'Enter your business name',
                                  iconData: Icons.storefront_outlined,
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter your business name.';
                                  }
                                  return null;
                                },
                              ),

                              SizedBox(height: 16.h),

                              // ----------------------------------------
                              // FIELD 3 — EMAIL ADDRESS
                              // ----------------------------------------
                              _buildFieldLabel('Email address', isRequired: true),
                              SizedBox(height: 8.h),
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                autofillHints: const [AutofillHints.email],
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: AppColors.primaryText,
                                ),
                                decoration: _buildInputDecoration(
                                  hintText: 'name@example.com',
                                  iconData: Icons.mail_outline_rounded,
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter your email address.';
                                  }
                                  if (!value.contains('@') || !value.contains('.')) {
                                    return 'Please enter a valid email address.';
                                  }
                                  return null;
                                },
                              ),

                              SizedBox(height: 16.h),

                              // ----------------------------------------
                              // FIELD 4 — PHONE NUMBER (OPTIONAL)
                              // ----------------------------------------
                              _buildFieldLabel('Phone number (optional)',
                                  isRequired: false),
                              SizedBox(height: 8.h),
                              TextFormField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: AppColors.primaryText,
                                ),
                                decoration: _buildInputDecoration(
                                  hintText: 'Enter your phone number',
                                  iconData: Icons.phone_outlined,
                                ),
                              ),

                              SizedBox(height: 16.h),

                              // ----------------------------------------
                              // FIELD 5 — BUSINESS LOCATION (OPTIONAL)
                              // ----------------------------------------
                              _buildFieldLabel('Business location (optional)',
                                  isRequired: false),
                              SizedBox(height: 8.h),
                              TextFormField(
                                controller: _locationController,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: AppColors.primaryText,
                                ),
                                decoration: _buildInputDecoration(
                                  hintText: 'City or area',
                                  iconData: Icons.location_on_outlined,
                                ),
                              ),

                              SizedBox(height: 16.h),

                              // ----------------------------------------
                              // FIELD 6 — PASSWORD
                              // ----------------------------------------
                              _buildFieldLabel('Password', isRequired: true),
                              SizedBox(height: 8.h),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: AppColors.primaryText,
                                ),
                                decoration: _buildInputDecoration(
                                  hintText: 'Create a password',
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
                                    return 'Please create a password.';
                                  }
                                  if (value.trim().length < 8) {
                                    return 'Password must contain at least 8 characters.';
                                  }
                                  return null;
                                },
                              ),

                              SizedBox(height: 16.h),

                              // ----------------------------------------
                              // FIELD 7 — CONFIRM PASSWORD
                              // ----------------------------------------
                              _buildFieldLabel('Confirm password', isRequired: true),
                              SizedBox(height: 8.h),
                              TextFormField(
                                controller: _confirmPasswordController,
                                obscureText: _obscureConfirmPassword,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: AppColors.primaryText,
                                ),
                                decoration: _buildInputDecoration(
                                  hintText: 'Re-enter your password',
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
                                    return 'Please confirm your password.';
                                  }
                                  if (value != _passwordController.text) {
                                    return 'Passwords do not match.';
                                  }
                                  return null;
                                },
                              ),

                              SizedBox(height: 8.h),

                              // Password Guidance Helper Text
                              Text(
                                'Use at least 8 characters for your password.',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.secondaryText,
                                ),
                              ),

                              SizedBox(height: 18.h),

                              // ----------------------------------------
                              // TERMS AND CONDITIONS CHECKBOX
                              // ----------------------------------------
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 22.r,
                                    width: 22.r,
                                    child: Checkbox(
                                      value: _agreedToTerms,
                                      activeColor: AppColors.darkGreen,
                                      side: BorderSide(
                                        color: _showTermsError
                                            ? AppColors.errorRed
                                            : AppColors.placeholderColor,
                                        width: 1.5.w,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4.r),
                                      ),
                                      onChanged: (val) {
                                        setState(() {
                                          _agreedToTerms = val ?? false;
                                          if (_agreedToTerms) _showTermsError = false;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _agreedToTerms = !_agreedToTerms;
                                          if (_agreedToTerms) _showTermsError = false;
                                        });
                                      },
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'I agree to the ',
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                color: AppColors.secondaryText,
                                              ),
                                            ),
                                            WidgetSpan(
                                              child: InkWell(
                                                onTap: () => _showDemoMessage(
                                                  'Terms of Service page will be available later.',
                                                ),
                                                child: Text(
                                                  'Terms of Service',
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w700,
                                                    color: AppColors.secondaryGreen,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            TextSpan(
                                              text: ' and ',
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                color: AppColors.secondaryText,
                                              ),
                                            ),
                                            WidgetSpan(
                                              child: InkWell(
                                                onTap: () => _showDemoMessage(
                                                  'Privacy Policy page will be available later.',
                                                ),
                                                child: Text(
                                                  'Privacy Policy.',
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w700,
                                                    color: AppColors.secondaryGreen,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              if (_showTermsError) ...[
                                SizedBox(height: 6.h),
                                Text(
                                  'You must agree to the terms to register.',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: AppColors.errorRed,
                                  ),
                                ),
                              ],

                              SizedBox(height: 22.h),

                              // ----------------------------------------
                              // CREATE ACCOUNT BUTTON
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
                                  onPressed: _handleCreateAccount,
                                  child: Text(
                                    'Create account',
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
                              // EXISTING ACCOUNT LINK (Sign in)
                              // ----------------------------------------
                              Center(
                                child: InkWell(
                                  onTap: () => Navigator.of(context).pop(),
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
                                            text: 'Already have an account? ',
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

                      SizedBox(height: 20.h),

                      // ==========================================
                      // 3. CHANGE ROLE BUTTON (Outside White Card)
                      // ==========================================
                      Center(
                        child: InkWell(
                          onTap: () => Navigator.of(context).popUntil(
                            (route) => route.isFirst || route.settings.name == '/',
                          ),
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
