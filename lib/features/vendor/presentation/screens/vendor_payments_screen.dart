import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/listing_state_service.dart';
import '../../../../core/services/payments_state_service.dart';
import '../widgets/vendor_bottom_navigation.dart';
import 'vendor_dashboard_screen.dart';

class VendorPaymentsScreen extends StatefulWidget {
  const VendorPaymentsScreen({super.key});

  @override
  State<VendorPaymentsScreen> createState() => _VendorPaymentsScreenState();
}

class _VendorPaymentsScreenState extends State<VendorPaymentsScreen> {
  int _selectedTab = 0; // 0: Confirmed Bids (Payments), 1: Transaction History

  String _formatAmount(double amount) {
    final regex = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return amount.toStringAsFixed(0).replaceAllMapped(
          regex,
          (match) => '${match[1]},',
        );
  }

  void _openCheckoutSheet({
    required BuildContext context,
    required ConfirmedBidPaymentModel schedule,
    required String defaultStageName,
    required double defaultPercentage,
    required double defaultAmount,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _VendorCheckoutModal(
        schedule: schedule,
        defaultStageName: defaultStageName,
        defaultPercentage: defaultPercentage,
        defaultAmount: defaultAmount,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;

    return AnimatedBuilder(
      animation: PaymentsStateService(),
      builder: (context, child) {
        final schedules = PaymentsStateService().schedules;
        final confirmedSchedules = PaymentsStateService().confirmedBids;
        final unconfirmedSchedules =
            schedules.where((s) => s.bidStatus != VendorBidStatus.accepted).toList();
        final transactions = PaymentsStateService().transactions;

        final double totalContractValue = confirmedSchedules.fold(
          0.0,
          (sum, item) => sum + item.totalAmount,
        );
        final double totalPaidAmount = confirmedSchedules.fold(
          0.0,
          (sum, item) => sum + item.paidAmount,
        );
        final double overallPercentage = totalContractValue > 0
            ? ((totalPaidAmount / totalContractValue) * 100).clamp(0.0, 100.0)
            : 0.0;

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
                        'Vendor Payments',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkGreen,
                        ),
                      ),
                      SizedBox(width: 40.r), // Spacer
                    ],
                  ),
                ),

