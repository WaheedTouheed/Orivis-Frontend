import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import 'password_reset_otp_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final String role; // 'Grower' or 'Vendor'
  final String? initialEmail;

  const ForgotPasswordScreen({
    super.key,
    required this.role,
    this.initialEmail,
  });

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail ?? '');
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleSendResetInstructions() {
    if (!_formKey.currentState!.validate()) return;

    // Navigate to 4-digit PasswordResetOtpScreen passing role & entered email
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PasswordResetOtpScreen(
          role: widget.role,
          email: _emailController.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final roleBadgeLabel = '${widget.role.toUpperCase()} ACCOUNT';
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
                  'Forgot password?',
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
                  "Don't worry, we'll help you reset it.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.secondaryText,
                  ),
                ),

                SizedBox(height: 16.h),

                // ==========================================
                // 2. ROLE INDICATOR BADGE
                // ==========================================
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF1E9), // Light Green Badge BG (#EAF1E9)
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    roleBadgeLabel,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                      color: AppColors.darkGreen,
                    ),
                  ),
                ),

                SizedBox(height: 24.h),

                // ==========================================
                // 3. INSTRUCTION CARD & EMAIL FORM
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Outlined Mail Icon in Circular Container
                        Container(
                          height: 64.r,
                          width: 64.r,
                          decoration: const BoxDecoration(
                            color: Color(0xFFEAF1E9), // #EAF1E9
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.mail_outline_rounded,
                            size: 30.r,
                            color: AppColors.darkGreen,
                          ),
                        ),

                        SizedBox(height: 16.h),

                        // Title inside card
                        Text(
                          'Reset your password',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryText,
                          ),
                        ),

                        SizedBox(height: 8.h),

                        // Description
                        Text(
                          "Enter the email address associated with your account. We'll guide you through the next steps.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.sp,
                            height: 1.35,
                            color: AppColors.secondaryText,
                          ),
                        ),

                        SizedBox(height: 24.h),

                        // ----------------------------------------
                        // EMAIL INPUT FIELD
                        // ----------------------------------------
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Email address ',
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
                        ),
                        SizedBox(height: 8.h),

                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [AutofillHints.email],
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
                              return 'Please enter your email address.';
                            }
                            if (!value.contains('@') || !value.contains('.')) {
                              return 'Please enter a valid email address.';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 24.h),

                        // ----------------------------------------
                        // SEND RESET INSTRUCTIONS BUTTON
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
                            onPressed: _handleSendResetInstructions,
                            child: Text(
                              'Send reset instructions',
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
}
