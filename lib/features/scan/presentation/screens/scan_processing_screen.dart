import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import 'scan_report_screen.dart';

class ScanProcessingScreen extends StatefulWidget {
  final String? imagePath;
  final String orchardName;

  const ScanProcessingScreen({
    super.key,
    this.imagePath,
    required this.orchardName,
  });

  @override
  State<ScanProcessingScreen> createState() => _ScanProcessingScreenState();
}

class _ScanProcessingScreenState extends State<ScanProcessingScreen> {
  // Step States: 0 = Pending, 1 = In Progress, 2 = Completed
  final List<int> _stepStates = [1, 0, 0, 0]; // Step 1 starts In Progress
  Timer? _processingTimer;
  int _currentStepIndex = 0;
  bool _isCancelled = false;

  final List<String> _stepTitles = [
    'Uploading media',
    'Detecting and counting fruit',
    'Classifying ripeness and health',
    'Building your report',
  ];

  @override
  void initState() {
    super.initState();
    _startSimulatedProcessing();
  }

  void _startSimulatedProcessing() {
    _processingTimer = Timer.periodic(
      const Duration(milliseconds: 1400),
      (timer) {
        if (!mounted || _isCancelled) {
          timer.cancel();
          return;
        }

        setState(() {
          // Mark current step as Completed
          _stepStates[_currentStepIndex] = 2;

          // Move to next step if available
          if (_currentStepIndex < _stepTitles.length - 1) {
            _currentStepIndex++;
            _stepStates[_currentStepIndex] = 1; // Mark next step In Progress
          } else {
            // All 4 steps completed
            timer.cancel();
            _handleProcessingComplete();
          }
        });
      },
    );
  }

  void _handleProcessingComplete() {
    if (!mounted || _isCancelled) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Demo mode: AI analysis is not connected yet.'),
        backgroundColor: AppColors.darkGreen,
        duration: Duration(seconds: 2),
      ),
    );

    // Pause briefly so user sees all 4 green checkmarks
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted && !_isCancelled) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => ScanReportScreen(
              imagePath: widget.imagePath,
              orchardName: widget.orchardName,
            ),
          ),
        );
      }
    });
  }

  void _handleCancel() {
    _isCancelled = true;
    _processingTimer?.cancel();
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _processingTimer?.cancel();
    super.dispose();
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
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(
              top: topPadding > 0 ? topPadding + 8.h : 16.h,
              left: 20.w,
              right: 20.w,
              bottom: 24.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ==========================================
                // 1. HEADER SECTION
                // ==========================================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: _handleCancel,
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
                    Text(
                      'Processing',
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkGreen,
                      ),
                    ),
                    SizedBox(width: 40.r), // Spacer
                  ],
                ),

                SizedBox(height: 28.h),

                // ==========================================
                // 2. MAIN PROCESSING CARD
                // ==========================================
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(22.w),
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
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Top Center Fruit Illustration
                      Container(
                        height: 52.r,
                        width: 52.r,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF99A20), // Orange
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.eco,
                            size: 30.r,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      SizedBox(height: 18.h),

                      // Heading
                      Text(
                        'Analysing your scan',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkGreen,
                        ),
                      ),

                      SizedBox(height: 8.h),

                      // Subtitle Description
                      Text(
                        'Video can take longer than a photo. Your report will also appear in History.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13.sp,
                          height: 1.35,
                          color: AppColors.secondaryText,
                        ),
                      ),

                      SizedBox(height: 28.h),

                      // ----------------------------------------
                      // 4 SEQUENTIAL STEPS
                      // ----------------------------------------
                      Column(
                        children: List.generate(
                          _stepTitles.length,
                          (index) => _buildStepRow(
                            title: _stepTitles[index],
                            state: _stepStates[index],
                          ),
                        ),
                      ),

                      SizedBox(height: 28.h),

                      // ----------------------------------------
                      // CANCEL BUTTON
                      // ----------------------------------------
                      SizedBox(
                        width: double.infinity,
                        height: 48.h,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.darkGreen,
                            side: BorderSide(
                              color: AppColors.darkGreen,
                              width: 1.5.w,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                          ),
                          onPressed: _handleCancel,
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkGreen,
                            ),
                          ),
                        ),
                      ),
                    ],
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

  Widget _buildStepRow({
    required String title,
    required int state, // 0 = Pending, 1 = In Progress, 2 = Completed
  }) {
    Widget iconWidget;
    TextStyle textStyle;

    if (state == 2) {
      // Completed -> Green Checkmark Icon & Bold Green Text
      iconWidget = Icon(
        Icons.check_rounded,
        size: 20.r,
        color: AppColors.darkGreen,
      );
      textStyle = TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.darkGreen,
      );
    } else if (state == 1) {
      // In Progress -> Active Spinner / Active Icon & Darker Text
      iconWidget = SizedBox(
        height: 18.r,
        width: 18.r,
        child: const CircularProgressIndicator(
          strokeWidth: 2.5,
          color: AppColors.darkGreen,
        ),
      );
      textStyle = TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.primaryText,
      );
    } else {
      // Pending -> Hollow Circle & Muted Text
      iconWidget = Icon(
        Icons.circle_outlined,
        size: 20.r,
        color: AppColors.placeholderColor,
      );
      textStyle = TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.secondaryText,
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          SizedBox(
            width: 24.r,
            height: 24.r,
            child: Center(child: iconWidget),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              title,
              style: textStyle,
            ),
          ),
        ],
      ),
    );
  }
}
