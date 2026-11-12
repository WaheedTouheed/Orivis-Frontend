import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';

class VendorBusinessOtpScreen extends StatefulWidget {
  const VendorBusinessOtpScreen({super.key});

  @override
  State<VendorBusinessOtpScreen> createState() =>
      _VendorBusinessOtpScreenState();
}

class _VendorBusinessOtpScreenState extends State<VendorBusinessOtpScreen> {
  static const int _otpLength = 4;
  final List<TextEditingController> _controllers =
      List.generate(_otpLength, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
      List.generate(_otpLength, (_) => FocusNode());

  bool _hasError = false;
  bool _isVerifying = false;

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _currentOtp {
    return _controllers.map((c) => c.text.trim()).join();
  }

  void _onOtpDigitChanged(int index, String value) {
    if (value.length > 1) {
      // Paste detected
      final digits = value.replaceAll(RegExp(r'\D'), '');
      for (int i = 0; i < _otpLength; i++) {
        if (i < digits.length) {
          _controllers[i].text = digits[i];
        }
      }
      if (digits.length >= _otpLength) {
        _focusNodes[_otpLength - 1].unfocus();
        _verifyOtp();
      } else if (digits.isNotEmpty) {
        _focusNodes[digits.length.clamp(0, _otpLength - 1)].requestFocus();
      }
      return;
    }

    if (value.isNotEmpty) {
      if (index < _otpLength - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
        _verifyOtp();
      }
    }
  }

  void _handleBackspace(int index) {
    if (_controllers[index].text.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _verifyOtp() async {
    final code = _currentOtp;
    if (code.length < _otpLength) {
      setState(() => _hasError = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the complete 4-digit verification code.'),
          backgroundColor: AppColors.errorRed,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _isVerifying = true;
      _hasError = false;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    if (code == '1234') {
      setState(() => _isVerifying = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Identity verified successfully!'),
          backgroundColor: AppColors.darkGreen,
          duration: Duration(seconds: 1),
        ),
      );
      Navigator.of(context).pop(true);
    } else {
      setState(() {
        _isVerifying = false;
        _hasError = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid verification code. Please enter demo code 1234.'),
          backgroundColor: AppColors.errorRed,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _handleResendCode() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content:
            Text('Resend code requested. Use demo verification code: 1234'),
        backgroundColor: AppColors.darkGreen,
        duration: Duration(seconds: 2),
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
            // 1. FIXED TOP APP BAR
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
                        onTap: () => Navigator.of(context).pop(false),
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
                        child: Row(
                          children: [
                            Icon(
                              Icons.security_rounded,
                              size: 14.r,
                              color: AppColors.darkGreen,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'Security Verification',
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.darkGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Verify your identity',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGreen,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Enter the 4-digit verification code to edit your business details.',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),

            // ==========================================
            // 2. SCROLLABLE CONTENT
            // ==========================================
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Demo Info Notice Banner
                    Container(
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF8E1),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: const Color(0xFFFFE082),
                          width: 1.w,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            color: const Color(0xFFF57F17),
                            size: 20.r,
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Text(
                              'Verification is required before modifying business records. For demo verification, use code 1234.',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: const Color(0xFF5D4037),
                                height: 1.35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 32.h),

                    // 4-Digit OTP Input Boxes
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(_otpLength, (index) {
                        return SizedBox(
                          width: 60.w,
                          height: 64.h,
                          child: KeyboardListener(
                            focusNode: FocusNode(),
                            onKeyEvent: (event) {
                              if (event is KeyDownEvent &&
                                  event.logicalKey ==
                                      LogicalKeyboardKey.backspace) {
                                _handleBackspace(index);
                              }
                            },
                            child: TextField(
                              controller: _controllers[index],
                              focusNode: _focusNodes[index],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.darkGreen,
                              ),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(4),
                              ],
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.zero,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14.r),
                                  borderSide: BorderSide(
                                    color: _hasError
                                        ? AppColors.errorRed
                                        : AppColors.cardBorder,
                                    width: 1.w,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14.r),
                                  borderSide: BorderSide(
                                    color: _hasError
                                        ? AppColors.errorRed
                                        : AppColors.cardBorder,
                                    width: 1.w,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14.r),
                                  borderSide: BorderSide(
                                    color: _hasError
                                        ? AppColors.errorRed
                                        : AppColors.secondaryGreen,
                                    width: 2.w,
                                  ),
                                ),
                              ),
                              onChanged: (val) =>
                                  _onOtpDigitChanged(index, val),
                            ),
                          ),
                        );
                      }),
                    ),

                    SizedBox(height: 16.h),

                    if (_hasError)
                      Center(
                        child: Text(
                          'Incorrect code. Enter demo verification code 1234.',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.errorRed,
                          ),
                        ),
                      ),

                    SizedBox(height: 28.h),

                    // Verify Button
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
                        onPressed: _isVerifying ? null : _verifyOtp,
                        child: _isVerifying
                            ? SizedBox(
                                height: 20.r,
                                width: 20.r,
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Verify & Continue',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // Resend Code Action
                    Center(
                      child: TextButton(
                        onPressed: _handleResendCode,
                        child: Text.rich(
                          TextSpan(
                            text: "Didn't receive code? ",
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: AppColors.secondaryText,
                            ),
                            children: [
                              TextSpan(
                                text: 'Resend Code',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFF99A20),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
