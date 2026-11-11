import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/orchard_state_service.dart';
import '../../../marketplace/presentation/screens/received_bids_screen.dart';
import '../../../scan/presentation/screens/scan_orchard_screen.dart';
import 'add_orchard_screen.dart';
import 'edit_orchard_screen.dart';
import 'grower_dashboard_screen.dart';

class MyOrchardsScreen extends StatefulWidget {
  const MyOrchardsScreen({super.key});

  @override
  State<MyOrchardsScreen> createState() => _MyOrchardsScreenState();
}

class _MyOrchardsScreenState extends State<MyOrchardsScreen> {
  int _selectedBottomIndex = 4; // Profile tab

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;

    return AnimatedBuilder(
      animation: OrchardStateService(),
      builder: (context, child) {
        final orchards = OrchardStateService().orchards;

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
                  padding: EdgeInsets.only(
                    top: topPadding > 0 ? topPadding + 8.h : 16.h,
                    left: 20.w,
                    right: 20.w,
                    bottom: 16.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.warmCream,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      Text(
                        'My orchards',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkGreen,
                        ),
                      ),
                      SizedBox(width: 40.r), // Spacer for centering
                    ],
                  ),
                ),

                // ==========================================
                // 2. SCROLLABLE CONTENT (Subtitle + Cards + Add Button)
                // ==========================================
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                    children: [
                      // Subtitle
                      Text(
                        'Scans are linked to the orchard you pick.',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppColors.secondaryText,
                        ),
                      ),

                      SizedBox(height: 16.h),

                      // Orchard Cards List
                      ...orchards.map((orchard) => _buildOrchardCard(orchard)),

                      SizedBox(height: 20.h),

                      // + Add orchard Button
                      SizedBox(
                        width: double.infinity,
                        height: 52.h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF99A20),
                            foregroundColor: AppColors.primaryText,
                            elevation: 2,
                            shadowColor: const Color(0xFFF99A20)
                                .withValues(alpha: 0.35),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const AddOrchardScreen(),
                              ),
                            );
                          },
                          child: Text(
                            '+ Add orchard',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryText,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ],
            ),

            // ==========================================
            // 3. FIXED BOTTOM NAVIGATION BAR
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
      },
    );
  }

  Widget _buildOrchardCard(OrchardModel orchard) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.cardBorder,
          width: 1.w,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            // Top Section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Green Orchard Icon
                Container(
                  height: 44.r,
                  width: 44.r,
                  decoration: BoxDecoration(
                    color: AppColors.darkGreen,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.location_on_outlined,
                      size: 22.r,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        orchard.name,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryText,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          Icon(
                            Icons.location_pin,
                            size: 14.r,
                            color: AppColors.secondaryText,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            orchard.location,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: AppColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Variety Badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.lightGreen,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    orchard.variety,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkGreen,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 14.h),

            Divider(
              color: AppColors.cardBorder,
              height: 1.h,
              thickness: 1.w,
            ),

            SizedBox(height: 14.h),

            // Bottom Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Area: ',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.secondaryText,
                    ),
                    children: [
                      TextSpan(
                        text: '${orchard.area.toStringAsFixed(0)} ${orchard.areaUnit}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => EditOrchardScreen(orchard: orchard),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(8.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    child: Text(
                      'Edit',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkGreen,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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
        } else if (index == 3) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const ReceivedBidsScreen(),
            ),
          );
        } else if (index == 4) {
          Navigator.of(context).pop();
        } else {
          setState(() => _selectedBottomIndex = index);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Demo mode: $label tab is not connected yet.'),
              duration: const Duration(seconds: 1),
            ),
          );
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
                color: isSelected
                    ? AppColors.darkGreen
                    : AppColors.secondaryText,
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
          color: const Color(0xFFF99A20),
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