                // ==========================================
                // 2. SEGMENTED TAB SELECTOR (Payments vs History)
                // ==========================================
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: AppColors.cardBorder,
                        width: 1.w,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => setState(() => _selectedTab = 0),
                            borderRadius: BorderRadius.circular(12.r),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              decoration: BoxDecoration(
                                color: _selectedTab == 0
                                    ? AppColors.darkGreen
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Center(
                                child: Text(
                                  'Payments & Bids',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.bold,
                                    color: _selectedTab == 0
                                        ? Colors.white
                                        : AppColors.secondaryText,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () => setState(() => _selectedTab = 1),
                            borderRadius: BorderRadius.circular(12.r),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              decoration: BoxDecoration(
                                color: _selectedTab == 1
                                    ? AppColors.darkGreen
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Center(
                                child: Text(
                                  'Transaction Log (${transactions.length})',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.bold,
                                    color: _selectedTab == 1
                                        ? Colors.white
                                        : AppColors.secondaryText,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 16.h),

                // ==========================================
                // 3. MAIN CONTENT BODY
                // ==========================================
                Expanded(
                  child: _selectedTab == 0
                      ? ListView(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.only(
                            left: 20.w,
                            right: 20.w,
                            bottom: 24.h,
                          ),
                          children: [
                            // Overall Payment Summary Card
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
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Overall Payment Progress',
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.secondaryText,
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10.w,
                                          vertical: 4.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFE3EFE6),
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                        ),
                                        child: Text(
                                          '${overallPercentage.toStringAsFixed(0)}% Paid',
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
                                  Text(
                                    'PKR ${_formatAmount(totalPaidAmount)} / PKR ${_formatAmount(totalContractValue)}',
                                    style: TextStyle(
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.darkGreen,
                                    ),
                                  ),
                                  SizedBox(height: 12.h),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(6.r),
                                    child: LinearProgressIndicator(
                                      value: overallPercentage / 100,
                                      minHeight: 10.h,
                                      backgroundColor: AppColors.cardBorder,
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                        Color(0xFFF99A20),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  Text(
                                    'Payments are enabled strictly for confirmed & accepted grower bids via Credit/Debit Card or Bank Account.',
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      color: AppColors.secondaryText,
                                      height: 1.35,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 24.h),

                            // Section Title: Confirmed Bids (Payable)
                            Row(
                              children: [
                                Icon(
                                  Icons.check_circle_outline_rounded,
                                  color: AppColors.darkGreen,
                                  size: 20.r,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'Confirmed Bids (Payment Enabled)',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.darkGreen,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 12.h),

                            if (confirmedSchedules.isEmpty)
                              Container(
                                padding: EdgeInsets.all(20.w),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.r),
                                  border: Border.all(
                                    color: AppColors.cardBorder,
                                    width: 1.w,
                                  ),
                                ),
                                child: Text(
                                  'No confirmed bids available for payment.',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: AppColors.secondaryText,
                                  ),
                                ),
                              )
                            else
                              ...confirmedSchedules.map((schedule) {
                                return _buildConfirmedPaymentCard(
                                    context, schedule);
                              }),

                            SizedBox(height: 24.h),

                            // Section Title: Unconfirmed / Pending Bids (Payment Locked)
                            Row(
                              children: [
                                Icon(
                                  Icons.lock_outline_rounded,
                                  color: const Color(0xFFC2410C),
                                  size: 20.r,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'Pending Bids (Payment Locked)',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryText,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 12.h),

                            if (unconfirmedSchedules.isEmpty)
                              Container(
                                padding: EdgeInsets.all(16.w),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.r),
                                  border: Border.all(
                                    color: AppColors.cardBorder,
                                    width: 1.w,
                                  ),
                                ),
                                child: Text(
                                  'No pending unconfirmed bids.',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: AppColors.secondaryText,
                                  ),
                                ),
                              )
                            else
                              ...unconfirmedSchedules.map((schedule) {
                                return _buildUnconfirmedPaymentCard(
                                    context, schedule);
                              }),
                          ],
                        )
                      : ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 8.h,
                          ),
                          itemCount: transactions.length,
                          separatorBuilder: (ctx, idx) => SizedBox(height: 12.h),
                          itemBuilder: (context, index) {
                            final txn = transactions[index];
                            return Container(
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18.r),
                                border: Border.all(
                                  color: AppColors.cardBorder,
                                  width: 1.w,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: 44.r,
                                    width: 44.r,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE3EFE6),
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: Icon(
                                      txn.methodType == PaymentMethodType.card
                                          ? Icons.credit_card_rounded
                                          : Icons.account_balance_rounded,
                                      color: AppColors.darkGreen,
                                      size: 22.r,
                                    ),
                                  ),
                                  SizedBox(width: 14.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          txn.orchardName,
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primaryText,
                                          ),
                                        ),
                                        SizedBox(height: 2.h),
                                        Text(
                                          '${txn.stageName} · ${txn.accountOrCardMask}',
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: AppColors.secondaryText,
                                          ),
                                        ),
                                        SizedBox(height: 2.h),
                                        Text(
                                          'Ref: ${txn.id}',
                                          style: TextStyle(
                                            fontSize: 11.sp,
                                            color: AppColors.secondaryText,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'PKR ${_formatAmount(txn.amount)}',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.darkGreen,
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.w,
                                          vertical: 2.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFD4EDDA),
                                          borderRadius:
                                              BorderRadius.circular(6.r),
                                        ),
                                        child: Text(
                                          'Success',
                                          style: TextStyle(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFF155724),
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

            // ==========================================
            // 4. FIXED VENDOR BOTTOM NAVIGATION BAR
            // ==========================================
            bottomNavigationBar: const VendorBottomNavigation(selectedIndex: 1),
          ),
        );
      },
    );
  }

  // ============================================================
  // CONFIRMED PAYMENT CARD (Percentage Milestones)
  // ============================================================
  Widget _buildConfirmedPaymentCard(
    BuildContext context,
    ConfirmedBidPaymentModel schedule,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.cardBorder, width: 1.w),
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
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      schedule.orchardName,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Grower: ${schedule.growerName}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3EFE6),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      size: 14.r,
                      color: AppColors.darkGreen,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'Confirmed Bid',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // Total & Progress
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Agreed Bid Amount',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.secondaryText,
                ),
              ),
              Text(
                'PKR ${_formatAmount(schedule.totalAmount)}',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGreen,
                ),
              ),
            ],
          ),

          SizedBox(height: 8.h),

          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: schedule.paidPercentage / 100,
              minHeight: 8.h,
              backgroundColor: AppColors.cardBorder,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFF99A20)),
            ),
          ),

          SizedBox(height: 6.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${schedule.paidPercentage.toStringAsFixed(0)}% Paid (PKR ${_formatAmount(schedule.paidAmount)})',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondaryText,
                ),
              ),
              Text(
                'Remaining: PKR ${_formatAmount(schedule.remainingAmount)}',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: schedule.remainingAmount > 0
                      ? const Color(0xFFC2410C)
                      : AppColors.darkGreen,
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),
          const Divider(color: AppColors.cardBorder, height: 1),
          SizedBox(height: 14.h),

          Text(
            'Payment Percentage Stages',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.darkGreen,
            ),
          ),

          SizedBox(height: 10.h),

          // Stage 1: Advance (30%)
          _buildStageRow(
            context: context,
            schedule: schedule,
            stageTitle: '1. Advance (30%)',
            percentage: 30,
            amount: schedule.advanceAmount,
            isPaid: schedule.isAdvancePaid,
          ),

          SizedBox(height: 10.h),

          // Stage 2: Harvest (40%)
          _buildStageRow(
            context: context,
            schedule: schedule,
            stageTitle: '2. Harvest (40%)',
            percentage: 40,
            amount: schedule.harvestAmount,
            isPaid: schedule.isHarvestPaid,
          ),

          SizedBox(height: 10.h),

          // Stage 3: Final (30%)
          _buildStageRow(
            context: context,
            schedule: schedule,
            stageTitle: '3. Final (30%)',
            percentage: 30,
            amount: schedule.finalAmount,
            isPaid: schedule.isFinalPaid,
          ),

          SizedBox(height: 14.h),

          // Custom Percentage Payment Button
          if (schedule.remainingAmount > 0)
            SizedBox(
              width: double.infinity,
              height: 40.h,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.darkGreen, width: 1.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                onPressed: () {
                  _openCheckoutSheet(
                    context: context,
                    schedule: schedule,
                    defaultStageName: 'Custom Percentage',
                    defaultPercentage: 20,
                    defaultAmount: schedule.totalAmount * 0.20,
                  );
                },
                icon: Icon(
                  Icons.tune_rounded,
                  size: 16.r,
                  color: AppColors.darkGreen,
                ),
                label: Text(
                  'Pay Custom Percentage',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkGreen,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStageRow({
    required BuildContext context,
    required ConfirmedBidPaymentModel schedule,
    required String stageTitle,
    required double percentage,
    required double amount,
    required bool isPaid,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: isPaid ? const Color(0xFFF4F8F5) : const Color(0xFFFAF7F0),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isPaid ? const Color(0xFFC8E6C9) : AppColors.cardBorder,
          width: 1.w,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                stageTitle,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'PKR ${_formatAmount(amount)}',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondaryText,
                ),
              ),
            ],
          ),
          if (isPaid)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: const Color(0xFFD4EDDA),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_rounded,
                    size: 14.r,
                    color: const Color(0xFF155724),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'Paid',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF155724),
                    ),
                  ),
                ],
              ),
            )
          else
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF99A20),
                foregroundColor: AppColors.primaryText,
                elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              onPressed: () {
                _openCheckoutSheet(
                  context: context,
                  schedule: schedule,
                  defaultStageName: stageTitle,
                  defaultPercentage: percentage,
                  defaultAmount: amount,
                );
              },
              child: Text(
                'Pay Now',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ============================================================
  // UNCONFIRMED PAYMENT CARD (Locked)
  // ============================================================
  Widget _buildUnconfirmedPaymentCard(
    BuildContext context,
    ConfirmedBidPaymentModel schedule,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.cardBorder, width: 1.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  schedule.orchardName,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.lock_clock_outlined,
                      size: 13.r,
                      color: const Color(0xFFF99A20),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'Pending Confirmation',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFF99A20),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 8.h),
          Text(
            'Bid Amount: PKR ${_formatAmount(schedule.totalAmount)}',
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.secondaryText,
            ),
          ),

          SizedBox(height: 12.h),

          // Disabled Warning Banner
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: const Color(0xFFFFE082),
                width: 1.w,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 16.r,
                  color: const Color(0xFFF57F17),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'Payments can only be sent for confirmed bids accepted by the grower.',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: const Color(0xFF5D4037),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// VENDOR CHECKOUT MODAL (Percentage + Card / Account Payment)
