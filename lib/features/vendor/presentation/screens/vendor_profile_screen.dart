import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/screens/welcome_role_screen.dart';
import '../widgets/vendor_bottom_navigation.dart';

class VendorProfileScreen extends StatefulWidget {
  const VendorProfileScreen({super.key});

  @override
  State<VendorProfileScreen> createState() => _VendorProfileScreenState();
}

class _VendorProfileScreenState extends State<VendorProfileScreen> {
  final String _vendorName = 'Al-Noor Traders';
  final String _email = 'alnoor@example.com';
  final String _phone = '0300 9876543';
  bool _bidAlerts = true;
  bool _listingAlerts = true;

  void _showDemoMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.darkGreen,
        duration: const Duration(seconds: 2),
      ),
    );
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
                child: Column(
                  children: [
                    // Green header
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
                          // Avatar
                          Container(
                            height: 72.r,
                            width: 72.r,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF99A20),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                'AN',
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            _vendorName,
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Vendor Account',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: const Color(0xFFDCE9E0),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // Profile details card
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Account details',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.secondaryText,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          _buildInfoCard([
                            _buildInfoRow(Icons.business_outlined, 'Company', _vendorName),
                            _buildDivider(),
                            _buildInfoRow(Icons.email_outlined, 'Email', _email),
                            _buildDivider(),
                            _buildInfoRow(Icons.phone_outlined, 'Phone', _phone),
                          ]),

                          SizedBox(height: 20.h),

                          Text(
                            'Notifications',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.secondaryText,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          _buildInfoCard([
                            _buildToggleRow('Bid updates', _bidAlerts, (val) {
                              setState(() => _bidAlerts = val);
                            }),
                            _buildDivider(),
                            _buildToggleRow('New listing alerts', _listingAlerts, (val) {
                              setState(() => _listingAlerts = val);
                            }),
                          ]),

                          SizedBox(height: 20.h),

                          Text(
                            'Actions',
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
                              'Change password',
                              () => _showDemoMessage('Demo mode: not connected.'),
                            ),
                            _buildDivider(),
                            _buildTapRow(
                              Icons.logout_rounded,
                              'Sign out',
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

                    SizedBox(height: 24.h),
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
              style: TextStyle(fontSize: 14.sp, color: AppColors.secondaryText),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleRow(String label, bool value, ValueChanged<bool> onChanged) {
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
