import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/orders_state_service.dart';
import '../widgets/vendor_bottom_navigation.dart';
import 'vendor_dashboard_screen.dart';

class VendorOrdersScreen extends StatefulWidget {
  const VendorOrdersScreen({super.key});

  @override
  State<VendorOrdersScreen> createState() => _VendorOrdersScreenState();
}

class _VendorOrdersScreenState extends State<VendorOrdersScreen> {
  String _selectedFilter = 'All';

  final List<String> _filters = ['All', 'Active', 'Completed', 'Cancelled'];

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
    } else if (diff.inDays < 7) {
      return '${diff.inDays} days ago';
    } else {
      return 'Last week';
    }
  }

  void _showOrderDetails(BuildContext context, OrderModel order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28.r),
            topRight: Radius.circular(28.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                margin: EdgeInsets.only(bottom: 20.h),
                decoration: BoxDecoration(
                  color: AppColors.cardBorder,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),

            // Top Header: Title & Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    order.orchardName,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGreen,
                    ),
                  ),
                ),
                _buildStatusBadge(order.status),
              ],
            ),
            SizedBox(height: 6.h),
            Text(
              'Order ID: ${order.id}',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.secondaryText,
              ),
            ),

            SizedBox(height: 20.h),
            const Divider(color: AppColors.cardBorder),
            SizedBox(height: 16.h),

            // Details Grid / List
            _buildDetailRow(
              icon: Icons.person_outline_rounded,
              label: 'Grower Information',
              value: order.growerName,
            ),
            SizedBox(height: 14.h),
            _buildDetailRow(
              icon: Icons.scale_outlined,
              label: 'Quantity',
              value: order.quantity,
            ),
            SizedBox(height: 14.h),
            _buildDetailRow(
              icon: Icons.payments_outlined,
              label: 'Accepted Bid Amount',
              value: 'PKR ${_formatAmount(order.amount)}',
              valueColor: AppColors.darkGreen,
              isBold: true,
            ),
            SizedBox(height: 14.h),
            _buildDetailRow(
              icon: Icons.calendar_today_outlined,
              label: 'Order Date',
              value: _formatDate(order.date),
            ),
            if (order.location != null) ...[
              SizedBox(height: 14.h),
              _buildDetailRow(
                icon: Icons.location_on_outlined,
                label: 'Location',
                value: order.location!,
              ),
            ],
            if (order.notes != null) ...[
              SizedBox(height: 14.h),
              _buildDetailRow(
                icon: Icons.notes_outlined,
                label: 'Notes',
                value: order.notes!,
              ),
            ],

            SizedBox(height: 24.h),

            // Demo notice banner
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: const Color(0xFFFFE082),
                  width: 1.w,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: const Color(0xFFF57F17),
                    size: 20.r,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      'Frontend prototype demonstration using local dummy data. No real transaction, payment, or delivery occurred.',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: const Color(0xFF5D4037),
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            // Close button
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  elevation: 0,
                ),
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(
                  'Close',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
    bool isBold = false,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20.r, color: AppColors.secondaryText),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.secondaryText,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: valueColor ?? AppColors.primaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(OrderStatus status) {
    Color bgColor;
    Color textColor;
    String label;

    switch (status) {
      case OrderStatus.active:
        bgColor = const Color(0xFFE3EFE6);
        textColor = AppColors.darkGreen;
        label = 'Active';
        break;
      case OrderStatus.completed:
        bgColor = const Color(0xFFD4EDDA);
        textColor = const Color(0xFF155724);
        label = 'Completed';
        break;
      case OrderStatus.cancelled:
        bgColor = const Color(0xFFFFE5E5);
        textColor = const Color(0xFFD92D20);
        label = 'Cancelled';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;

    return AnimatedBuilder(
      animation: OrdersStateService(),
      builder: (context, child) {
        final allOrders = OrdersStateService().orders;
        final filteredOrders = allOrders.where((order) {
          if (_selectedFilter == 'Active') {
            return order.status == OrderStatus.active;
          } else if (_selectedFilter == 'Completed') {
            return order.status == OrderStatus.completed;
          } else if (_selectedFilter == 'Cancelled') {
            return order.status == OrderStatus.cancelled;
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
                  decoration: const BoxDecoration(
                    color: AppColors.warmCream,
                  ),
                  child: Row(
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
                            size: 20.r,
                            color: AppColors.darkGreen,
                          ),
                        ),
                      ),
                      Text(
                        'My Orders',
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
                // 2. HORIZONTAL FILTER CHIPS
                // ==========================================
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

                // ==========================================
                // 3. ORDERS LIST
                // ==========================================
                Expanded(
                  child: filteredOrders.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.inventory_2_outlined,
                                size: 56.r,
                                color: AppColors.secondaryText.withValues(alpha: 0.5),
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                'No ${_selectedFilter.toLowerCase()} orders',
                                style: TextStyle(
                                  fontSize: 16.sp,
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
                          itemCount: filteredOrders.length,
                          separatorBuilder: (ctx, idx) => SizedBox(height: 14.h),
                          itemBuilder: (context, index) {
                            final order = filteredOrders[index];

                            return Container(
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
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Card Top Row: Icon + Names + Badge
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 46.r,
                                        width: 46.r,
                                        decoration: BoxDecoration(
                                          color: AppColors.darkGreen,
                                          borderRadius:
                                              BorderRadius.circular(14.r),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.inventory_2_outlined,
                                            size: 22.r,
                                            color: const Color(0xFFF99A20),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              order.orchardName,
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primaryText,
                                              ),
                                            ),
                                            SizedBox(height: 2.h),
                                            Text(
                                              'Grower: ${order.growerName}',
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                color: AppColors.secondaryText,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      _buildStatusBadge(order.status),
                                    ],
                                  ),

                                  SizedBox(height: 14.h),
                                  const Divider(
                                      color: AppColors.cardBorder, height: 1),
                                  SizedBox(height: 12.h),

                                  // Card Middle Details: Amount, Quantity, Date
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Agreed Amount',
                                            style: TextStyle(
                                              fontSize: 11.sp,
                                              color: AppColors.secondaryText,
                                            ),
                                          ),
                                          SizedBox(height: 2.h),
                                          Text(
                                            'PKR ${_formatAmount(order.amount)}',
                                            style: TextStyle(
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.darkGreen,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Quantity',
                                            style: TextStyle(
                                              fontSize: 11.sp,
                                              color: AppColors.secondaryText,
                                            ),
                                          ),
                                          SizedBox(height: 2.h),
                                          Text(
                                            order.quantity,
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.primaryText,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Date',
                                            style: TextStyle(
                                              fontSize: 11.sp,
                                              color: AppColors.secondaryText,
                                            ),
                                          ),
                                          SizedBox(height: 2.h),
                                          Text(
                                            _formatDate(order.date),
                                            style: TextStyle(
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.secondaryText,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 14.h),

                                  // View Details Action Button
                                  InkWell(
                                    onTap: () => _showOrderDetails(
                                        context, order),
                                    borderRadius: BorderRadius.circular(12.r),
                                    child: Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10.h),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE3EFE6),
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'View Details',
                                            style: TextStyle(
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.darkGreen,
                                            ),
                                          ),
                                          SizedBox(width: 4.w),
                                          Icon(
                                            Icons.chevron_right_rounded,
                                            size: 18.r,
                                            color: AppColors.darkGreen,
                                          ),
                                        ],
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

            // ==========================================
            // 4. FIXED VENDOR BOTTOM NAVIGATION BAR
            // ==========================================
            bottomNavigationBar: const VendorBottomNavigation(selectedIndex: 2),
          ),
        );
      },
    );
  }
}
