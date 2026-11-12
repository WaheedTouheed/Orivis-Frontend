import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/listing_state_service.dart';
import '../widgets/vendor_bottom_navigation.dart';
import 'vendor_dashboard_screen.dart';
import 'vendor_payments_screen.dart';

class VendorBidsHistoryScreen extends StatefulWidget {
  const VendorBidsHistoryScreen({super.key});

  @override
  State<VendorBidsHistoryScreen> createState() =>
      _VendorBidsHistoryScreenState();
}

class _VendorBidsHistoryScreenState extends State<VendorBidsHistoryScreen> {
  String _selectedFilter = 'All';

  final List<String> _filters = ['All', 'Pending', 'Accepted', 'Rejected'];

  String _formatAmount(double amount) {
    final regex = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return amount.toStringAsFixed(0).replaceAllMapped(
          regex,
          (match) => '${match[1]},',
        );
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inHours < 24 && dt.day == now.day) {
      return 'Today';
    } else if (diff.inDays <= 1) {
      return 'Yesterday';
    } else {
      return '${diff.inDays} days ago';
    }
  }

  String _statusLabel(VendorBidStatus status) {
    switch (status) {
      case VendorBidStatus.pending:
        return 'Pending';
      case VendorBidStatus.accepted:
        return 'Accepted';
      case VendorBidStatus.rejected:
        return 'Rejected';
    }
  }

  Color _statusBg(VendorBidStatus status) {
    switch (status) {
      case VendorBidStatus.pending:
        return const Color(0xFFFFF3E0);
      case VendorBidStatus.accepted:
        return const Color(0xFFE3EFE6);
      case VendorBidStatus.rejected:
        return const Color(0xFFFFE5E5);
    }
  }

  Color _statusTextColor(VendorBidStatus status) {
    switch (status) {
      case VendorBidStatus.pending:
        return const Color(0xFFF99A20);
      case VendorBidStatus.accepted:
        return AppColors.darkGreen;
      case VendorBidStatus.rejected:
        return const Color(0xFFD92D20);
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;

    return AnimatedBuilder(
      animation: ListingStateService(),
      builder: (context, _) {
        final allBids = ListingStateService().vendorBids;
        final filteredBids = allBids.where((b) {
          if (_selectedFilter == 'Pending') {
            return b.status == VendorBidStatus.pending;
          } else if (_selectedFilter == 'Accepted') {
            return b.status == VendorBidStatus.accepted;
          } else if (_selectedFilter == 'Rejected') {
            return b.status == VendorBidStatus.rejected;
          }
          return true;
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
                // Header
                Container(
                  padding: EdgeInsets.only(
                    top: topPadding > 0 ? topPadding + 8.h : 16.h,
                    left: 20.w,
                    right: 20.w,
                    bottom: 16.h,
                  ),
                  color: AppColors.warmCream,
                  child: Row(
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
                                color: AppColors.cardBorder, width: 1.w),
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 18.r,
                            color: AppColors.darkGreen,
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Text(
                        'Bids History',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkGreen,
                        ),
                      ),
                    ],
                  ),
                ),

                // Horizontal Filter Chips
                SizedBox(
                  height: 42.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    itemCount: _filters.length,
                    separatorBuilder: (ctx, idx) => SizedBox(width: 8.w),
                    itemBuilder: (context, index) {
                      final filter = _filters[index];
                      final isSelected = filter == _selectedFilter;

                      return InkWell(
                        onTap: () => setState(() => _selectedFilter = filter),
                        borderRadius: BorderRadius.circular(14.r),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.darkGreen
                                : Colors.white,
                            borderRadius: BorderRadius.circular(14.r),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.darkGreen
                                  : AppColors.cardBorder,
                              width: 1.w,
                            ),
                          ),
                          child: Text(
                            filter,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
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

                Expanded(
                  child: filteredBids.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.local_offer_outlined,
                                size: 52.r,
                                color: AppColors.secondaryText.withValues(alpha: 0.5),
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                'No ${_selectedFilter.toLowerCase()} bids found.',
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
                          itemCount: filteredBids.length,
                          separatorBuilder: (ctx, idx) => SizedBox(height: 12.h),
                          itemBuilder: (context, index) {
                            final bid = filteredBids[index];

                            return Container(
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(
                                    color: AppColors.cardBorder, width: 1.w),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.04),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              bid.orchardName,
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primaryText,
                                              ),
                                            ),
                                            SizedBox(height: 4.h),
                                            Text(
                                              'Placed ${_formatDate(bid.placedAt)}',
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                color: AppColors.secondaryText,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12.w, vertical: 6.h),
                                        decoration: BoxDecoration(
                                          color: _statusBg(bid.status),
                                          borderRadius:
                                              BorderRadius.circular(12.r),
                                        ),
                                        child: Text(
                                          _statusLabel(bid.status),
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.bold,
                                            color: _statusTextColor(bid.status),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 12.h),
                                  const Divider(
                                      color: AppColors.cardBorder, height: 1),
                                  SizedBox(height: 12.h),

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Offered Bid Amount',
                                            style: TextStyle(
                                              fontSize: 11.sp,
                                              color: AppColors.secondaryText,
                                            ),
                                          ),
                                          SizedBox(height: 2.h),
                                          Text(
                                            'PKR ${_formatAmount(bid.bidAmount)}',
                                            style: TextStyle(
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.darkGreen,
                                            ),
                                          ),
                                        ],
                                      ),

                                      if (bid.status == VendorBidStatus.accepted)
                                        ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.darkGreen,
                                            foregroundColor: Colors.white,
                                            elevation: 0,
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 14.w,
                                              vertical: 8.h,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    const VendorPaymentsScreen(),
                                              ),
                                            );
                                          },
                                          icon: Icon(
                                            Icons.payments_outlined,
                                            size: 16.r,
                                          ),
                                          label: Text(
                                            'Send Payment',
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),

            bottomNavigationBar: const VendorBottomNavigation(selectedIndex: 3),
          ),
        );
      },
    );
  }
}