// ============================================================

class _VendorCheckoutModal extends StatefulWidget {
  final ConfirmedBidPaymentModel schedule;
  final String defaultStageName;
  final double defaultPercentage;
  final double defaultAmount;

  const _VendorCheckoutModal({
    required this.schedule,
    required this.defaultStageName,
    required this.defaultPercentage,
    required this.defaultAmount,
  });

  @override
  State<_VendorCheckoutModal> createState() => _VendorCheckoutModalState();
}

class _VendorCheckoutModalState extends State<_VendorCheckoutModal> {
  late double _selectedPercentage;
  late double _calculatedAmount;
  PaymentMethodType _selectedMethod = PaymentMethodType.card;

  // Card Form Controllers
  final _cardNameController =
      TextEditingController(text: 'Al-Noor Traders');
  final _cardNumberController =
      TextEditingController(text: '4242 4242 4242 4821');
  final _cardExpiryController = TextEditingController(text: '12/26');
  final _cardCvvController = TextEditingController(text: '882');

  // Bank Form Controllers
  String _selectedBank = 'Meezan Bank';
  final _accountTitleController =
      TextEditingController(text: 'Al-Noor Traders Account');
  final _accountNumberController =
      TextEditingController(text: 'PK36MEZN00019283746501');

  bool _isProcessing = false;

