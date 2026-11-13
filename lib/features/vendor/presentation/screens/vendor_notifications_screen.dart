import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/vendor_bottom_navigation.dart';
import 'vendor_dashboard_screen.dart';
import 'vendor_orders_screen.dart';
import 'vendor_payments_screen.dart';

class VendorNotificationItem {
  final String id;
  final String title;
  final String description;
  final String time;
  final String category; // 'Bids', 'Payments', 'Listings', 'Orders', 'System'
  final IconData iconData;
  final Color iconBgColor;
  bool isRead;
  final String? targetRoute;

  VendorNotificationItem({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.category,
    required this.iconData,
    this.iconBgColor = const Color(0xFFE3EFE6),
    this.isRead = false,
    this.targetRoute,
  });
}

class VendorNotificationsScreen extends StatefulWidget {
  const VendorNotificationsScreen({super.key});

  @override
  State<VendorNotificationsScreen> createState() =>
      _VendorNotificationsScreenState();
}

class _VendorNotificationsScreenState
    extends State<VendorNotificationsScreen> {
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Bids',
    'Payments',
    'Listings',
    'Orders',
  ];

  final List<VendorNotificationItem> _notifications = [
    VendorNotificationItem(
      id: 'vn_001',
      title: 'Bid Accepted!',
      description:
          'Your bid of PKR 182,000 for Kinnow Block A was accepted by Grower Account. You can now send the 30% advance payment.',
      time: '10 minutes ago',
      category: 'Bids',
      iconData: Icons.check_circle_outline_rounded,
      iconBgColor: const Color(0xFFE3EFE6),
      isRead: false,
      targetRoute: 'payments',
    ),
    VendorNotificationItem(
      id: 'vn_002',
      title: 'Payment Confirmation Sent',
      description:
          'Payment of PKR 54,600 (30% Advance) for Kinnow Block A was processed successfully. Ref: TXN-948201.',
      time: '1 hour ago',
      category: 'Payments',
      iconData: Icons.account_balance_wallet_outlined,
      iconBgColor: const Color(0xFFFFF3E0),
      isRead: false,
      targetRoute: 'payments',
    ),
    VendorNotificationItem(
      id: 'vn_003',
      title: 'New AI-Scanned Orchard Listed',
      description:
          'Mandarin North in Bhalwal was listed. Asking PKR 320,000 (~2,010 fruits). Place your bid now.',
      time: '3 hours ago',
      category: 'Listings',
      iconData: Icons.storefront_outlined,
      iconBgColor: const Color(0xFFE3EFE6),
      isRead: true,
      targetRoute: 'dashboard',
    ),
    VendorNotificationItem(
      id: 'vn_004',
      title: 'Bid Status Update',
      description:
          'Your bid of PKR 140,000 for Block C Mixed was rejected by the grower.',
      time: 'Yesterday',
      category: 'Bids',
      iconData: Icons.cancel_outlined,
      iconBgColor: const Color(0xFFFFE5E5),
      isRead: true,
      targetRoute: 'bids',
    ),
    VendorNotificationItem(
      id: 'vn_005',
      title: 'Order Status Changed',
      description:
          'Order #ord_002 for Block C Mixed has been marked as Completed.',
      time: '2 days ago',
      category: 'Orders',
      iconData: Icons.inventory_2_outlined,
      iconBgColor: const Color(0xFFE3EFE6),
      isRead: true,
      targetRoute: 'orders',
    ),
    VendorNotificationItem(
      id: 'vn_006',
      title: 'Verified Vendor Welcome',
      description:
          'Your commercial trader account (Al-Noor Traders) is fully verified. Enjoy priority bidding.',
      time: '3 days ago',
      category: 'System',
      iconData: Icons.verified_outlined,
      iconBgColor: const Color(0xFFFFF8E1),
      isRead: true,
    ),
  ];

  int get _unreadCount => _notifications.where((n) => !n.isRead).length;

  void _markAllAsRead() {
    setState(() {
      for (var item in _notifications) {
        item.isRead = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All vendor notifications marked as read.'),
        backgroundColor: AppColors.darkGreen,
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
          'Are you sure you want to clear all vendor notifications?',
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

  void _handleNotificationTap(VendorNotificationItem notification) {
    setState(() {
      notification.isRead = true;
    });

    if (notification.targetRoute == 'payments') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const VendorPaymentsScreen(),
        ),
      );
    } else if (notification.targetRoute == 'orders') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const VendorOrdersScreen(),
        ),
      );
    } else if (notification.targetRoute == 'dashboard') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const VendorDashboardScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;

    final filteredList = _notifications.where((n) {
      if (_selectedCategory == 'All') return true;
      return n.category == _selectedCategory;
    }).toList();

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
                        onTap: () {
                          if (Navigator.of(context).canPop()) {
                            Navigator.of(context).pop();
                          } else {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => const VendorDashboardScreen(),
                              ),
                            );
                          }
                        },
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
                      Row(
                        children: [
                          if (_unreadCount > 0)
                            TextButton(
                              onPressed: _markAllAsRead,
                              child: Text(
                                'Mark all as read',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.secondaryGreen,
                                ),
                              ),
                            ),
                          if (_notifications.isNotEmpty)
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
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Text(
                        'Notifications',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkGreen,
                        ),
                      ),
                      if (_unreadCount > 0) ...[
                        SizedBox(width: 10.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF99A20),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            '$_unreadCount new',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Vendor alerts for bids, payments, orders & market listings.',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),

            // ==========================================
            // 2. CATEGORY FILTER CHIPS
            // ==========================================
            SizedBox(
              height: 42.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                itemCount: _categories.length,
                separatorBuilder: (ctx, idx) => SizedBox(width: 8.w),
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = cat == _selectedCategory;

                  return InkWell(
                    onTap: () => setState(() => _selectedCategory = cat),
                    borderRadius: BorderRadius.circular(14.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isSelected ? AppColors.darkGreen : Colors.white,
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.darkGreen
                              : AppColors.cardBorder,
                          width: 1.w,
                        ),
                      ),
                      child: Text(
                        cat,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : AppColors.secondaryText,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 16.h),

            // ==========================================
            // 3. NOTIFICATIONS LIST
            // ==========================================
            Expanded(
              child: filteredList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.notifications_off_outlined,
                            size: 52.r,
                            color: AppColors.secondaryText.withValues(alpha: 0.5),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            'No ${_selectedCategory.toLowerCase()} notifications',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.only(
                        left: 20.w,
                        right: 20.w,
                        bottom: 24.h,
                      ),
                      itemCount: filteredList.length,
                      separatorBuilder: (ctx, idx) => SizedBox(height: 12.h),
                      itemBuilder: (context, index) {
                        final item = filteredList[index];

                        return InkWell(
                          onTap: () => _handleNotificationTap(item),
                          borderRadius: BorderRadius.circular(18.r),
                          child: Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: item.isRead
                                  ? Colors.white
                                  : const Color(0xFFFAF8F0),
                              borderRadius: BorderRadius.circular(18.r),
                              border: Border.all(
                                color: item.isRead
                                    ? AppColors.cardBorder
                                    : AppColors.secondaryGreen.withValues(alpha: 0.5),
                                width: item.isRead ? 1.w : 1.5.w,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.03),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 44.r,
                                  width: 44.r,
                                  decoration: BoxDecoration(
                                    color: item.iconBgColor,
                                    borderRadius: BorderRadius.circular(14.r),
                                  ),
                                  child: Icon(
                                    item.iconData,
                                    size: 22.r,
                                    color: AppColors.darkGreen,
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              item.title,
                                              style: TextStyle(
                                                fontSize: 15.sp,
                                                fontWeight: item.isRead
                                                    ? FontWeight.w600
                                                    : FontWeight.bold,
                                                color: AppColors.primaryText,
                                              ),
                                            ),
                                          ),
                                          if (!item.isRead)
                                            Container(
                                              height: 8.r,
                                              width: 8.r,
                                              margin: EdgeInsets.only(
                                                  left: 6.w),
                                              decoration: const BoxDecoration(
                                                color: Color(0xFFF99A20),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                        ],
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        item.description,
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          color: AppColors.secondaryText,
                                          height: 1.35,
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                      Text(
                                        item.time,
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          color: AppColors.secondaryText,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),

        bottomNavigationBar: const VendorBottomNavigation(selectedIndex: 0),
      ),
    );
  }
}
