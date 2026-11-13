import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/notifications_state_service.dart';
import '../../../marketplace/presentation/screens/received_bids_screen.dart';
import '../../../scan/presentation/screens/scan_report_screen.dart';
import '../../../scan/presentation/screens/scan_orchard_screen.dart';
import '../../../scan/presentation/screens/scan_history_screen.dart';
import 'grower_dashboard_screen.dart';
import 'profile_screen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _selectedCategory = 'All';
  int _selectedBottomIndex = 0; // Home tab

  final List<String> _categories = [
    'All',
    'Bids',
    'Listings',
    'Scans',
    'System',
  ];

  void _markAllAsRead() {
    NotificationsStateService().markAllAsRead();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _clearAllNotifications() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        backgroundColor: Colors.white,
        title: Text(
          'Clear All Notifications?',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.darkGreen,
          ),
        ),
        content: Text(
          'Are you sure you want to clear all notifications? This action cannot be undone.',
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.secondaryText,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.secondaryText,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorRed,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              NotificationsStateService().clearAll();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All notifications cleared.'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: Text(
              'Clear All',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleNotificationTap(NotificationItem notification) {
    NotificationsStateService().markAsRead(notification.id);

    if (notification.category == 'Bids' ||
        notification.title.toLowerCase().contains('bid')) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const ReceivedBidsScreen(),
        ),
      );
    } else if (notification.category == 'Scans' ||
        notification.title.toLowerCase().contains('scan')) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const ScanReportScreen(orchardName: 'Kinnow Block A'),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          backgroundColor: Colors.white,
          title: Text(
            notification.title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.darkGreen,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notification.description,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.primaryText,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                notification.time,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.secondaryText,
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darkGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;

    return AnimatedBuilder(
      animation: NotificationsStateService(),
      builder: (context, child) {
        final allNotifications = NotificationsStateService().notifications;
        final filteredNotifications = _selectedCategory == 'All'
            ? allNotifications
            : allNotifications
                .where((n) => n.category == _selectedCategory)
                .toList();

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
                // 1. FIXED TOP HEADER BAR
                // ==========================================
                Container(
                  padding: EdgeInsets.only(
                    top: topPadding > 0 ? topPadding + 8.h : 16.h,
                    left: 20.w,
                    right: 20.w,
                    bottom: 16.h,
                  ),
                  decoration: const BoxDecoration(
                    color: AppColors.warmCream,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back Button
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
                            size: 18.r,
                            color: AppColors.darkGreen,
                          ),
                        ),
                      ),

                      // Screen Title
                      Text(
                        'Notifications',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkGreen,
                        ),
                      ),

                      // Header Actions (Mark all read & Clear all)
                      Row(
                        children: [
                          if (NotificationsStateService().unreadCount > 0)
                            IconButton(
                              onPressed: _markAllAsRead,
                              tooltip: 'Mark all as read',
                              icon: Icon(
                                Icons.done_all_rounded,
                                size: 22.r,
                                color: AppColors.darkGreen,
                              ),
                            ),
                          if (allNotifications.isNotEmpty)
                            IconButton(
                              onPressed: _clearAllNotifications,
                              tooltip: 'Clear all',
                              icon: Icon(
                                Icons.delete_outline_rounded,
                                size: 22.r,
                                color: AppColors.errorRed,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ==========================================
                // 2. CATEGORY CHIPS SCFilter BAR
                // ==========================================
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
                  child: Row(
                    children: _categories.map((cat) {
                      final isSelected = _selectedCategory == cat;
                      return Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: FilterChip(
                          selected: isSelected,
                          showCheckmark: false,
                          label: Text(cat),
                          labelStyle: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: isSelected
                                ? Colors.white
                                : AppColors.secondaryText,
                          ),
                          backgroundColor: Colors.white,
                          selectedColor: AppColors.darkGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.r),
                            side: BorderSide(
                              color: isSelected
                                  ? AppColors.darkGreen
                                  : AppColors.cardBorder,
                              width: 1.w,
                            ),
                          ),
                          onSelected: (_) {
                            setState(() {
                              _selectedCategory = cat;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),

                SizedBox(height: 12.h),

                // ==========================================
                // 3. NOTIFICATIONS LIST / EMPTY STATE
                // ==========================================
                Expanded(
                  child: filteredNotifications.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.notifications_off_outlined,
                                size: 64.r,
                                color: AppColors.secondaryText
                                    .withValues(alpha: 0.5),
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                'No notifications found',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryText,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                'You have no notifications in "$_selectedCategory".',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: AppColors.secondaryText,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          itemCount: filteredNotifications.length,
                          itemBuilder: (context, index) {
                            final notification = filteredNotifications[index];
                            return _buildNotificationCard(notification);
                          },
                        ),
                ),
              ],
            ),

            // ==========================================
            // 4. FIXED BOTTOM NAVIGATION BAR
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
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
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

  Widget _buildNotificationCard(NotificationItem notification) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: notification.isRead ? Colors.white : const Color(0xFFF4FAF5),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: notification.isRead
              ? AppColors.cardBorder
              : AppColors.darkGreen.withValues(alpha: 0.3),
          width: 1.w,
        ),
      ),
      child: InkWell(
        onTap: () => _handleNotificationTap(notification),
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.all(14.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon Badge
              Container(
                height: 40.r,
                width: 40.r,
                decoration: BoxDecoration(
                  color: notification.isRead
                      ? AppColors.darkGreen.withValues(alpha: 0.1)
                      : AppColors.darkGreen,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  notification.iconData,
                  size: 20.r,
                  color: notification.isRead
                      ? AppColors.darkGreen
                      : Colors.white,
                ),
              ),

              SizedBox(width: 12.w),

              // Title, Description & Time
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: notification.isRead
                                  ? FontWeight.w600
                                  : FontWeight.bold,
                              color: AppColors.primaryText,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            height: 8.r,
                            width: 8.r,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF99A20),
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      notification.description,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.secondaryText,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      notification.time,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.secondaryText.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
        } else if (index == 1) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const ScanHistoryScreen(),
            ),
          );
        } else if (index == 3) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const ReceivedBidsScreen(),
            ),
          );
        } else if (index == 4) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const ProfileScreen(),
            ),
          );
        } else {
          setState(() {
            _selectedBottomIndex = index;
          });
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
              color:
                  isSelected ? AppColors.darkGreen : AppColors.secondaryText,
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color:
                    isSelected ? AppColors.darkGreen : AppColors.secondaryText,
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
