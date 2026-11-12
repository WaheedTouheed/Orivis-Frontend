import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../scan/presentation/screens/scan_history_screen.dart';
import '../screens/vendor_bids_history_screen.dart';
import '../screens/vendor_dashboard_screen.dart';
import '../screens/vendor_orders_screen.dart';
import '../screens/vendor_profile_screen.dart';

class VendorBottomNavigation extends StatelessWidget {
  final int selectedIndex;

  const VendorBottomNavigation({
    super.key,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                context: context,
                index: 0,
                iconData: Icons.home_outlined,
                activeIconData: Icons.home_rounded,
                label: 'Home',
              ),
              _buildBottomNavItem(
                context: context,
                index: 1,
                iconData: Icons.access_time_outlined,
                activeIconData: Icons.access_time_filled_rounded,
                label: 'History',
              ),
              _buildCenterOrdersNavItem(context),
              _buildBottomNavItem(
                context: context,
                index: 3,
                iconData: Icons.local_offer_outlined,
                activeIconData: Icons.local_offer_rounded,
                label: 'Bids',
              ),
              _buildBottomNavItem(
                context: context,
                index: 4,
                iconData: Icons.person_outline_rounded,
                activeIconData: Icons.person_rounded,
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem({
    required BuildContext context,
    required int index,
    required IconData iconData,
    required IconData activeIconData,
    required String label,
  }) {
    final isSelected = selectedIndex == index;

    return InkWell(
      onTap: () {
        if (isSelected) return;
        if (index == 0) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const VendorDashboardScreen()),
            (route) => false,
          );
        } else if (index == 1) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const ScanHistoryScreen()),
          );
        } else if (index == 3) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const VendorBidsHistoryScreen()),
          );
        } else if (index == 4) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const VendorProfileScreen()),
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
                color: isSelected ? AppColors.darkGreen : AppColors.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterOrdersNavItem(BuildContext context) {
    final isSelected = selectedIndex == 2;

    return InkWell(
      onTap: () {
        if (isSelected) return;
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const VendorOrdersScreen()),
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
              Icons.inventory_2_outlined,
              size: 22.r,
              color: AppColors.primaryText,
            ),
            SizedBox(height: 2.h),
            Text(
              'Orders',
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
