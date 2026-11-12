import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/bids_state_service.dart';
import '../../../../core/services/listing_state_service.dart';

class VendorBidScreen extends StatefulWidget {
  final ListingModel listing;

  const VendorBidScreen({super.key, required this.listing});

  @override
  State<VendorBidScreen> createState() => _VendorBidScreenState();
}

class _VendorBidScreenState extends State<VendorBidScreen> {
  final _formKey = GlobalKey<FormState>();
  final _bidController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _bidController.dispose();
    super.dispose();
  }

  String _formatAmount(double amount) {
    final regex = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return amount.toStringAsFixed(0).replaceAllMapped(
          regex,
          (match) => '${match[1]},',
        );
  }

  String _formatCount(int count) {
    final regex = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return count.toString().replaceAllMapped(regex, (match) => '${match[1]},');
  }

  Future<void> _handleSubmitBid() async {
    if (!_formKey.currentState!.validate()) return;

    final bidAmount = double.tryParse(_bidController.text.trim()) ?? 0;

    // Confirm dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        backgroundColor: Colors.white,
        title: Text(
          'Confirm Bid',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.darkGreen,
          ),
        ),
        content: Text(
          'Submit a bid of PKR ${_formatAmount(bidAmount)} for ${widget.listing.orchardName}?\n\nThis is a local demo bid and is not a real marketplace transaction.',
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.secondaryText,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.secondaryText,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF99A20),
              foregroundColor: AppColors.primaryText,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
              elevation: 0,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              'Yes, submit',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isSubmitting = true);

    // Add bid to shared state
    final bid = VendorBidRecord(
      id: 'vbid_${DateTime.now().millisecondsSinceEpoch}',
      listingId: widget.listing.id,
      orchardName: widget.listing.orchardName,
      bidAmount: bidAmount,
      status: VendorBidStatus.pending,
      placedAt: DateTime.now(),
    );

    ListingStateService().addVendorBid(bid);
    BidsStateService().addBid(
      BidItem(
        id: bid.id,
        companyName: 'Al-Noor Traders',
        initials: 'AT',
        quantity: '${(widget.listing.estimatedFruitCount / 300).toStringAsFixed(1)} tons',
        amount: bidAmount,
        status: 'Pending',
      ),
    );

    await Future.delayed(const Duration(milliseconds: 400));

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Bid of PKR ${_formatAmount(bidAmount)} placed for ${widget.listing.orchardName}.',
        ),
        backgroundColor: AppColors.darkGreen,
        duration: const Duration(seconds: 3),
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;
    final listing = widget.listing;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.warmCream,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(
            top: topPadding > 0 ? topPadding + 8.h : 16.h,
            left: 20.w,
            right: 20.w,
            bottom: 32.h,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
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
                          border: Border.all(color: AppColors.cardBorder, width: 1.w),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 18.r,
                          color: AppColors.darkGreen,
                        ),
                      ),
                    ),
                    Text(
                      'Place a bid',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkGreen,
                      ),
                    ),
                    SizedBox(width: 40.r),
                  ],
                ),

                SizedBox(height: 20.h),

                // Listing summary card
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: AppColors.cardBorder, width: 1.w),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 52.r,
                            width: 52.r,
                            decoration: BoxDecoration(
                              color: AppColors.darkGreen,
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.circle,
                                size: 22.r,
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
                                  listing.orchardName,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryText,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  '${listing.location} · ${listing.fruitVariety}',
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
                      SizedBox(height: 14.h),
                      Divider(color: AppColors.cardBorder, height: 1.h),
                      SizedBox(height: 14.h),
                      _buildDetailRow(
                        'Estimated fruits',
                        '~${_formatCount(listing.estimatedFruitCount)} fruits (AI estimate)',
                      ),
                      SizedBox(height: 8.h),
                      _buildDetailRow(
                        'Fruit variety',
                        listing.fruitVariety,
                      ),
                      SizedBox(height: 8.h),
                      _buildDetailRow(
                        'Asking price',
                        'PKR ${_formatAmount(listing.askingPrice)}',
                      ),
                      SizedBox(height: 8.h),
                      _buildDetailRow(
                        'Minimum bid',
                        'PKR ${_formatAmount(listing.minimumBid)}',
                        highlight: true,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24.h),

                // Bid amount field
                Text(
                  'Your bid amount (PKR) *',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryText,
                  ),
                ),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: _bidController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: TextStyle(fontSize: 15.sp, color: AppColors.primaryText),
                  decoration: InputDecoration(
                    hintText: 'e.g. ${listing.minimumBid.toInt()}',
                    hintStyle: TextStyle(
                      fontSize: 15.sp,
                      color: const Color(0xFF929A92),
                    ),
                    prefixText: 'PKR  ',
                    prefixStyle: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryText,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide(color: AppColors.cardBorder, width: 1.w),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide(color: AppColors.cardBorder, width: 1.w),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide:
                          BorderSide(color: AppColors.secondaryGreen, width: 1.5.w),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide(color: AppColors.errorRed, width: 1.w),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide(color: AppColors.errorRed, width: 1.w),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your bid amount.';
                    }
                    final parsed = double.tryParse(value.trim());
                    if (parsed == null || parsed <= 0) {
                      return 'Please enter a valid amount.';
                    }
                    if (parsed < listing.minimumBid) {
                      return 'Bid must be at least PKR ${_formatAmount(listing.minimumBid)}.';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 8.h),

                Text(
                  'Minimum bid for this listing: PKR ${_formatAmount(listing.minimumBid)}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.secondaryText,
                  ),
                ),

                SizedBox(height: 10.h),

                // Quick Bid Presets Row
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: [
                    ActionChip(
                      backgroundColor: const Color(0xFFE3EFE6),
                      side: const BorderSide(color: AppColors.darkGreen),
                      label: Text(
                        'Min: PKR ${_formatAmount(listing.minimumBid)}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkGreen,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _bidController.text = listing.minimumBid.toInt().toString();
                        });
                      },
                    ),
                    ActionChip(
                      backgroundColor: const Color(0xFFFFF3E0),
                      side: const BorderSide(color: Color(0xFFF99A20)),
                      label: Text(
                        'Asking: PKR ${_formatAmount(listing.askingPrice)}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFC2410C),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _bidController.text = listing.askingPrice.toInt().toString();
                        });
                      },
                    ),
                    ActionChip(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: AppColors.cardBorder),
                      label: Text(
                        '+ PKR 10,000',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryText,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          final current = double.tryParse(_bidController.text) ?? listing.minimumBid;
                          _bidController.text = (current + 10000).toInt().toString();
                        });
                      },
                    ),
                  ],
                ),

                SizedBox(height: 28.h),

                // Submit button
                SizedBox(
                  width: double.infinity,
                  height: 52.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF99A20),
                      foregroundColor: AppColors.primaryText,
                      elevation: 2,
                      shadowColor: const Color(0xFFF99A20).withValues(alpha: 0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                    onPressed: _isSubmitting ? null : _handleSubmitBid,
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            'Submit bid',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryText,
                            ),
                          ),
                  ),
                ),

                SizedBox(height: 14.h),

                Text(
                  'This is a local demo bid. No real transaction occurs.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool highlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            color: AppColors.secondaryText,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: highlight ? FontWeight.bold : FontWeight.w500,
            color: highlight ? const Color(0xFFF99A20) : AppColors.primaryText,
          ),
        ),
      ],
    );
  }
}
