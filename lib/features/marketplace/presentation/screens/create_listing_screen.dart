import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../home/presentation/screens/grower_dashboard_screen.dart';
import '../../../home/presentation/screens/profile_screen.dart';
import '../../../marketplace/presentation/screens/received_bids_screen.dart';
import '../../../scan/presentation/screens/scan_orchard_screen.dart';

class CreateListingScreen extends StatefulWidget {
  final String orchardName;
  final String estimatedFruits;
  final String dominantStage;

  const CreateListingScreen({
    super.key,
    this.orchardName = 'Kinnow Block A',
    this.estimatedFruits = '1,248',
    this.dominantStage = 'Ripe 52%',
  });

  @override
  State<CreateListingScreen> createState() => _CreateListingScreenState();
}

class _CreateListingScreenState extends State<CreateListingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _varietyController = TextEditingController(text: 'Kinnow');
  final _askingPriceController = TextEditingController();
  final _minBidController = TextEditingController();
  final _notesController = TextEditingController();

  bool _openForBids = true;
  int _selectedBottomIndex = 0;

  @override
  void dispose() {
    _varietyController.dispose();
    _askingPriceController.dispose();
    _minBidController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _showDemoMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.darkGreen,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _handlePublishListing() {
    if (!_formKey.currentState!.validate()) return;

    _showDemoMessage(
      'Demo mode: Your listing has been prepared locally. It has not been published to a marketplace.',
    );

    // Return to Grower Dashboard
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => const GrowerDashboardScreen(),
          ),
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;

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
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(
                  top: topPadding > 0 ? topPadding + 8.h : 16.h,
                  left: 20.w,
                  right: 20.w,
                  bottom: 28.h,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ==========================================
                      // 1. HEADER ROW
                      // ==========================================
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
                            'Create listing',
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkGreen,
                            ),
                          ),
                          SizedBox(width: 40.r), // Spacer for title centering
                        ],
                      ),

                      SizedBox(height: 20.h),

                      // ==========================================
                      // 2. ORCHARD SUMMARY CARD
                      // ==========================================
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
                            // Green Thumbnail Box
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
                                  size: 20.r,
                                  color: const Color(0xFFF99A20),
                                ),
                              ),
                            ),

                            SizedBox(width: 14.w),

                            // Details Column
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.orchardName,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryText,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    '~${widget.estimatedFruits} fruits (AI estimate) · ${widget.dominantStage}',
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

                      SizedBox(height: 20.h),

                      // ==========================================
                      // 3. FIELD 1 — TREE VARIETY
                      // ==========================================
                      Text(
                        'Tree variety',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryText,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      TextFormField(
                        controller: _varietyController,
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: AppColors.primaryText,
                        ),
                        decoration: _buildInputDecoration(
                          hintText: 'Enter tree variety',
                        ),
                      ),

                      SizedBox(height: 18.h),

                      // ==========================================
                      // 4. FIELD 2 — ASKING PRICE (PKR) *
                      // ==========================================
                      _buildFieldLabel('Asking price (PKR)', isRequired: true),
                      SizedBox(height: 8.h),
                      TextFormField(
                        controller: _askingPriceController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: AppColors.primaryText,
                        ),
                        decoration: _buildInputDecoration(
                          hintText: 'e.g. 200000',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter asking price.';
                          }
                          final parsed = int.tryParse(value.trim());
                          if (parsed == null || parsed <= 0) {
                            return 'Please enter a valid asking price.';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 18.h),

                      // ==========================================
                      // 5. FIELD 3 — MINIMUM BID (PKR) *
                      // ==========================================
                      _buildFieldLabel('Minimum bid (PKR)', isRequired: true),
                      SizedBox(height: 8.h),
                      TextFormField(
                        controller: _minBidController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: AppColors.primaryText,
                        ),
                        decoration: _buildInputDecoration(
                          hintText: 'e.g. 150000',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter minimum bid.';
                          }
                          final parsedMin = int.tryParse(value.trim());
                          if (parsedMin == null || parsedMin <= 0) {
                            return 'Please enter a valid minimum bid.';
                          }
                          final askingText = _askingPriceController.text.trim();
                          if (askingText.isNotEmpty) {
                            final parsedAsking = int.tryParse(askingText);
                            if (parsedAsking != null && parsedMin > parsedAsking) {
                              return 'Minimum bid cannot exceed asking price.';
                            }
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 18.h),

                      // ==========================================
                      // 6. FIELD 4 — NOTES FOR BUYERS
                      // ==========================================
                      Text(
                        'Notes for buyers',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryText,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      TextFormField(
                        controller: _notesController,
                        maxLines: 3,
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: AppColors.primaryText,
                        ),
                        decoration: _buildInputDecoration(
                          hintText: 'Harvest timing, access, etc.',
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // ==========================================
                      // 7. OPEN FOR BIDS TOGGLE CARD
                      // ==========================================
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: AppColors.cardBorder,
                            width: 1.w,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Open for bids',
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryText,
                              ),
                            ),
                            Switch(
                              value: _openForBids,
                              activeTrackColor: AppColors.darkGreen,
                              onChanged: (val) {
                                setState(() {
                                  _openForBids = val;
                                });
                              },
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 8.h),

                      Text(
                        'Vendors see the AI estimate and scan summary. You can pause or close the listing later.',
                        style: TextStyle(
                          fontSize: 12.sp,
                          height: 1.35,
                          color: AppColors.secondaryText,
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // ==========================================
                      // 8. PUBLISH LISTING BUTTON
                      // ==========================================
                      SizedBox(
                        width: double.infinity,
                        height: 52.h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF99A20), // Orange
                            foregroundColor: AppColors.primaryText,
                            elevation: 2,
                            shadowColor:
                                const Color(0xFFF99A20).withValues(alpha: 0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                          ),
                          onPressed: _handlePublishListing,
                          child: Text(
                            'Publish listing',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryText,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        // ==========================================
        // 9. PERSISTENT BOTTOM NAVIGATION BAR
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

  Widget _buildFieldLabel(String labelText, {required bool isRequired}) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: labelText,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryText,
            ),
          ),
          if (isRequired)
            TextSpan(
              text: ' *',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.errorRed,
              ),
            ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration({required String hintText}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        fontSize: 15.sp,
        color: AppColors.placeholderColor,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 14.h,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: BorderSide(
          color: AppColors.cardBorder,
          width: 1.w,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: BorderSide(
          color: AppColors.cardBorder,
          width: 1.w,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: BorderSide(
          color: AppColors.secondaryGreen,
          width: 1.5.w,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: BorderSide(
          color: AppColors.errorRed,
          width: 1.w,
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
