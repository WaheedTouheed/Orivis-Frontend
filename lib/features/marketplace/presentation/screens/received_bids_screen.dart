import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/bids_state_service.dart';
import '../../../../core/services/listing_state_service.dart';
import '../../../../core/services/notifications_state_service.dart';
import '../../../../core/services/orders_state_service.dart';
import '../../../../core/services/payments_state_service.dart';
import '../../../home/presentation/screens/grower_dashboard_screen.dart';
import '../../../home/presentation/screens/profile_screen.dart';
import '../../../scan/presentation/screens/scan_orchard_screen.dart';
import '../../../scan/presentation/screens/scan_history_screen.dart';

class ReceivedBidsScreen extends StatefulWidget {
  const ReceivedBidsScreen({super.key});

  @override
  State<ReceivedBidsScreen> createState() => _ReceivedBidsScreenState();
}

class _ReceivedBidsScreenState extends State<ReceivedBidsScreen> {
  int _selectedBottomIndex = 3; // Bids tab is selected

  String _formatAmount(double amount) {
    final regex = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return amount.toStringAsFixed(0).replaceAllMapped(
          regex,
          (match) => '${match[1]},',
        );
  }

  void _showConfirmationDialog({
    required BidItem bid,
    required bool isAccept,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        backgroundColor: Colors.white,
        title: Text(
          isAccept ? 'Accept Bid?' : 'Reject Bid?',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.darkGreen,
          ),
        ),
        content: Text(
          isAccept
              ? 'Are you sure you want to accept the bid of PKR ${_formatAmount(bid.amount)} from ${bid.companyName}?'
              : 'Are you sure you want to reject the bid from ${bid.companyName}?',
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
              backgroundColor: isAccept ? AppColors.darkGreen : AppColors.errorRed,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              if (isAccept) {
                OrdersStateService().reflectAcceptedBid(
                  bidId: bid.id,
                  orchardName: 'Kinnow Block A',
                  amount: bid.amount,
                  quantity: bid.quantity,
                  growerName: 'Grower account',
                );
                PaymentsStateService().syncAcceptedBid(
                  orchardName: 'Kinnow Block A',
                  totalAmount: bid.amount,
                  growerName: 'Grower account',
                );
                ListingStateService().updateVendorBidStatus(
                  bid.id,
                  VendorBidStatus.accepted,
                );
                NotificationsStateService().addNotification(
                  NotificationItem(
                    id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
                    title: 'Bid Accepted!',
                    description:
                        'You accepted ${bid.companyName}\'s bid of PKR ${_formatAmount(bid.amount)} for Kinnow Block A.',
                    time: 'Just now',
                    category: 'Bids',
                    iconData: Icons.check_circle_outline,
                    isRead: false,
                  ),
                );
              } else {
                ListingStateService().updateVendorBidStatus(
                  bid.id,
                  VendorBidStatus.rejected,
                );
                NotificationsStateService().addNotification(
                  NotificationItem(
                    id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
                    title: 'Bid Rejected',
                    description:
                        'You rejected ${bid.companyName}\'s bid for Kinnow Block A.',
                    time: 'Just now',
                    category: 'Bids',
                    iconData: Icons.cancel_outlined,
                    isRead: false,
                  ),
                );
              }
              BidsStateService().removeBid(bid.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isAccept
                        ? 'Bid from ${bid.companyName} accepted successfully.'
                        : 'Bid from ${bid.companyName} rejected.',
                  ),
                  backgroundColor:
                      isAccept ? AppColors.darkGreen : AppColors.errorRed,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: Text(
              isAccept ? 'Accept' : 'Reject',
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

  void _showDemoMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;

    return AnimatedBuilder(
      animation: BidsStateService(),
      builder: (context, child) {
        final bids = BidsStateService().bids;

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
                        'Received bids',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkGreen,
                        ),
                      ),
                      SizedBox(width: 40.r), // Spacer for title centering
                    ],
                  ),
                ),

                // ==========================================
                // 2. SCROLLABLE CONTENT (Orchard Summary + Bid Cards)
                // ==========================================
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                    children: [
                      // Orchard Summary Card
                      Container(
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
                            Container(
                              height: 42.r,
                              width: 42.r,
                              decoration: BoxDecoration(
                                color: AppColors.darkGreen,
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.circle,
                                  size: 18.r,
                                  color: const Color(0xFFF99A20),
                                ),
                              ),
                            ),
                            SizedBox(width: 14.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Kinnow Block A',
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primaryText,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    'Asking PKR 200,000 · ${bids.length} ${bids.length == 1 ? "bid" : "bids"}',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: AppColors.secondaryText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 16.h),

                      // Bid Cards
                      if (bids.isEmpty)
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 40.h,
                            horizontal: 20.w,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: AppColors.cardBorder,
                              width: 1.w,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.local_offer_outlined,
                                size: 48.r,
                                color: AppColors.secondaryText
                                    .withValues(alpha: 0.5),
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                'No pending bids',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryText,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'All bids have been actioned.',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: AppColors.secondaryText,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        ...bids.map((bid) => _buildBidCard(bid)),

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

  Widget _buildBidCard(BidItem bid) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: Company Initials + Name & Quantity + Status Badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 44.r,
                width: 44.r,
                decoration: BoxDecoration(
                  color: AppColors.darkGreen,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Center(
                  child: Text(
                    bid.initials,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bid.companyName,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryText,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      bid.quantity,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(bid.status),
            ],
          ),

          SizedBox(height: 16.h),

          // Middle row: Bid Amount and Highest Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'PKR ${_formatAmount(bid.amount)}',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGreen,
                ),
              ),
              if (bid.isHighest)
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEDD5), // light orange
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    'Highest',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFC2410C),
                    ),
                  ),
                ),
            ],
          ),

          SizedBox(height: 16.h),

          // Bottom buttons: Reject and Accept
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 44.h,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.errorRed,
                      side: BorderSide(
                        color: AppColors.errorRed,
                        width: 1.5.w,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                    onPressed: () =>
                        _showConfirmationDialog(bid: bid, isAccept: false),
                    child: Text(
                      'Reject',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.errorRed,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: SizedBox(
                  height: 44.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkGreen,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shadowColor: AppColors.darkGreen.withValues(alpha: 0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                    onPressed: () =>
                        _showConfirmationDialog(bid: bid, isAccept: true),
                    child: Text(
                      'Accept',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;
    if (status == 'Accepted') {
      bgColor = const Color(0xFFE3EFE6);
      textColor = AppColors.darkGreen;
    } else if (status == 'Rejected') {
      bgColor = const Color(0xFFFEE2E2);
      textColor = AppColors.errorRed;
    } else {
      bgColor = const Color(0xFFFFEDD5); // soft pale orange
      textColor = const Color(0xFFC2410C);
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
          color: textColor,
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
          setState(() => _selectedBottomIndex = index);
        } else if (index == 4) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const ProfileScreen(),
            ),
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
