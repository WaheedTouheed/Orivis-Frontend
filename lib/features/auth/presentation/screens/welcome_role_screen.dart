import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import 'grower_login_screen.dart';
import 'login_screen.dart';

class WelcomeRoleScreen extends StatefulWidget {
  const WelcomeRoleScreen({super.key});

  @override
  State<WelcomeRoleScreen> createState() => _WelcomeRoleScreenState();
}

class _WelcomeRoleScreenState extends State<WelcomeRoleScreen> {
  // Currently selected role: 'grower' | 'vendor' | null
  String? _selectedRole;

  void _handleContinue() {
    if (_selectedRole == null) return;

    if (_selectedRole == 'grower') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const GrowerLoginScreen(),
        ),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => LoginScreen(role: _selectedRole),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark, // Dark status bar icons on warm cream
        statusBarBrightness: Brightness.light,    // Dark status bar text on iOS
      ),
      child: Scaffold(
        backgroundColor: AppColors.welcomeBackground,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 20.h),

                        // --- 1. Top Logo ---
                        Center(
                          child: Image.asset(
                            AppAssets.logo,
                            height: 56.h,
                            width: 56.w,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.eco,
                                size: 56.r,
                                color: AppColors.darkGreen,
                              );
                            },
                          ),
                        ),

                        SizedBox(height: 28.h),

                        // --- 2. Title ---
                        Text(
                          'Choose how you use ORIVIS',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkGreen,
                            height: 1.25,
                          ),
                        ),

                        SizedBox(height: 10.h),

                        // --- 3. Subtitle ---
                        Text(
                          'You can change this later by going back.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.secondaryText,
                          ),
                        ),

                        SizedBox(height: 32.h),

                        // --- 4. Role Selection Cards ---

                        // Card 1: Grower
                        _buildRoleCard(
                          roleKey: 'grower',
                          title: 'Grower',
                          description:
                              'Scan your orchard, review AI reports, and connect with buyers.',
                          iconData: Icons.eco_outlined,
                        ),

                        SizedBox(height: 16.h),

                        // Card 2: Vendor
                        _buildRoleCard(
                          roleKey: 'vendor',
                          title: 'Vendor',
                          description:
                              'Discover produce listings and submit competitive bids.',
                          iconData: Icons.shopping_basket_outlined,
                        ),
                      ],
                    ),
                  ),
                ),

                // --- 5. Bottom Actions Section ---
                Column(
                  children: [
                    SizedBox(height: 16.h),

                    // Continue Button
                    SizedBox(
                      width: double.infinity,
                      height: 52.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedRole != null
                              ? AppColors.darkGreen
                              : AppColors.mutedGreen,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        onPressed: _selectedRole != null ? _handleContinue : null,
                        child: Text(
                          _selectedRole == null
                              ? 'Select a role to continue'
                              : 'Continue as ${_selectedRole == 'grower' ? 'Grower' : 'Vendor'}',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // --- 6. Language Selector Widget ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.language_outlined,
                          size: 18.r,
                          color: AppColors.secondaryText,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'English',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 8.h),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required String roleKey,
    required String title,
    required String description,
    required IconData iconData,
  }) {
    final isSelected = _selectedRole == roleKey;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedRole = roleKey;
        });
      },
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.lightGreen : AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? AppColors.darkGreen : AppColors.cardBorder,
            width: isSelected ? 2.w : 1.w,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon Container
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.darkGreen.withValues(alpha: 0.12)
                    : AppColors.welcomeBackground,
                shape: BoxShape.circle,
              ),
              child: Icon(
                iconData,
                size: 26.r,
                color: isSelected ? AppColors.darkGreen : AppColors.secondaryText,
              ),
            ),

            SizedBox(width: 14.w),

            // Title & Description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkGreen,
                        ),
                      ),

                      // Custom Radio Selection Indicator
                      Container(
                        height: 20.r,
                        width: 20.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? AppColors.darkGreen : Colors.transparent,
                          border: Border.all(
                            color: isSelected ? AppColors.darkGreen : AppColors.cardBorder,
                            width: 2.w,
                          ),
                        ),
                        child: isSelected
                            ? Icon(
                                Icons.check,
                                size: 13.r,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ],
                  ),

                  SizedBox(height: 6.h),

                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13.sp,
                      height: 1.35,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
