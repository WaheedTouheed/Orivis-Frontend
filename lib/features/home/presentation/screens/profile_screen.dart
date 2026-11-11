import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../auth/presentation/screens/welcome_role_screen.dart';
import '../../../marketplace/presentation/screens/received_bids_screen.dart';
import '../../../scan/presentation/screens/scan_orchard_screen.dart';
import 'grower_dashboard_screen.dart';
import 'edit_profile_screen.dart';
import 'my_orchards_screen.dart';
import 'payment_schedule_screen.dart';
import 'change_password_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedBottomIndex = 4; // Profile tab

  // Profile local state
  String _userName = 'Ali Raza';
  final String _email = 'ali@example.com';
  String _phoneNumber = '0300 1234567';
  final String _role = 'Grower';
  File? _profileImage;

  // Preferences local state
  String _selectedLanguage = 'English';
  String _selectedAreaUnit = 'Acres';
  bool _bidAlerts = true;
  bool _scanReadyAlerts = true;

  Future<void> _pickProfileImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (!mounted) return;
      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile picture updated successfully.'),
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

  Future<void> _navigateToEditProfile() async {
    final result = await Navigator.of(context).push<Map<String, String>>(
      MaterialPageRoute(
        builder: (_) => EditProfileScreen(
          initialName: _userName,
          initialEmail: _email,
          initialPhone: _phoneNumber,
        ),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _userName = result['name'] ?? _userName;
        _phoneNumber = result['phone'] ?? _phoneNumber;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully.'),
          backgroundColor: AppColors.darkGreen,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _navigateToMyOrchards() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const MyOrchardsScreen(),
      ),
    );
  }

  void _navigateToPaymentSchedule() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const PaymentScheduleScreen(),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        backgroundColor: Colors.white,
        title: Text(
          'Select Language',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.darkGreen,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSelectionOption(
              title: 'English',
              isSelected: _selectedLanguage == 'English',
              onTap: () {
                setState(() => _selectedLanguage = 'English');
                Navigator.of(context).pop();
              },
            ),
            SizedBox(height: 8.h),
            _buildSelectionOption(
              title: 'Urdu (اردو)',
              isSelected: _selectedLanguage == 'Urdu',
              onTap: () {
                setState(() => _selectedLanguage = 'Urdu');
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAreaUnitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        backgroundColor: Colors.white,
        title: Text(
          'Select Area Unit',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.darkGreen,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSelectionOption(
              title: 'Acres',
              isSelected: _selectedAreaUnit == 'Acres',
              onTap: () {
                setState(() => _selectedAreaUnit = 'Acres');
                Navigator.of(context).pop();
              },
            ),
            SizedBox(height: 8.h),
            _buildSelectionOption(
              title: 'Hectares',
              isSelected: _selectedAreaUnit == 'Hectares',
              onTap: () {
                setState(() => _selectedAreaUnit = 'Hectares');
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionOption({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.lightGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? AppColors.darkGreen : AppColors.cardBorder,
            width: isSelected ? 1.5.w : 1.w,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? AppColors.darkGreen : AppColors.primaryText,
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                size: 20.r,
                color: AppColors.darkGreen,
              ),
          ],
        ),
      ),
    );
  }

  void _navigateToChangePassword() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const ChangePasswordScreen(),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        backgroundColor: Colors.white,
        title: Text(
          'Log out?',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.darkGreen,
          ),
        ),
        content: Text(
          'Are you sure you want to log out?',
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
              backgroundColor: AppColors.errorRed,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            onPressed: () async {
              Navigator.of(context).pop();
              final storageService = SecureStorageService();
              await storageService.clearAll();
              if (!context.mounted) return;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => const WelcomeRoleScreen(),
                ),
                (route) => false,
              );
            },
            child: Text(
              'Log out',
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
            // ==========================================
            // SCROLLABLE CONTENT
            // ==========================================
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    // ==========================================
                    // 1. PROFILE HEADER
                    // ==========================================
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
                          bottomLeft: Radius.circular(32.r),
                          bottomRight: Radius.circular(32.r),
                        ),
                      ),
                      child: Column(
                        children: [
                          // Avatar Stack with Camera Button
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: 96.r,
                                width: 96.r,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFFF99A20),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3.w,
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
                                            'AR',
                                            style: TextStyle(
                                              fontSize: 32.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: InkWell(
                                  onTap: _pickProfileImage,
                                  borderRadius: BorderRadius.circular(16.r),
                                  child: Container(
                                    height: 32.r,
                                    width: 32.r,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.darkGreen,
                                        width: 1.5.w,
                                      ),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.camera_alt_rounded,
                                        size: 16.r,
                                        color: AppColors.darkGreen,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 16.h),

                          Text(
                            _userName,
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),

                          SizedBox(height: 4.h),

                          Text(
                            '$_email · $_role',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: const Color(0xFFDCE9E0),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // ==========================================
                    // 2. ACCOUNT SECTION
                    // ==========================================
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('Account'),
                          SizedBox(height: 10.h),
                          _buildCardContainer([
                            _buildActionRow(
                              title: 'Edit profile',
                              onTap: _navigateToEditProfile,
                            ),
                            _buildDivider(),
                            _buildActionRow(
                              title: 'My orchards',
                              onTap: _navigateToMyOrchards,
                            ),
                            _buildDivider(),
                            _buildActionRow(
                              title: 'Payment schedule',
                              onTap: _navigateToPaymentSchedule,
                            ),
                          ]),

                          SizedBox(height: 24.h),

                          // ==========================================
                          // 3. PREFERENCES SECTION
                          // ==========================================
                          _buildSectionTitle('Preferences'),
                          SizedBox(height: 10.h),
                          _buildCardContainer([
                            _buildValueRow(
                              title: 'Language',
                              value: _selectedLanguage,
                              onTap: _showLanguageDialog,
                            ),
                            _buildDivider(),
                            _buildValueRow(
                              title: 'Area unit',
                              value: _selectedAreaUnit,
                              onTap: _showAreaUnitDialog,
                            ),
                            _buildDivider(),
                            _buildSwitchRow(
                              title: 'Bid alerts',
                              value: _bidAlerts,
                              onChanged: (val) =>
                                  setState(() => _bidAlerts = val),
                            ),
                            _buildDivider(),
                            _buildSwitchRow(
                              title: 'Scan ready alerts',
                              value: _scanReadyAlerts,
                              onChanged: (val) =>
                                  setState(() => _scanReadyAlerts = val),
                            ),
                          ]),

                          SizedBox(height: 24.h),

                          // ==========================================
                          // 4. SECURITY SECTION
                          // ==========================================
                          _buildSectionTitle('Security'),
                          SizedBox(height: 10.h),
                          _buildCardContainer([
                            _buildActionRow(
                              title: 'Change password',
                              onTap: _navigateToChangePassword,
                            ),
                            _buildDivider(),
                            _buildActionRow(
                              title: 'Log out',
                              textColor: AppColors.errorRed,
                              showChevron: false,
                              onTap: _showLogoutDialog,
                            ),
                          ]),

                          SizedBox(height: 32.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        // ==========================================
        // FIXED BOTTOM NAVIGATION BAR
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.primaryText,
      ),
    );
  }

  Widget _buildCardContainer(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.cardBorder,
          width: 1.w,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildActionRow({
    required String title,
    required VoidCallback onTap,
    Color? textColor,
    bool showChevron = true,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: textColor ?? AppColors.primaryText,
              ),
            ),
            if (showChevron)
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16.r,
                color: AppColors.secondaryText,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildValueRow({
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryText,
              ),
            ),
            Row(
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.secondaryText,
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16.r,
                  color: AppColors.secondaryText,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchRow({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryText,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: AppColors.darkGreen,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: AppColors.cardBorder,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1.h,
      thickness: 1.w,
      color: AppColors.cardBorder,
      indent: 16.w,
      endIndent: 16.w,
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
          // Already on Profile
        } else {
          setState(() => _selectedBottomIndex = index);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Demo mode: $label tab is not connected yet.'),
              duration: const Duration(seconds: 1),
            ),
          );
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
                color: isSelected
                    ? AppColors.darkGreen
                    : AppColors.secondaryText,
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
          color: const Color(0xFFF99A20),
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
