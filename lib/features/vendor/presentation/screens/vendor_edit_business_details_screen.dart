import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';

class VendorEditBusinessDetailsScreen extends StatefulWidget {
  final String initialCompany;
  final String initialRegion;
  final String initialEmail;
  final String initialPhone;

  const VendorEditBusinessDetailsScreen({
    super.key,
    required this.initialCompany,
    required this.initialRegion,
    required this.initialEmail,
    required this.initialPhone,
  });

  @override
  State<VendorEditBusinessDetailsScreen> createState() =>
      _VendorEditBusinessDetailsScreenState();
}

class _VendorEditBusinessDetailsScreenState
    extends State<VendorEditBusinessDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _companyController;
  late TextEditingController _regionController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _companyController =
        TextEditingController(text: widget.initialCompany);
    _regionController = TextEditingController(text: widget.initialRegion);
    _emailController = TextEditingController(text: widget.initialEmail);
    _phoneController = TextEditingController(text: widget.initialPhone);
  }

  @override
  void dispose() {
    _companyController.dispose();
    _regionController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _handleSaveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    setState(() => _isSaving = false);

    Navigator.of(context).pop({
      'company': _companyController.text.trim(),
      'region': _regionController.text.trim(),
      'email': _emailController.text.trim(),
      'phone': _phoneController.text.trim(),
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
            // ==========================================
            // 1. FIXED TOP APP BAR
            // ==========================================
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: topPadding > 0 ? topPadding + 8.h : 16.h,
                left: 20.w,
                right: 20.w,
                bottom: 16.h,
              ),
              color: AppColors.warmCream,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                            size: 18.r,
                            color: AppColors.darkGreen,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE3EFE6),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          'Verified Vendor',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Edit Business Details',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGreen,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Update company name, region, email, and phone number.',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),

            // ==========================================
            // 2. SCROLLABLE FORM CONTENT
            // ==========================================
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Company Name
                      _buildFieldLabel('Company Name *'),
                      SizedBox(height: 8.h),
                      TextFormField(
                        controller: _companyController,
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: AppColors.primaryText,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: _buildInputDecoration(
                          hintText: 'e.g. Al-Noor Traders',
                          prefixIcon: Icons.business_outlined,
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Company name cannot be empty.';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 18.h),

                      // Region
                      _buildFieldLabel('Region *'),
                      SizedBox(height: 8.h),
                      TextFormField(
                        controller: _regionController,
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: AppColors.primaryText,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: _buildInputDecoration(
                          hintText: 'e.g. Sargodha & Bhalwal Region',
                          prefixIcon: Icons.location_on_outlined,
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Region cannot be empty.';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 18.h),

                      // Email Address
                      _buildFieldLabel('Email Address *'),
                      SizedBox(height: 8.h),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: AppColors.primaryText,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: _buildInputDecoration(
                          hintText: 'e.g. alnoor.traders@orivis.pk',
                          prefixIcon: Icons.email_outlined,
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Email address cannot be empty.';
                          }
                          final emailRegExp =
                              RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                          if (!emailRegExp.hasMatch(val.trim())) {
                            return 'Please enter a valid email address.';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 18.h),

                      // Phone Number
                      _buildFieldLabel('Phone Number *'),
                      SizedBox(height: 8.h),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: AppColors.primaryText,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: _buildInputDecoration(
                          hintText: 'e.g. +92 300 9876543',
                          prefixIcon: Icons.phone_outlined,
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Phone number cannot be empty.';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 28.h),

                      // Full-Width Orange Save Button
                      SizedBox(
                        width: double.infinity,
                        height: 52.h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF99A20),
                            foregroundColor: AppColors.primaryText,
                            elevation: 2,
                            shadowColor:
                                const Color(0xFFF99A20).withValues(alpha: 0.35),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                          ),
                          onPressed: _isSaving ? null : _handleSaveChanges,
                          child: _isSaving
                              ? SizedBox(
                                  height: 20.r,
                                  width: 20.r,
                                  child: const CircularProgressIndicator(
                                    color: AppColors.primaryText,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Save Changes',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),

                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryText,
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hintText,
    required IconData prefixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        fontSize: 14.sp,
        color: const Color(0xFF929A92),
      ),
      prefixIcon: Icon(
        prefixIcon,
        size: 20.r,
        color: AppColors.secondaryText,
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
        borderSide: BorderSide(color: AppColors.secondaryGreen, width: 1.5.w),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: BorderSide(color: AppColors.errorRed, width: 1.w),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: BorderSide(color: AppColors.errorRed, width: 1.w),
      ),
    );
  }
}
