import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/listing_state_service.dart';
import '../../../home/presentation/screens/notifications_screen.dart';
import 'vendor_bid_screen.dart';
import 'vendor_bids_history_screen.dart';
import 'vendor_payments_screen.dart';
import '../widgets/vendor_bottom_navigation.dart';

class VendorDashboardScreen extends StatefulWidget {
  const VendorDashboardScreen({super.key});

  @override
  State<VendorDashboardScreen> createState() => _VendorDashboardScreenState();
}

class _VendorDashboardScreenState extends State<VendorDashboardScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final List<String> _categories = ['All', 'Mostly ripe', 'High yield', 'Newest'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showDemoMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.darkGreen,
        duration: const Duration(seconds: 2),
      ),
    );
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

  List<ListingModel> _filteredListings(List<ListingModel> all) {
    List<ListingModel> result = all
        .where((l) => l.listingStatus == ListingStatus.open)
        .toList();

    // Search filter
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result
          .where((l) =>
              l.orchardName.toLowerCase().contains(q) ||
              l.location.toLowerCase().contains(q))
          .toList();
    }

    // Category filter
    switch (_selectedCategory) {
      case 'Mostly ripe':
        result = result.where((l) => l.ripenessPercentage >= 60).toList();
        break;
      case 'High yield':
        result = result
          ..sort((a, b) => b.estimatedFruitCount.compareTo(a.estimatedFruitCount));
        break;
      case 'Newest':
        result = result
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      default:
        break;
    }

    return result;
  }

  void _showFilterBottomSheet() {
    String? tempVariety;
    String? tempLocation;
    double minPrice = 0;
    double maxPrice = 500000;
    bool aiOnly = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            top: 20.h,
            bottom: MediaQuery.paddingOf(ctx).bottom + 20.h,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: AppColors.cardBorder,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filter listings',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setModalState(() {
                          tempVariety = null;
                          tempLocation = null;
                          minPrice = 0;
                          maxPrice = 500000;
                          aiOnly = false;
                        });
                      },
                      child: Text(
                        'Clear filters',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.secondaryGreen,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                // Fruit variety
                Text(
                  'Fruit variety',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryText,
                  ),
                ),
                SizedBox(height: 8.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: ['Kinnow', 'Mandarin', 'Mixed citrus', 'Orange']
                      .map((v) => ChoiceChip(
                            label: Text(v,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: tempVariety == v
                                      ? AppColors.darkGreen
                                      : AppColors.secondaryText,
                                )),
                            selected: tempVariety == v,
                            selectedColor: const Color(0xFFE3EFE6),
                            backgroundColor: Colors.white,
                            side: BorderSide(
                              color: tempVariety == v
                                  ? AppColors.darkGreen
                                  : AppColors.cardBorder,
                            ),
                            onSelected: (sel) {
                              setModalState(() {
                                tempVariety = sel ? v : null;
                              });
                            },
                          ))
                      .toList(),
                ),
                SizedBox(height: 16.h),

                // Location
                Text(
                  'Location',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryText,
                  ),
                ),
                SizedBox(height: 8.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: ['Sargodha', 'Bhalwal', 'Lahore', 'Multan']
                      .map((loc) => ChoiceChip(
                            label: Text(loc,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: tempLocation == loc
                                      ? AppColors.darkGreen
                                      : AppColors.secondaryText,
                                )),
                            selected: tempLocation == loc,
                            selectedColor: const Color(0xFFE3EFE6),
                            backgroundColor: Colors.white,
                            side: BorderSide(
                              color: tempLocation == loc
                                  ? AppColors.darkGreen
                                  : AppColors.cardBorder,
                            ),
                            onSelected: (sel) {
                              setModalState(() {
                                tempLocation = sel ? loc : null;
                              });
                            },
                          ))
                      .toList(),
                ),
                SizedBox(height: 16.h),

                // Price range
                Text(
                  'Price range (PKR)',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryText,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'PKR ${_formatAmount(minPrice)} – PKR ${_formatAmount(maxPrice)}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.secondaryText,
                  ),
                ),
                RangeSlider(
                  values: RangeValues(minPrice, maxPrice),
                  min: 0,
                  max: 500000,
                  divisions: 50,
                  activeColor: AppColors.darkGreen,
                  inactiveColor: AppColors.cardBorder,
                  onChanged: (values) {
                    setModalState(() {
                      minPrice = values.start;
                      maxPrice = values.end;
                    });
                  },
                ),
                SizedBox(height: 8.h),

                // AI scanned only
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'AI-scanned listings only',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryText,
                        ),
                      ),
                    ),
                    Switch(
                      value: aiOnly,
                      activeThumbColor: AppColors.darkGreen,
                      onChanged: (val) {
                        setModalState(() => aiOnly = val);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20.h),

                // Apply button
                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      _showDemoMessage('Filters applied locally.');
                    },
                    child: Text(
                      'Apply filters',
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
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;

    return AnimatedBuilder(
      animation: ListingStateService(),
      builder: (context, _) {
        final service = ListingStateService();
        final allListings = service.listings;
        final filtered = _filteredListings(allListings);
        final pendingBids = service.pendingBidCount;
        final acceptedBids = service.acceptedBidCount;
        final openListings = service.openListingCount;
        final recentBids = service.vendorBids.take(5).toList();

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
          child: Scaffold(
            backgroundColor: AppColors.warmCream,
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ==========================================
                        // HEADER + BIDDING ACTIVITY CARD
                        // ==========================================
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // Green Header
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.only(
                                top: topPadding > 0 ? topPadding + 14.h : 20.h,
                                left: 20.w,
                                right: 20.w,
                                bottom: 68.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.darkGreen,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(28.r),
                                  bottomRight: Radius.circular(28.r),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Orange Avatar
                                  Container(
                                    height: 50.r,
                                    width: 50.r,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFF99A20),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        'AN',
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 14.w),
                                  // Greeting + Name
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Assalam-o-Alaikum',
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w400,
                                            color: const Color(0xFFDCE9E0),
                                          ),
                                        ),
                                        SizedBox(height: 2.h),
                                        Text(
                                          'Al-Noor Traders',
                                          style: TextStyle(
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Notification Bell
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => const NotificationsScreen(),
                                        ),
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(16.r),
                                    child: Container(
                                      height: 44.r,
                                      width: 44.r,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(16.r),
                                      ),
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Icon(
                                            Icons.notifications_none_outlined,
                                            size: 22.r,
                                            color: Colors.white,
                                          ),
                                          Positioned(
                                            top: 8.r,
                                            right: 8.r,
                                            child: Container(
                                              height: 15.r,
                                              width: 15.r,
                                              decoration: const BoxDecoration(
                                                color: Color(0xFFF99A20),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '1',
                                                  style: TextStyle(
                                                    fontSize: 9.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Bidding Activity Card (overlapping)
                            Positioned(
                              left: 20.w,
                              right: 20.w,
                              bottom: -44.h,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                  vertical: 16.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.r),
                                  border: Border.all(
                                    color: AppColors.cardBorder,
                                    width: 1.w,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.07),
                                      blurRadius: 14,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Your bidding activity',
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.secondaryText,
                                      ),
                                    ),
                                    SizedBox(height: 12.h),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        _buildBidStat(
                                          value: pendingBids.toString(),
                                          label: 'Pending bids',
                                        ),
                                        _buildVerticalDivider(),
                                        _buildBidStat(
                                          value: acceptedBids.toString(),
                                          label: 'Accepted',
                                        ),
                                        _buildVerticalDivider(),
                                        _buildBidStat(
                                          value: openListings.toString(),
                                          label: 'Open listings',
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 60.h), // space for the overlapping card

                        // Quick Payment Shortcut Banner
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const VendorPaymentsScreen(),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(16.r),
                            child: Container(
                              padding: EdgeInsets.all(14.w),
                              decoration: BoxDecoration(
                                color: AppColors.darkGreen,
                                borderRadius: BorderRadius.circular(16.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.darkGreen.withValues(alpha: 0.25),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: 42.r,
                                    width: 42.r,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: Icon(
                                      Icons.account_balance_wallet_rounded,
                                      color: const Color(0xFFF99A20),
                                      size: 22.r,
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Send Payments for Confirmed Bids',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: 2.h),
                                        Text(
                                          'Pay by percentage stage via Card or Account',
                                          style: TextStyle(
                                            fontSize: 11.sp,
                                            color: Colors.white.withValues(alpha: 0.8),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.white,
                                    size: 16.r,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 20.h),

                        // ==========================================
                        // SEARCH + FILTER
                        // ==========================================
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 48.h,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14.r),
                                    border: Border.all(
                                      color: AppColors.cardBorder,
                                      width: 1.w,
                                    ),
                                  ),
                                  child: TextField(
                                    controller: _searchController,
                                    onChanged: (val) {
                                      setState(() => _searchQuery = val);
                                    },
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppColors.primaryText,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Search by orchard or location',
                                      hintStyle: TextStyle(
                                        fontSize: 14.sp,
                                        color: AppColors.placeholderColor,
                                      ),
                                      prefixIcon: Icon(
                                        Icons.search_rounded,
                                        size: 20.r,
                                        color: AppColors.secondaryText,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 14.w,
                                        vertical: 14.h,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              InkWell(
                                onTap: _showFilterBottomSheet,
                                borderRadius: BorderRadius.circular(14.r),
                                child: Container(
                                  height: 48.h,
                                  width: 48.h,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14.r),
                                    border: Border.all(
                                      color: AppColors.cardBorder,
                                      width: 1.w,
                                    ),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.tune_rounded,
                                      size: 20.r,
                                      color: AppColors.primaryText,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 14.h),

                        // ==========================================
                        // HORIZONTAL CATEGORY CHIPS
                        // ==========================================
                        SizedBox(
                          height: 40.h,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            itemCount: _categories.length,
                            separatorBuilder: (_, idx) => SizedBox(width: 10.w),
                            itemBuilder: (context, index) {
                              final cat = _categories[index];
                              final isSelected = _selectedCategory == cat;
                              return GestureDetector(
                                onTap: () {
                                  setState(() => _selectedCategory = cat);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 8.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFFFFF3E0)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(10.r),
                                    border: Border.all(
                                      color: isSelected
                                          ? const Color(0xFFF99A20)
                                          : const Color(0xFFE6E0D2),
                                      width: isSelected ? 1.5.w : 1.w,
                                    ),
                                  ),
                                  child: Text(
                                    cat,
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                      color: isSelected
                                          ? const Color(0xFFF99A20)
                                          : AppColors.primaryText,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        SizedBox(height: 20.h),

                        // ==========================================
                        // AVAILABLE PRODUCE SECTION
                        // ==========================================
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Text(
                            'Available produce',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkGreen,
                            ),
                          ),
                        ),

                        SizedBox(height: 12.h),

                        if (filtered.isEmpty)
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 32.h,
                            ),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.search_off_rounded,
                                    size: 48.r,
                                    color: AppColors.secondaryText,
                                  ),
                                  SizedBox(height: 12.h),
                                  Text(
                                    'No listings match your search.',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppColors.secondaryText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Column(
                              children: filtered
                                  .map((listing) => Padding(
                                        padding: EdgeInsets.only(bottom: 14.h),
                                        child: _buildProduceCard(listing),
                                      ))
                                  .toList(),
                            ),
                          ),

                        SizedBox(height: 8.h),

                        // ==========================================
                        // YOUR RECENT BIDS
                        // ==========================================
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Your recent bids',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkGreen,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const VendorBidsHistoryScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'See all',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.secondaryGreen,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 8.h),

                        if (recentBids.isEmpty)
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Text(
                              'No bids yet. Tap Bid on any listing to get started.',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: AppColors.secondaryText,
                              ),
                            ),
                          )
                        else
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Column(
                              children: recentBids
                                  .map((bid) => Padding(
                                        padding: EdgeInsets.only(bottom: 10.h),
                                        child: _buildRecentBidCard(bid),
                                      ))
                                  .toList(),
                            ),
                          ),

                        SizedBox(height: 16.h),

                        // Disclaimer
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32.w),
                          child: Text(
                            'Listings and figures are sample data. The bid form uses a PKR 150,000 minimum.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: AppColors.secondaryText,
                              height: 1.5,
                            ),
                          ),
                        ),

                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // ==========================================
            // BOTTOM NAVIGATION BAR
            // ==========================================
            bottomNavigationBar: const VendorBottomNavigation(selectedIndex: 0),
          ),
        );
      },
    );
  }

  // ============================================================
  // PRODUCE CARD
  // ============================================================
  Widget _buildProduceCard(ListingModel listing) {
    return Container(
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
          // Top Row: Icon + Info + Badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Green fruit icon
              Container(
                height: 56.r,
                width: 56.r,
                decoration: BoxDecoration(
                  color: AppColors.darkGreen,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Center(
                  child: Icon(
                    Icons.circle,
                    size: 24.r,
                    color: const Color(0xFFF99A20),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            listing.orchardName,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryText,
                            ),
                          ),
                        ),
                        if (listing.isAiScanned) ...[
                          SizedBox(width: 6.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 3.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE3EFE6),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              'AI-scanned',
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.secondaryGreen,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 13.r,
                          color: AppColors.secondaryText,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          '${listing.location} · ~${_formatCount(listing.estimatedFruitCount)} fruits (AI estimate)',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 14.h),

          // Ripeness Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: listing.ripenessPercentage / 100,
              minHeight: 8.h,
              backgroundColor: AppColors.cardBorder,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFF99A20)),
            ),
          ),

          SizedBox(height: 6.h),

          Text(
            'Ripe ${listing.ripenessPercentage.toInt()}% · Visibly healthy ${listing.healthyPercentage.toInt()}%',
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.secondaryText,
            ),
          ),

          SizedBox(height: 14.h),

          // Divider
          Divider(color: AppColors.cardBorder, height: 1.h),

          SizedBox(height: 12.h),

          // Price Row + Bid Button
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Asking',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.secondaryText,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'PKR ${_formatAmount(listing.askingPrice)}',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Min bid',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.secondaryText,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'PKR ${_formatAmount(listing.minimumBid)}',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => VendorBidScreen(listing: listing),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(14.r),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 22.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF99A20),
                    borderRadius: BorderRadius.circular(14.r),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFF99A20).withValues(alpha: 0.35),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    'Bid',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryText,
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

  // ============================================================
  // RECENT BID CARD
  // ============================================================
  Widget _buildRecentBidCard(VendorBidRecord bid) {
    Color statusBg;
    Color statusText;
    String statusLabel;

    switch (bid.status) {
      case VendorBidStatus.pending:
        statusBg = const Color(0xFFFFF3E0);
        statusText = const Color(0xFFF99A20);
        statusLabel = 'Pending';
        break;
      case VendorBidStatus.accepted:
        statusBg = const Color(0xFFE3EFE6);
        statusText = AppColors.darkGreen;
        statusLabel = 'Accepted';
        break;
      case VendorBidStatus.rejected:
        statusBg = const Color(0xFFFFE5E5);
        statusText = const Color(0xFFD92D20);
        statusLabel = 'Rejected';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.cardBorder, width: 1.w),
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: statusBg,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              statusLabel,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: statusText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STAT WIDGET
  // ============================================================
  Widget _buildBidStat({required String value, required String label}) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 26.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.darkGreen,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            color: AppColors.secondaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 32.h,
      width: 1.w,
      color: AppColors.cardBorder,
    );
  }

}

