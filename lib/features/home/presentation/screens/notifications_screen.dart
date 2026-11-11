import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../marketplace/presentation/screens/received_bids_screen.dart';
import '../../../scan/presentation/screens/scan_report_screen.dart';
import '../../../scan/presentation/screens/scan_orchard_screen.dart';
import 'grower_dashboard_screen.dart';
import 'profile_screen.dart';

class NotificationItem {
  final String id;
  final String title;
  final String description;
  final String time;
  final String category; // 'Bids', 'Listings', 'Scans', 'System'
  final IconData iconData;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.category,
    required this.iconData,
    this.isRead = false,
  });
}

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

  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      title: 'New bid received!',
      description:
          'Al-Noor Traders placed a bid of PKR 182,000 for Kinnow Block A.',
      time: '5 minutes ago',
      category: 'Bids',
      iconData: Icons.handshake_outlined,
      isRead: false,
    ),
    NotificationItem(
      id: '2',
      title: 'Bid accepted successfully',
      description:
          "You accepted Madni Fruit Co.'s bid of PKR 176,500 for Kinnow Block A.",
      time: '1 hour ago',
      category: 'Bids',
      iconData: Icons.check_circle_outline,
      isRead: false,
    ),
    NotificationItem(
      id: '3',
      title: 'Bid rejected',
      description:
          "You rejected Shah Agency's bid of PKR 168,000 for Kinnow Block A.",
      time: '3 hours ago',
      category: 'Bids',
      iconData: Icons.cancel_outlined,
      isRead: true,
    ),
    NotificationItem(
      id: '4',
      title: 'Buyer withdrew a bid',
      description: 'A buyer withdrew their PKR 165,000 bid for Kinnow Block A.',
      time: 'Yesterday',
      category: 'Bids',
      iconData: Icons.trending_down_rounded,
      isRead: true,
    ),
    NotificationItem(
      id: '5',
      title: 'Your listing is getting attention!',
      description: 'Kinnow Block A has received 3 bids from buyers.',
      time: 'Yesterday',
      category: 'Listings',
      iconData: Icons.people_outline_rounded,
      isRead: true,
    ),
    NotificationItem(
      id: '6',
      title: 'Listing expires soon',
      description: 'Your Kinnow Block A listing will expire in 2 days.',
      time: '2 days ago',
      category: 'Listings',
      iconData: Icons.access_time_rounded,
      isRead: true,
    ),
    NotificationItem(
      id: '7',
      title: 'Orchard scan completed',
      description: 'Your scan report for Kinnow Block A is ready to view.',
      time: '2 days ago',
      category: 'Scans',
      iconData: Icons.camera_alt_outlined,
      isRead: true,
    ),
    NotificationItem(
      id: '8',
      title: 'Marketplace update',
      description: 'New buyers are now available in your marketplace.',
      time: '3 days ago',
      category: 'System',
      iconData: Icons.notifications_none_outlined,
      isRead: true,
    ),
  ];

  List<NotificationItem> get _filteredNotifications {
    if (_selectedCategory == 'All') {
      return _notifications;
    }
    return _notifications
        .where((n) => n.category == _selectedCategory)
        .toList();
  }

  void _markAllAsRead() {
    setState(() {
      for (var n in _notifications) {
        n.isRead = true;
      }
    });
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
              setState(() {
                _notifications.clear();
              });
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
    setState(() {
      notification.isRead = true;
    });

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
    final filtered = _filteredNotifications;

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
                bottom: 12.h,
              ),
              decoration: BoxDecoration(
                color: AppColors.warmCream,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                      SizedBox(width: 12.w),
                      Text(
                        'Notifications',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkGreen,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: _markAllAsRead,
                        child: Text(
                          'Mark all read',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkGreen,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: _clearAllNotifications,
                        icon: Icon(
                          Icons.delete_outline_rounded,
                          size: 20.r,
                          color: AppColors.secondaryText,
                        ),
                        tooltip: 'Clear All',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ==========================================
            // 2. CATEGORY CHIPS FILTER ROW
            // ==========================================
            Container(
              height: 48.h,
              margin: EdgeInsets.only(bottom: 8.h),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = cat;
                        });
                      },
                      selectedColor: AppColors.darkGreen,
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : AppColors.darkGreen,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        side: BorderSide(
                          color: isSelected
                              ? AppColors.darkGreen
                              : AppColors.cardBorder,
                          width: 1.w,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                    ),
                  );
                },
              ),
            ),

            // ==========================================
            // 3. NOTIFICATION LIST (OR EMPTY STATE)
            // ==========================================
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 64.r,
                            width: 64.r,
                            decoration: BoxDecoration(
                              color: AppColors.lightGreen,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Icon(
                              Icons.notifications_off_outlined,
                              size: 32.r,
                              color: AppColors.darkGreen,
                            ),
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
                          SizedBox(height: 6.h),
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 8.h,
                      ),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final notification = filtered[index];
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

  Widget _buildNotificationCard(NotificationItem notification) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: notification.isRead ? Colors.white : const Color(0xFFF7FBF8),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: notification.isRead
              ? AppColors.cardBorder
              : AppColors.darkGreen.withValues(alpha: 0.25),
          width: notification.isRead ? 1.w : 1.5.w,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
        child: InkWell(
          onTap: () => _handleNotificationTap(notification),
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.all(14.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Icon Container
                Container(
                  height: 42.r,
                  width: 42.r,
                  decoration: BoxDecoration(
                    color: AppColors.lightGreen,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Center(
                    child: Icon(
                      notification.iconData,
                      size: 20.r,
                      color: AppColors.darkGreen,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),

                // Content Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: notification.isRead
                                    ? FontWeight.w600
                                    : FontWeight.w800,
                                color: AppColors.primaryText,
                              ),
                            ),
                          ),
                          if (!notification.isRead)
                            Container(
                              height: 8.r,
                              width: 8.r,
                              margin: EdgeInsets.only(left: 8.w, top: 4.h),
                              decoration: const BoxDecoration(
                                color: AppColors.darkGreen,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        notification.description,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppColors.secondaryText,
                          height: 1.35,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            notification.time,
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: AppColors.placeholderColor,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.warmCream,
                              borderRadius: BorderRadius.circular(6.r),
                              border: Border.all(
                                color: AppColors.cardBorder,
                                width: 0.8.w,
                              ),
                            ),
                            child: Text(
                              notification.category,
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.secondaryText,
                              ),
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
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const ProfileScreen(),
            ),
          );
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
