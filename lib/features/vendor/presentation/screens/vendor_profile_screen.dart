import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/screens/welcome_role_screen.dart';
import '../widgets/vendor_bottom_navigation.dart';
import 'vendor_bids_history_screen.dart';
import 'vendor_business_otp_screen.dart';
import 'vendor_change_password_screen.dart';
import 'vendor_edit_business_details_screen.dart';
import 'vendor_orders_screen.dart';
import 'vendor_payments_screen.dart';

class VendorProfileScreen extends StatefulWidget {
  const VendorProfileScreen({super.key});

  @override
  State<VendorProfileScreen> createState() => _VendorProfileScreenState();
}

class _VendorProfileScreenState extends State<VendorProfileScreen> {
  String _vendorName = 'Al-Noor Traders';
  String _email = 'alnoor.traders@orivis.pk';
  String _phone = '+92 300 9876543';
  String _location = 'Sargodha & Bhalwal Region';
  bool _bidAlerts = true;
  bool _listingAlerts = true;
  bool _paymentAlerts = true;
  File? _profileImage;

  Future<void> _startEditBusinessDetailsFlow() async {
    final verified = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => const VendorBusinessOtpScreen(),
      ),
    );

    if (verified != true || !mounted) return;

    final result = await Navigator.of(context).push<Map<String, String>>(
      MaterialPageRoute(
        builder: (_) => VendorEditBusinessDetailsScreen(
          initialCompany: _vendorName,
          initialRegion: _location,
          initialEmail: _email,
          initialPhone: _phone,
        ),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _vendorName = result['company'] ?? _vendorName;
        _location = result['region'] ?? _location;
        _email = result['email'] ?? _email;
        _phone = result['phone'] ?? _phone;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Business details updated successfully (Demo).'),
          backgroundColor: AppColors.darkGreen,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);
      if (!mounted) return;
      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vendor profile picture updated successfully.'),
            backgroundColor: AppColors.darkGreen,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not pick image: $e'),
          backgroundColor: AppColors.errorRed,
        ),
      );
    }
  }

  void _showImageSourceModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              'Update Vendor Profile Picture',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGreen,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Select source to upload commercial vendor profile photo:',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.secondaryText,
              ),
            ),
            SizedBox(height: 16.h),

            // Option 1: Camera
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(10.r),
                decoration: const BoxDecoration(
                  color: Color(0xFFE3EFE6),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.camera_alt_outlined,
                  color: AppColors.darkGreen,
                  size: 20.r,
                ),
              ),
              title: Text(
                'Take Photo (Camera)',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryText,
                ),
              ),
              subtitle: Text(
                'Use device camera to capture new photo',
                style:
                    TextStyle(fontSize: 11.sp, color: AppColors.secondaryText),
              ),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.camera);
              },
            ),
            const Divider(color: AppColors.cardBorder, height: 1),

            // Option 2: Gallery
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(10.r),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF3E0),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.photo_library_outlined,
                  color: const Color(0xFFF99A20),
                  size: 20.r,
                ),
              ),
              title: Text(
                'Choose from Gallery',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryText,
                ),
              ),
              subtitle: Text(
                'Select photo from device photo gallery',
                style:
                    TextStyle(fontSize: 11.sp, color: AppColors.secondaryText),
              ),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.gallery);
              },
            ),
            const Divider(color: AppColors.cardBorder, height: 1),

            // Option 3: Drive / Files / PC Storage
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(10.r),
                decoration: const BoxDecoration(
                  color: Color(0xFFE3F2FD),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.cloud_upload_outlined,
                  color: const Color(0xFF1976D2),
                  size: 20.r,
                ),
              ),
              title: Text(
                'Browse Files / Drive / PC Storage',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryText,
                ),
              ),
              subtitle: Text(
                'Select file from Google Drive or local storage',
                style:
                    TextStyle(fontSize: 11.sp, color: AppColors.secondaryText),
              ),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.gallery);
              },
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;

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
                  children: [
                    // Green header with Vendor Avatar & Verified Badge
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(
                        top: topPadding > 0 ? topPadding + 16.h : 24.h,
                        bottom: 32.h,
                        left: 20.w,
                        right: 20.w,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.darkGreen,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(28.r),
                          bottomRight: Radius.circular(28.r),
                        ),
                      ),
                      child: Column(
                        children: [
                          // Avatar Stack with Edit Camera Badge
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              InkWell(
                                onTap: _showImageSourceModal,
                                borderRadius: BorderRadius.circular(44.r),
                                child: Container(
                                  height: 84.r,
                                  width: 84.r,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(0xFFF99A20),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2.5.w,
                                    ),
                                  ),
                                  child: ClipOval(
                                    child: _profileImage != null
                                        ? Image.file(
                                            _profileImage!,
                                            fit: BoxFit.cover,
                                          )
                                        : Center(
                                            child: Text(
                                              'AN',
                                              style: TextStyle(
                                                fontSize: 28.sp,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: InkWell(
                                  onTap: _showImageSourceModal,
                                  borderRadius: BorderRadius.circular(14.r),
                                  child: Container(
                                    height: 28.r,
                                    width: 28.r,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.darkGreen,
                                        width: 1.5.w,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.camera_alt_rounded,
                                      size: 14.r,
                                      color: AppColors.darkGreen,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            _vendorName,
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.verified_rounded,
                                  color: const Color(0xFFF99A20),
                                  size: 16.r,
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  'Verified Commercial Vendor',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // Quick Management Shortcuts
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Vendor Shortcuts',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.secondaryText,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          _buildInfoCard([
                            _buildTapRow(
                              Icons.inventory_2_outlined,
                              'My Orders',
                              () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const VendorOrdersScreen(),
                                ),
                              ),
                            ),
                            _buildDivider(),
                            _buildTapRow(
                              Icons.account_balance_wallet_outlined,
                              'Payments & Milestones',
                              () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const VendorPaymentsScreen(),
                                ),
                              ),
                            ),
                            _buildDivider(),
                            _buildTapRow(
                              Icons.local_offer_outlined,
                              'Bids History',
                              () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const VendorBidsHistoryScreen(),
                                ),
                              ),
                            ),
                          ]),

                          SizedBox(height: 20.h),

                          Text(
                            'Business & Account Details',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.secondaryText,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          _buildInfoCard([
                            _buildInfoRow(
                                Icons.business_outlined, 'Company', _vendorName),
                            _buildDivider(),
                            _buildInfoRow(
                                Icons.location_on_outlined, 'Region', _location),
                            _buildDivider(),
                            _buildInfoRow(Icons.email_outlined, 'Email', _email),
                            _buildDivider(),
                            _buildInfoRow(Icons.phone_outlined, 'Phone', _phone),
                          ]),
                          SizedBox(height: 12.h),
                          SizedBox(
                            width: double.infinity,
                            height: 44.h,
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                    color: AppColors.darkGreen, width: 1.w),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                backgroundColor: Colors.white,
                              ),
                              onPressed: _startEditBusinessDetailsFlow,
                              icon: Icon(
                                Icons.edit_outlined,
                                size: 18.r,
                                color: AppColors.darkGreen,
                              ),
                              label: Text(
                                'Edit Details',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkGreen,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 20.h),

                          Text(
                            'Notifications & Alerts',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.secondaryText,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          _buildInfoCard([
                            _buildToggleRow('Bid Updates & Acceptances', _bidAlerts,
                                (val) {
                              setState(() => _bidAlerts = val);
                            }),
                            _buildDivider(),
                            _buildToggleRow('New Listing Alerts', _listingAlerts,
                                (val) {
                              setState(() => _listingAlerts = val);
                            }),
                            _buildDivider(),
                            _buildToggleRow('Payment Milestones Alerts', _paymentAlerts,
                                (val) {
                              setState(() => _paymentAlerts = val);
                            }),
                          ]),

                          SizedBox(height: 20.h),

                          Text(
                            'Security & Session',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.secondaryText,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          _buildInfoCard([
                            _buildTapRow(
                              Icons.lock_outline_rounded,
                              'Change Password',
                              () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const VendorChangePasswordScreen(),
                                ),
                              ),
                            ),
                            _buildDivider(),
                            _buildTapRow(
                              Icons.logout_rounded,
                              'Sign Out',
                              () {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (_) => const WelcomeRoleScreen(),
                                  ),
                                  (route) => false,
                                );
                              },
                              color: AppColors.errorRed,
                            ),
                          ]),
                        ],
                      ),
                    ),

                    SizedBox(height: 28.h),
                  ],
                ),
              ),
            ),
          ],
        ),

        bottomNavigationBar: const VendorBottomNavigation(selectedIndex: 4),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
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
      child: Column(children: children),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        children: [
          Icon(icon, size: 20.r, color: AppColors.secondaryText),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 13.sp, color: AppColors.secondaryText),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleRow(
      String label, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 14.sp, color: AppColors.primaryText),
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: AppColors.darkGreen,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildTapRow(IconData icon, String label, VoidCallback onTap,
      {Color? color}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            Icon(icon, size: 20.r, color: color ?? AppColors.primaryText),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: color ?? AppColors.primaryText,
                ),
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                size: 20.r, color: AppColors.secondaryText),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: AppColors.cardBorder,
      height: 1.h,
      indent: 16.w,
      endIndent: 16.w,
    );
  }
}
