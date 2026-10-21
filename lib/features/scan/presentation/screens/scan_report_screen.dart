import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../home/presentation/screens/grower_dashboard_screen.dart';
import 'scan_orchard_screen.dart';

class ScanReportScreen extends StatefulWidget {
  final String? imagePath;
  final String orchardName;

  const ScanReportScreen({
    super.key,
    this.imagePath,
    required this.orchardName,
  });

  @override
  State<ScanReportScreen> createState() => _ScanReportScreenState();
}

class _ScanReportScreenState extends State<ScanReportScreen> {
  int _selectedBottomIndex = 0;

  void _showDemoMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.darkGreen,
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
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.warmCream,
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(
                  top: topPadding > 0 ? topPadding + 8.h : 16.h,
                  left: 20.w,
                  right: 20.w,
                  bottom: 24.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ==========================================
                    // 1. REPORT HEADER ROW
                    // ==========================================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Back Button
                        InkWell(
                          onTap: () => Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (_) => const GrowerDashboardScreen(),
                            ),
                            (route) => false,
                          ),
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

                        // Title
                        Text(
                          'Scan report',
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkGreen,
                          ),
                        ),

                        // Share / Export Button
                        InkWell(
                          onTap: () => _showDemoMessage(
                            'Demo mode: report sharing is not connected yet.',
                          ),
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
                              Icons.ios_share_outlined,
                              size: 20.r,
                              color: AppColors.darkGreen,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 8.h),

                    // Subheader Info
                    Center(
                      child: Text(
                        '${widget.orchardName} · Today · sample result',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ),

                    SizedBox(height: 18.h),

                    // ==========================================
                    // 2. DEMO NOTICE BANNER
                    // ==========================================
                    Container(
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE8C7), // Pale orange (#FFE8C7)
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            size: 20.r,
                            color: const Color(0xFFB5623B),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Text(
                              'Demo mode: All analysis figures shown below are sample data for prototype demonstration.',
                              style: TextStyle(
                                fontSize: 12.sp,
                                height: 1.35,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFB5623B),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // ==========================================
                    // 3. DETECTION OVERLAY CARD
                    // ==========================================
                    Container(
                      height: 210.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.darkGreen,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        children: [
                          // Background Image if available
                          if (widget.imagePath != null &&
                              File(widget.imagePath!).existsSync())
                            Positioned.fill(
                              child: Opacity(
                                opacity: 0.8,
                                child: Image.file(
                                  File(widget.imagePath!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                          // Illustrative Detection Bounding Boxes
                          Positioned(
                            top: 35.h,
                            left: 45.w,
                            child: _buildDetectionBox(
                              width: 44.r,
                              height: 44.r,
                              color: const Color(0xFFF99A20), // Orange
                            ),
                          ),
                          Positioned(
                            top: 45.h,
                            right: 55.w,
                            child: _buildDetectionBox(
                              width: 50.r,
                              height: 50.r,
                              color: const Color(0xFFF99A20), // Orange
                            ),
                          ),
                          Positioned(
                            bottom: 55.h,
                            left: 130.w,
                            child: _buildDetectionBox(
                              width: 48.r,
                              height: 48.r,
                              color: const Color(0xFF9BC6A0), // Pale green
                            ),
                          ),
                          Positioned(
                            bottom: 45.h,
                            right: 35.w,
                            child: _buildDetectionBox(
                              width: 42.r,
                              height: 42.r,
                              color: const Color(0xFFB3261E), // Visible damage red
                            ),
                          ),

                          // Bottom Overlay Label
                          Positioned(
                            bottom: 12.h,
                            left: 16.w,
                            child: Text(
                              'Detections overlay (illustrative)',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.subtitleLight,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // ==========================================
                    // 4. ESTIMATED FRUIT COUNT CARD
                    // ==========================================
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
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
                            'Estimated fruit count',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.secondaryText,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            '1,248',
                            style: TextStyle(
                              fontSize: 40.sp,
                              fontWeight: FontWeight.w800,
                              color: AppColors.darkGreen,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFE8C7), // Pale orange
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Text(
                              'AI estimate, may vary with lighting and occlusion',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFB5623B),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // ==========================================
                    // 5. RIPENESS CARD
                    // ==========================================
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(18.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ripeness',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryText,
                            ),
                          ),

                          SizedBox(height: 16.h),

                          // Unripe 12%
                          _buildRipenessRow(
                            label: 'Unripe',
                            percentageText: '12%',
                            percentageValue: 0.12,
                            barColor: const Color(0xFF9BC6A0),
                          ),

                          SizedBox(height: 12.h),

                          // Partially ripe 28%
                          _buildRipenessRow(
                            label: 'Partially ripe',
                            percentageText: '28%',
                            percentageValue: 0.28,
                            barColor: const Color(0xFFD8BF45),
                          ),

                          SizedBox(height: 12.h),

                          // Ripe 52%
                          _buildRipenessRow(
                            label: 'Ripe',
                            percentageText: '52%',
                            percentageValue: 0.52,
                            barColor: const Color(0xFFF99A20),
                          ),

                          SizedBox(height: 12.h),

                          // Overripe 8%
                          _buildRipenessRow(
                            label: 'Overripe',
                            percentageText: '8%',
                            percentageValue: 0.08,
                            barColor: const Color(0xFFB5623B),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // ==========================================
                    // 6. VISIBLE HEALTH CARD
                    // ==========================================
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(18.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Visible health',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryText,
                            ),
                          ),

                          SizedBox(height: 16.h),

                          Row(
                            children: [
                              // Doughnut Ring Chart
                              SizedBox(
                                height: 80.r,
                                width: 80.r,
                                child: CustomPaint(
                                  painter: _HealthDoughnutPainter(
                                    healthyPercentage: 0.86,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '86%',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.darkGreen,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(width: 20.w),

                              // Legend Column
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 8.r,
                                          width: 8.r,
                                          decoration: const BoxDecoration(
                                            color: AppColors.darkGreen,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        SizedBox(width: 8.w),
                                        Text(
                                          'Healthy 86%',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.primaryText,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10.h),
                                    Row(
                                      children: [
                                        Container(
                                          height: 8.r,
                                          width: 8.r,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFB3261E), // Red
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        SizedBox(width: 8.w),
                                        Text(
                                          'Visibly damaged 14%',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.primaryText,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 16.h),

                          Text(
                            'AI-based visual assessment only. Not a professional disease diagnosis.',
                            style: TextStyle(
                              fontSize: 12.sp,
                              height: 1.35,
                              color: AppColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // ==========================================
                    // 7. INDICATIVE VALUE CARD
                    // ==========================================
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(18.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Indicative value',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: AppColors.secondaryText,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'PKR 200,000',
                                style: TextStyle(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.darkGreen,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 5.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFE8C7), // Pale orange
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              'Sample estimate',
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFB5623B),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // ==========================================
                    // 8. ACTION BUTTONS
                    // ==========================================
                    // Primary Action: Create marketplace listing
                    SizedBox(
                      width: double.infinity,
                      height: 52.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF99A20), // Orange
                          foregroundColor: AppColors.primaryText,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                        ),
                        onPressed: () => _showDemoMessage(
                          'Demo mode: marketplace listing is not connected yet.',
                        ),
                        child: Text(
                          'Create marketplace listing',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryText,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 12.h),

                    // Secondary Action: Export report
                    SizedBox(
                      width: double.infinity,
                      height: 50.h,
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
                        onPressed: () => _showDemoMessage(
                          'Demo mode: report export is not connected yet.',
                        ),
                        child: Text(
                          'Export report',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkGreen,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ),
          ],
        ),

        // ==========================================
        // 9. PERSISTENT BOTTOM NAVIGATION BAR
        // ==========================================
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildBottomNavItem(
                    index: 0,
                    iconData: Icons.home_outlined,
                    activeIconData: Icons.home_rounded,
                    label: 'Home',
                  ),
                  _buildBottomNavItem(
                    index: 1,
                    iconData: Icons.access_time_outlined,
                    activeIconData: Icons.access_time_filled_rounded,
                    label: 'History',
                  ),
                  // Center Elevated Scan Action
                  _buildCenterScanNavItem(),
                  _buildBottomNavItem(
                    index: 3,
                    iconData: Icons.local_offer_outlined,
                    activeIconData: Icons.local_offer_rounded,
                    label: 'Bids',
                  ),
                  _buildBottomNavItem(
                    index: 4,
                    iconData: Icons.person_outline_rounded,
                    activeIconData: Icons.person_rounded,
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetectionBox({
    required double width,
    required double height,
    required Color color,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: color,
          width: 2.w,
        ),
      ),
    );
  }

  Widget _buildRipenessRow({
    required String label,
    required String percentageText,
    required double percentageValue,
    required Color barColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryText,
              ),
            ),
            Text(
              percentageText,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(4.r),
          child: SizedBox(
            height: 8.h,
            width: double.infinity,
            child: LinearProgressIndicator(
              value: percentageValue,
              backgroundColor: const Color(0xFFF0ECE0),
              valueColor: AlwaysStoppedAnimation<Color>(barColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavItem({
    required int index,
    required IconData iconData,
    required IconData activeIconData,
    required String label,
  }) {
    final isSelected = _selectedBottomIndex == index;

    return InkWell(
      onTap: () {
        if (index == 0) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => const GrowerDashboardScreen(),
            ),
            (route) => false,
          );
        } else {
          setState(() => _selectedBottomIndex = index);
          _showDemoMessage('Demo mode: $label tab is not connected yet.');
        }
      },
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE3EFE6) : Colors.transparent,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIconData : iconData,
              size: 22.r,
              color: isSelected ? AppColors.darkGreen : AppColors.secondaryText,
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.darkGreen : AppColors.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterScanNavItem() {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const ScanOrchardScreen(),
          ),
        );
      },
      borderRadius: BorderRadius.circular(18.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF99A20), // Prominent Orange (#F99A20)
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFF99A20).withValues(alpha: 0.35),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.camera_alt_outlined,
              size: 22.r,
              color: AppColors.primaryText,
            ),
            SizedBox(height: 2.h),
            Text(
              'Scan',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HealthDoughnutPainter extends CustomPainter {
  final double healthyPercentage;

  _HealthDoughnutPainter({required this.healthyPercentage});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2) - 6;

    final healthyPaint = Paint()
      ..color = AppColors.darkGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.butt;

    final damagedPaint = Paint()
      ..color = const Color(0xFFB3261E) // Red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.butt;

    const startAngle = -pi / 2;
    final healthySweepAngle = 2 * pi * healthyPercentage;
    final damagedSweepAngle = 2 * pi * (1.0 - healthyPercentage);

    // Draw Healthy Arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      healthySweepAngle,
      false,
      healthyPaint,
    );

    // Draw Damaged Arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle + healthySweepAngle,
      damagedSweepAngle,
      false,
      damagedPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
