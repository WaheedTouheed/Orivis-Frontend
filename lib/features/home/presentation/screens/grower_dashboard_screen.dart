import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../scan/presentation/screens/scan_orchard_screen.dart';

class GrowerDashboardScreen extends StatefulWidget {
  const GrowerDashboardScreen({super.key});

  @override
  State<GrowerDashboardScreen> createState() => _GrowerDashboardScreenState();
}

class _GrowerDashboardScreenState extends State<GrowerDashboardScreen> {
  int _selectedBottomIndex = 0;
  String _selectedOrchard = 'Kinnow Block A';

  final Map<String, Map<String, dynamic>> _orchardData = {
    'Kinnow Block A': {
      'fruits': '1,248',
      'scans': '12',
      'activeListings': '1',
      'newBids': '3',
      'unripe': 12,
      'partiallyRipe': 28,
      'ripe': 52,
      'overripe': 8,
    },
    'Block C': {
      'fruits': '850',
      'scans': '8',
      'activeListings': '0',
      'newBids': '1',
      'unripe': 20,
      'partiallyRipe': 35,
      'ripe': 40,
      'overripe': 5,
    },
  };

  void _showDemoMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.darkGreen,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _navigateToScanOrchard() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const ScanOrchardScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;
    final currentData =
        _orchardData[_selectedOrchard] ?? _orchardData['Kinnow Block A']!;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light, // White status bar icons on Android
        statusBarBrightness: Brightness.dark,      // White status bar text on iOS
      ),
      child: Scaffold(
        backgroundColor: AppColors.warmCream,
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    // ==========================================
                    // 1. HEADER & OVERLAPPING ESTIMATE CARD
                    // ==========================================
                    Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        // Layer A: Green Header Background Container
                        Container(
                          width: double.infinity,
                          height: 165.h + (topPadding > 0 ? topPadding : 0),
                          decoration: BoxDecoration(
                            color: AppColors.darkGreen,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(28.r),
                              bottomRight: Radius.circular(28.r),
                            ),
                          ),
                          padding: EdgeInsets.only(
                            top: topPadding > 0 ? topPadding + 10.h : 16.h,
                            left: 20.w,
                            right: 20.w,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Avatar (AR)
                              Container(
                                height: 48.r,
                                width: 48.r,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF99A20), // Orange avatar (#F99A20)
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    'AR',
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(width: 14.w),

                              // Greeting & Name
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Assalam-o-Alaikum',
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.subtitleLight,
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      'Ali Raza',
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Notification Button with Badge
                              InkWell(
                                onTap: () => _showDemoMessage(
                                  'Demo mode: notifications are not connected.',
                                ),
                                borderRadius: BorderRadius.circular(16.r),
                                child: Container(
                                  height: 44.r,
                                  width: 44.r,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Icon(
                                        Icons.notifications_none_outlined,
                                        size: 22.r,
                                        color: Colors.white,
                                      ),
                                      Positioned(
                                        top: 8.r,
                                        right: 8.r,
                                        child: Container(
                                          height: 14.r,
                                          width: 14.r,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFF99A20),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              '3',
                                              style: TextStyle(
                                                fontSize: 9.sp,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
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

                        // Layer B: Overlapping Estimate Card Positioned below Avatar Row
                        Padding(
                          padding: EdgeInsets.only(
                            top: (topPadding > 0 ? topPadding : 0) + 72.h,
                            left: 20.w,
                            right: 20.w,
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 18.w,
                              vertical: 16.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                color: AppColors.cardBorder,
                                width: 1.w,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header Row: Title & Sample Badge
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Latest AI estimate · $_selectedOrchard',
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.secondaryText,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.w,
                                        vertical: 3.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFE8C7), // Pale orange (#FFE8C7)
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                      ),
                                      child: Text(
                                        'Sample',
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFFB5623B),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 8.h),

                                // Large Fruit Count
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      '${currentData['fruits']}',
                                      style: TextStyle(
                                        fontSize: 32.sp,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.darkGreen,
                                      ),
                                    ),
                                    SizedBox(width: 6.w),
                                    Text(
                                      'fruits',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.secondaryText,
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 12.h),

                                Divider(
                                  color: AppColors.cardBorder,
                                  thickness: 1.w,
                                  height: 1.h,
                                ),

                                SizedBox(height: 12.h),

                                // Statistics Row
                                Row(
                                  children: [
                                    _buildStatCol(
                                      '${currentData['scans']}',
                                      'Scans',
                                    ),
                                    _buildStatCol(
                                      '${currentData['activeListings']}',
                                      'Active listing',
                                    ),
                                    _buildStatCol(
                                      '${currentData['newBids']}',
                                      'New bids',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20.h), // Spacing before 'Start a new scan'

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ==========================================
                          // 2. START A NEW SCAN BUTTON
                          // ==========================================
                          SizedBox(
                            width: double.infinity,
                            height: 52.h,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF99A20), // Orange (#F99A20)
                                foregroundColor: AppColors.primaryText,
                                elevation: 3,
                                shadowColor:
                                    const Color(0xFFF99A20).withValues(alpha: 0.3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                              ),
                              onPressed: _navigateToScanOrchard,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.camera_alt_outlined,
                                    size: 20.r,
                                    color: AppColors.primaryText,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    'Start a new scan',
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primaryText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 24.h),

                          // ==========================================
                          // 3. QUICK ACTIONS GRID
                          // ==========================================
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildQuickActionItem(
                                iconData: Icons.camera_alt_outlined,
                                label: 'Scan',
                                onTap: _navigateToScanOrchard,
                              ),
                              _buildQuickActionItem(
                                iconData: Icons.access_time_outlined,
                                label: 'History',
                                onTap: () => setState(() => _selectedBottomIndex = 1),
                              ),
                              _buildQuickActionItem(
                                iconData: Icons.local_offer_outlined,
                                label: 'Sell',
                                onTap: () => setState(() => _selectedBottomIndex = 3),
                              ),
                              _buildQuickActionItem(
                                iconData: Icons.credit_card_outlined,
                                label: 'Payments',
                                onTap: () => _showDemoMessage(
                                  'Demo mode: payments section is not connected yet.',
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 28.h),

                          // ==========================================
                          // 4. ORCHARDS SELECTOR SECTION
                          // ==========================================
                          Text(
                            'Orchards',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryText,
                            ),
                          ),

                          SizedBox(height: 12.h),

                          Wrap(
                            spacing: 10.w,
                            runSpacing: 10.h,
                            children: [
                              _buildOrchardChip('Kinnow Block A'),
                              _buildOrchardChip('Block C'),
                              InkWell(
                                onTap: () => _showDemoMessage(
                                  'Demo mode: adding orchards is not connected yet.',
                                ),
                                borderRadius: BorderRadius.circular(12.r),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 10.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12.r),
                                    border: Border.all(
                                      color: AppColors.cardBorder,
                                      width: 1.w,
                                    ),
                                  ),
                                  child: Text(
                                    '+ Add',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryText,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 28.h),

                          // ==========================================
                          // 5. RIPENESS OVERVIEW CARD
                          // ==========================================
                          Container(
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
                                // Title & Link
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Ripeness overview',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primaryText,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () => _showDemoMessage(
                                        'Demo mode: full report is not connected yet.',
                                      ),
                                      child: Text(
                                        'Full report',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.darkGreen,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 16.h),

                                // Stacked Percentage Bar
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(6.r),
                                  child: SizedBox(
                                    height: 12.h,
                                    width: double.infinity,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: currentData['unripe'],
                                          child: Container(
                                            color: const Color(0xFF9BC6A0),
                                          ),
                                        ),
                                        Expanded(
                                          flex: currentData['partiallyRipe'],
                                          child: Container(
                                            color: const Color(0xFFD8BF45),
                                          ),
                                        ),
                                        Expanded(
                                          flex: currentData['ripe'],
                                          child: Container(
                                            color: const Color(0xFFF99A20),
                                          ),
                                        ),
                                        Expanded(
                                          flex: currentData['overripe'],
                                          child: Container(
                                            color: const Color(0xFFB5623B),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                SizedBox(height: 16.h),

                                // Legend Items
                                Wrap(
                                  spacing: 14.w,
                                  runSpacing: 8.h,
                                  children: [
                                    _buildLegendItem(
                                      color: const Color(0xFF9BC6A0),
                                      label: 'Unripe ${currentData['unripe']}%',
                                    ),
                                    _buildLegendItem(
                                      color: const Color(0xFFD8BF45),
                                      label:
                                          'Partially ripe ${currentData['partiallyRipe']}%',
                                    ),
                                    _buildLegendItem(
                                      color: const Color(0xFFF99A20),
                                      label: 'Ripe ${currentData['ripe']}%',
                                    ),
                                    _buildLegendItem(
                                      color: const Color(0xFFB5623B),
                                      label:
                                          'Overripe ${currentData['overripe']}%',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 28.h),

                          // ==========================================
                          // 6. RECENT SCANS SECTION (3 Cards)
                          // ==========================================
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Recent scans',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryText,
                                ),
                              ),
                              InkWell(
                                onTap: () => setState(() => _selectedBottomIndex = 1),
                                child: Text(
                                  'See all',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.darkGreen,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 12.h),

                          // Scan Card 1
                          _buildRecentScanCard(
                            orchardTitle: 'Kinnow Block A',
                            subtitle: 'Today · 1,248 fruits',
                            statusLabel: 'Completed',
                            isCompleted: true,
                          ),

                          SizedBox(height: 10.h),

                          // Scan Card 2
                          _buildRecentScanCard(
                            orchardTitle: 'Block C',
                            subtitle: '3 days ago · 860 fruits',
                            statusLabel: 'Completed',
                            isCompleted: true,
                          ),

                          SizedBox(height: 10.h),

                          // Scan Card 3
                          _buildRecentScanCard(
                            orchardTitle: 'Kinnow Block A',
                            subtitle: 'Last week · — fruits',
                            statusLabel: 'Processing',
                            isCompleted: false,
                          ),

                          SizedBox(height: 28.h),

                          // ==========================================
                          // 7. YOUR LISTING SECTION
                          // ==========================================
                          Text(
                            'Your listing',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryText,
                            ),
                          ),

                          SizedBox(height: 12.h),

                          Container(
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
                                // Title & Active Badge
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _selectedOrchard,
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primaryText,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10.w,
                                        vertical: 5.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEAF1E9), // Light green badge
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                      ),
                                      child: Text(
                                        'Active',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.darkGreen,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 8.h),

                                // Bidding Summary Details
                                Text(
                                  'Asking PKR 200,000 · Highest bid PKR 182,000 · 3 bids',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    height: 1.35,
                                    color: AppColors.secondaryText,
                                  ),
                                ),

                                SizedBox(height: 16.h),

                                // Outlined Button: Review bids
                                SizedBox(
                                  width: double.infinity,
                                  height: 48.h,
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppColors.darkGreen,
                                      side: BorderSide(
                                        color: AppColors.darkGreen,
                                        width: 1.5.w,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(14.r),
                                      ),
                                    ),
                                    onPressed: () => setState(
                                      () => _selectedBottomIndex = 3,
                                    ),
                                    child: Text(
                                      'Review bids',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.darkGreen,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 28.h),

                          // ==========================================
                          // 8. SCANNING TIP CARD
                          // ==========================================
                          Container(
                            padding: EdgeInsets.all(18.w),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAF1E9), // Light pale green background
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.lightbulb_outline_rounded,
                                      size: 20.r,
                                      color: AppColors.darkGreen,
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      'Scanning tip',
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.darkGreen,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  'Move slowly around the tree for about 20 seconds in even daylight. Steady footage gives a more reliable count.',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    height: 1.4,
                                    color: AppColors.secondaryText,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 20.h),

                          // ==========================================
                          // 9. SAMPLE DATA DISCLAIMER
                          // ==========================================
                          Center(
                            child: Text(
                              'All figures are sample data for the prototype.',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.secondaryText,
                              ),
                            ),
                          ),

                          SizedBox(height: 28.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        // ==========================================
        // 10. PERSISTENT BOTTOM NAVIGATION BAR
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

  Widget _buildRecentScanCard({
    required String orchardTitle,
    required String subtitle,
    required String statusLabel,
    required bool isCompleted,
  }) {
    return Container(
      padding: EdgeInsets.all(14.w),
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
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Fruit Thumbnail Container
          Container(
            height: 52.r,
            width: 52.r,
            decoration: BoxDecoration(
              color: AppColors.darkGreen,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Center(
              child: Icon(
                Icons.circle,
                size: 20.r,
                color: const Color(0xFFF99A20),
              ),
            ),
          ),

          SizedBox(width: 14.w),

          // Details Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  orchardTitle,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryText,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 8.w),

          // Status Badge
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10.w,
              vertical: 6.h,
            ),
            decoration: BoxDecoration(
              color: isCompleted
                  ? const Color(0xFFEAF1E9) // Light green
                  : const Color(0xFFFFE8C7), // Pale orange
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Text(
              statusLabel,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: isCompleted
                    ? AppColors.darkGreen
                    : const Color(0xFFB5623B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCol(String count, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            count,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.darkGreen,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionItem({
    required IconData iconData,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Column(
        children: [
          Container(
            height: 56.r,
            width: 56.r,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: AppColors.cardBorder,
                width: 1.w,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                iconData,
                size: 22.r,
                color: AppColors.primaryText,
              ),
            ),
          ),
          SizedBox(height: 8.h),
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
    );
  }

  Widget _buildOrchardChip(String orchardName) {
    final isSelected = _selectedOrchard == orchardName;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedOrchard = orchardName;
        });
      },
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFE8C7) : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? const Color(0xFFF99A20) : AppColors.cardBorder,
            width: isSelected ? 1.5.w : 1.w,
          ),
        ),
        child: Text(
          orchardName,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: isSelected ? AppColors.darkGreen : AppColors.primaryText,
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem({required Color color, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 8.r,
          width: 8.r,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 6.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: AppColors.secondaryText,
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
        setState(() {
          _selectedBottomIndex = index;
        });
        if (index != 0) {
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
      onTap: _navigateToScanOrchard,
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
