import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/listing_state_service.dart';
import '../widgets/vendor_bottom_navigation.dart';

class VendorBidsHistoryScreen extends StatefulWidget {
  const VendorBidsHistoryScreen({super.key});

  @override
  State<VendorBidsHistoryScreen> createState() =>
      _VendorBidsHistoryScreenState();
}

class _VendorBidsHistoryScreenState extends State<VendorBidsHistoryScreen> {

  String _formatAmount(double amount) {
    final regex = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return amount.toStringAsFixed(0).replaceAllMapped(
          regex,
          (match) => '${match[1]},',
        );
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
        final bids = ListingStateService().vendorBids;

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
                        onTap: () => Navigator.of(context).pop(),
                        borderRadius: BorderRadius.circular(12.r),
                        child: Container(
                          height: 40.r,
                          width: 40.r,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            border:
                                Border.all(color: AppColors.cardBorder, width: 1.w),
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
                        'All bids',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkGreen,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: bids.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.local_offer_outlined,
                                size: 48.r,
                                color: AppColors.secondaryText,
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                'No bids placed yet.',
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: AppColors.secondaryText,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 8.h,
                          ),
                          itemCount: bids.length,
                          separatorBuilder: (_, idx) => SizedBox(height: 10.h),
                          itemBuilder: (context, index) {
                            final bid = bids[index];
                            return Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.w, vertical: 14.h),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.r),
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
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          bid.orchardName,
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primaryText,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          'PKR ${_formatAmount(bid.bidAmount)}',
                                          style: TextStyle(
                                            fontSize: 13.sp,
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
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    child: Text(
                                      _statusLabel(bid.status),
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        color: _statusTextColor(bid.status),
                                      ),
                                    ),
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
