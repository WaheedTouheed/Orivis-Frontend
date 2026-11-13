import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import 'create_new_password_screen.dart';

class PasswordResetOtpScreen extends StatefulWidget {
  final String role; // 'Grower' or 'Vendor'
  final String email;

  const PasswordResetOtpScreen({
    super.key,
    required this.role,
    required this.email,
  });

  @override
  State<PasswordResetOtpScreen> createState() => _PasswordResetOtpScreenState();
}

class _PasswordResetOtpScreenState extends State<PasswordResetOtpScreen> {
  static const int _otpLength = 6;
  final List<TextEditingController> _controllers =
      List.generate(_otpLength, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
      List.generate(_otpLength, (_) => FocusNode());

  bool _hasError = false;
  bool _isVerifying = false;

  Timer? _resendTimer;
  int _resendCountdown = 30;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startResendTimer() {
    setState(() {
      _resendCountdown = 30;
      _canResend = false;
    });
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown > 1) {
        setState(() {
          _resendCountdown--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }

  String get _currentOtp {
    return _controllers.map((c) => c.text.trim()).join();
  }

  void _handleVerifyCode() async {
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

    setState(() {
      _isVerifying = true;
      _hasError = false;
    });

    await Future.delayed(const Duration(milliseconds: 400));

    if (!mounted) return;

    setState(() => _isVerifying = false);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CreateNewPasswordScreen(
          role: widget.role,
          email: widget.email,
        ),
      ),
    );
  }

  void _handleResendCode() {
    if (!_canResend) return;
    _startResendTimer();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password reset code resent to your email.'),
        backgroundColor: AppColors.darkGreen,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onOtpChanged(int index, String value) {
    if (value.isNotEmpty) {
      if (value.length > 1) {
        final digits = value.replaceAll(RegExp(r'\D'), '');
        for (int i = 0; i < _otpLength; i++) {
          if (i < digits.length) {
            _controllers[i].text = digits[i];
          }
        }
        if (digits.length >= _otpLength) {
          _focusNodes[_otpLength - 1].unfocus();
          _handleVerifyCode();
        } else if (digits.isNotEmpty) {
          _focusNodes[digits.length.clamp(0, _otpLength - 1)].requestFocus();
        }
        setState(() => _hasError = false);
        return;
      }

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

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.warmCream,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Navigation Back Row
                Align(
                  alignment: Alignment.centerLeft,
                  child: InkWell(
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
                        size: 18.r,
                        color: AppColors.darkGreen,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 12.h),

                // Logo
                Center(
                  child: Image.asset(
                    AppAssets.logo,
                    height: 56.h,
                    width: 56.w,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.eco_rounded,
                        size: 52.r,
                        color: AppColors.darkGreen,
                      );
                    },
                  ),
                ),

                SizedBox(height: 16.h),

                Text(
                  'Password Reset Code',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkGreen,
                  ),
                ),

                SizedBox(height: 6.h),

                Text(
                  'Enter the 6-digit code to continue resetting your password.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.secondaryText,
                  ),
                ),

                SizedBox(height: 14.h),

                // Role Badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3EFE6),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    roleBadgeLabel,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                      color: AppColors.darkGreen,
                    ),
                  ),
                ),

                SizedBox(height: 20.h),

                // Card Container
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
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        widget.email.isNotEmpty
                            ? widget.email
                            : 'user@example.com',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkGreen,
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // 6 OTP Input Boxes
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          _otpLength,
                          (index) => _buildOtpBox(index),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      if (_hasError) ...[
                        Text(
                          'Please enter a valid 6-digit code.',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.errorRed,
                          ),
                        ),
                        SizedBox(height: 16.h),
                      ],

                      // Verify Code Button
                      SizedBox(
                        width: double.infinity,
                        height: 50.h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.darkGreen,
                            foregroundColor: Colors.white,
                            elevation: 2,
                            shadowColor:
                                AppColors.darkGreen.withValues(alpha: 0.25),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                          ),
                          onPressed: _isVerifying ? null : _handleVerifyCode,
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
                                  'Verify & Reset Password',
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),

                      SizedBox(height: 18.h),

                      // Resend Code Section
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
                          _canResend
                              ? InkWell(
                                  onTap: _handleResendCode,
                                  child: Text(
                                    'Resend Code',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFFF99A20),
                                    ),
                                  ),
                                )
                              : Text(
                                  'Resend in 0:${_resendCountdown.toString().padLeft(2, '0')}',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.secondaryText,
                                  ),
                                ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtpBox(int index) {
    final isFocused = _focusNodes[index].hasFocus;
    final isFilled = _controllers[index].text.isNotEmpty;

    return Container(
      width: 44.w,
      height: 54.h,
      decoration: BoxDecoration(
        color: isFilled ? const Color(0xFFF4F8F5) : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: _hasError
              ? AppColors.errorRed
              : isFocused
                  ? const Color(0xFFF99A20)
                  : isFilled
                      ? AppColors.darkGreen
                      : AppColors.cardBorder,
          width: isFocused || isFilled ? 1.8.w : 1.w,
        ),
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
            fontSize: 20.sp,
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