  final List<String> _bankOptions = [
    'Meezan Bank',
    'HBL - Habib Bank Ltd',
    'Allied Bank',
    'Bank Alfalah',
    'EasyPaisa',
    'JazzCash',
  ];

  @override
  void initState() {
    super.initState();
    _selectedPercentage = widget.defaultPercentage;
    _calculatedAmount = widget.defaultAmount;
  }

  @override
  void dispose() {
    _cardNameController.dispose();
    _cardNumberController.dispose();
    _cardExpiryController.dispose();
    _cardCvvController.dispose();
    _accountTitleController.dispose();
    _accountNumberController.dispose();
    super.dispose();
  }

  void _updatePercentage(double percent) {
    setState(() {
      _selectedPercentage = percent;
      _calculatedAmount = widget.schedule.totalAmount * (percent / 100);
    });
  }

  String _formatAmount(double amount) {
    final regex = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return amount.toStringAsFixed(0).replaceAllMapped(
          regex,
          (match) => '${match[1]},',
        );
  }

  void _processPayment() async {
    setState(() => _isProcessing = true);

    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;

    final mask = _selectedMethod == PaymentMethodType.card
        ? 'Visa **** ${_cardNumberController.text.length >= 4 ? _cardNumberController.text.substring(_cardNumberController.text.length - 4) : "4821"}'
        : '$_selectedBank **** ${_accountNumberController.text.length >= 4 ? _accountNumberController.text.substring(_accountNumberController.text.length - 4) : "9012"}';

    PaymentsStateService().recordPayment(
      scheduleId: widget.schedule.id,
      stageName:
          '${widget.defaultStageName} (${_selectedPercentage.toStringAsFixed(0)}%)',
      percentage: _selectedPercentage,
      amount: _calculatedAmount,
      methodType: _selectedMethod,
      accountOrCardMask: mask,
    );

    setState(() => _isProcessing = false);
    Navigator.of(context).pop();

    _showSuccessDialog(mask);
  }

  void _showSuccessDialog(String mask) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(
              Icons.check_circle_rounded,
              color: AppColors.darkGreen,
              size: 24.r,
            ),
            SizedBox(width: 8.w),
            Text(
              'Payment Successful!',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGreen,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment of PKR ${_formatAmount(_calculatedAmount)} (${_selectedPercentage.toStringAsFixed(0)}%) for ${widget.schedule.orchardName} was processed successfully.',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.secondaryText,
                height: 1.4,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'Method: $mask',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryText,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Status: Confirmed by Banking Gateway',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.darkGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.darkGreen,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 20.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28.r),
          topRight: Radius.circular(28.r),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle Bar
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                margin: EdgeInsets.only(bottom: 16.h),
                decoration: BoxDecoration(
                  color: AppColors.cardBorder,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),

            Text(
              'Send Payment',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGreen,
              ),
            ),

            SizedBox(height: 4.h),

