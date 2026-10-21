import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../home/presentation/screens/grower_dashboard_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String role; // 'Grower' or 'Vendor'
  final String email;

  const OtpVerificationScreen({
    super.key,
    required this.role,
    required this.email,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  static const int _otpLength = 6;
  final List<TextEditingController> _controllers =
      List.generate(_otpLength, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
      List.generate(_otpLength, (_) => FocusNode());

  bool _hasError = false;

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String get _currentOtp {
    return _controllers.map((c) => c.text).join();
  }

  void _handleVerifyCode() {
    final otp = _currentOtp;
    if (otp.length < _otpLength) {
      setState(() => _hasError = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the complete 6-digit code.'),
          backgroundColor: AppColors.errorRed,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() => _hasError = false);

    if (widget.role.toLowerCase() == 'grower') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Demo mode: displaying Grower Home Dashboard.'),
          backgroundColor: AppColors.darkGreen,
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => const GrowerDashboardScreen(),
        ),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Demo mode: OTP verification is not connected yet.'),
          backgroundColor: AppColors.darkGreen,
          duration: Duration(seconds: 3),
        ),
      );
    }
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

  void _onOtpChanged(int index, String value) {
    if (value.isNotEmpty) {
      if (value.length > 1) {
        // Handle pasted OTP code (e.g. "123456")
        final digits = value.replaceAll(RegExp(r'\D'), '');
        for (int i = 0; i < _otpLength; i++) {
          if (i < digits.length) {
            _controllers[i].text = digits[i];
          }
        }
        if (digits.length >= _otpLength) {
          _focusNodes[_otpLength - 1].unfocus();
        } else {
          _focusNodes[digits.length].requestFocus();
        }
        setState(() => _hasError = false);
        return;
      }

      // Single digit entered -> move to next box
      if (index < _otpLength - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    }
    setState(() => _hasError = false);
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
        body: SingleChildScrollView(
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
                'Verify your email',
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
                'Enter the verification code to continue.',
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
              // 3. VERIFICATION EMAIL MESSAGE
              // ==========================================
              Text(
                "We've sent a verification code to",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.secondaryText,
                ),
              ),

              SizedBox(height: 4.h),

              Text(
                widget.email.isNotEmpty ? widget.email : 'user@example.com',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkGreen,
                ),
              ),

              SizedBox(height: 6.h),

              Text(
                'Demo mode: no email has been sent.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.secondaryText,
                ),
              ),

              SizedBox(height: 28.h),

              // ==========================================
              // 4. 6-DIGIT OTP INPUT BOXES
              // ==========================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  _otpLength,
                  (index) => _buildOtpBox(index),
                ),
              ),

              SizedBox(height: 32.h),

              // ==========================================
              // 5. VERIFY OTP BUTTON
              // ==========================================
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
                  onPressed: _handleVerifyCode,
                  child: Text(
                    'Verify code',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              // ==========================================
              // 6. RESEND CODE SECTION
              // ==========================================
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive a code? ",
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  InkWell(
                    onTap: () => _showDemoMessage(
                      'Demo mode: resend functionality is not connected.',
                    ),
                    borderRadius: BorderRadius.circular(4.r),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 2.h,
                      ),
                      child: Text(
                        'Resend code',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondaryGreen,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              // ==========================================
              // 7. CHANGE EMAIL OPTION
              // ==========================================
              InkWell(
                onTap: () => Navigator.of(context).pop(),
                borderRadius: BorderRadius.circular(6.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  child: Text(
                    'Change email',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondaryGreen,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 32.h),

              // ==========================================
              // 8. OPTIONAL SECURITY NOTE
              // ==========================================
              Text(
                'Your account verification will be available when ORIVIS authentication is connected.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.secondaryText,
                  height: 1.3,
                ),
              ),

              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpBox(int index) {
    final isFocused = _focusNodes[index].hasFocus;

    return Container(
      width: 48.w,
      height: 56.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: _hasError
              ? AppColors.errorRed
              : isFocused
                  ? AppColors.secondaryGreen
                  : AppColors.cardBorder,
          width: isFocused ? 2.w : 1.5.w,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: KeyboardListener(
        focusNode: FocusNode(),
        onKeyEvent: (event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.backspace) {
            if (_controllers[index].text.isEmpty && index > 0) {
              _controllers[index - 1].clear();
              _focusNodes[index - 1].requestFocus();
            }
          }
        },
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(1),
          ],
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.darkGreen,
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
          onChanged: (value) => _onOtpChanged(index, value),
        ),
      ),
    );
  }
}