            Text(
              'Confirmed Bid: ${widget.schedule.orchardName}',
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.secondaryText,
              ),
            ),

            SizedBox(height: 16.h),
            const Divider(color: AppColors.cardBorder),
            SizedBox(height: 14.h),

            // Select Percentage Options
            Text(
              'Select Payment Percentage',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),

            SizedBox(height: 10.h),

            Row(
              children: [30, 40, 50, 100].map((percent) {
                final double p = percent.toDouble();
                final isSelected = _selectedPercentage == p;
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 3.w),
                    child: InkWell(
                      onTap: () => _updatePercentage(p),
                      borderRadius: BorderRadius.circular(10.r),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.darkGreen
                              : const Color(0xFFF8F6EE),
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.darkGreen
                                : AppColors.cardBorder,
                            width: 1.w,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '$percent%',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.primaryText,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            SizedBox(height: 14.h),

            // Amount summary display
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: const Color(0xFFE3EFE6),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Payable (${_selectedPercentage.toStringAsFixed(0)}%)',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkGreen,
                    ),
                  ),
                  Text(
                    'PKR ${_formatAmount(_calculatedAmount)}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGreen,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            // Payment Method Switcher (Card vs Account)
            Text(
              'Select Payment Method',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),

            SizedBox(height: 10.h),

            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () =>
                        setState(() => _selectedMethod = PaymentMethodType.card),
                    borderRadius: BorderRadius.circular(12.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      decoration: BoxDecoration(
                        color: _selectedMethod == PaymentMethodType.card
                            ? const Color(0xFFFFF3E0)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: _selectedMethod == PaymentMethodType.card
                              ? const Color(0xFFF99A20)
                              : AppColors.cardBorder,
                          width: 1.5.w,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.credit_card_rounded,
                            size: 18.r,
                            color: _selectedMethod == PaymentMethodType.card
                                ? const Color(0xFFF99A20)
                                : AppColors.secondaryText,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'Card',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                              color: _selectedMethod == PaymentMethodType.card
                                  ? const Color(0xFFF99A20)
                                  : AppColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: InkWell(
                    onTap: () => setState(
                        () => _selectedMethod = PaymentMethodType.account),
                    borderRadius: BorderRadius.circular(12.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      decoration: BoxDecoration(
                        color: _selectedMethod == PaymentMethodType.account
                            ? const Color(0xFFFFF3E0)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: _selectedMethod == PaymentMethodType.account
                              ? const Color(0xFFF99A20)
                              : AppColors.cardBorder,
                          width: 1.5.w,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.account_balance_rounded,
                            size: 18.r,
                            color: _selectedMethod == PaymentMethodType.account
                                ? const Color(0xFFF99A20)
                                : AppColors.secondaryText,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'Account / IBAN',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                              color: _selectedMethod == PaymentMethodType.account
                                  ? const Color(0xFFF99A20)
                                  : AppColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            // CARD FORM vs ACCOUNT FORM
            if (_selectedMethod == PaymentMethodType.card) ...[
              TextField(
                controller: _cardNameController,
                decoration: InputDecoration(
                  labelText: 'Cardholder Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 10.h,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              TextField(
                controller: _cardNumberController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Card Number',
                  prefixIcon: Icon(Icons.credit_card, size: 20.r),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 10.h,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _cardExpiryController,
                      decoration: InputDecoration(
                        labelText: 'Expiry (MM/YY)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 10.h,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: TextField(
                      controller: _cardCvvController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'CVV',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 10.h,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ] else ...[
              DropdownButtonFormField<String>(
                initialValue: _selectedBank,
                decoration: InputDecoration(
                  labelText: 'Select Bank / Mobile Wallet',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 10.h,
                  ),
                ),
                items: _bankOptions.map((bank) {
                  return DropdownMenuItem(
                    value: bank,
                    child: Text(bank, style: TextStyle(fontSize: 13.sp)),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedBank = val);
                },
              ),
              SizedBox(height: 10.h),
              TextField(
                controller: _accountTitleController,
                decoration: InputDecoration(
                  labelText: 'Account Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 10.h,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              TextField(
                controller: _accountNumberController,
                decoration: InputDecoration(
                  labelText: 'Account / IBAN Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 10.h,
                  ),
                ),
              ),
            ],

            SizedBox(height: 20.h),

            // Submit Button
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
                onPressed: _isProcessing ? null : _processPayment,
                child: _isProcessing
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 20.r,
                            width: 20.r,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            'Processing...',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        'Send PKR ${_formatAmount(_calculatedAmount)} Payment',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
