import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/orchard_state_service.dart';
import '../../../marketplace/presentation/screens/received_bids_screen.dart';
import '../../../scan/presentation/screens/scan_orchard_screen.dart';
import 'grower_dashboard_screen.dart';

class AddOrchardScreen extends StatefulWidget {
  const AddOrchardScreen({super.key});

  @override
  State<AddOrchardScreen> createState() => _AddOrchardScreenState();
}

class _AddOrchardScreenState extends State<AddOrchardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController(text: 'Sargodha');
  final _varietyController = TextEditingController(text: 'Kinnow');
  final _areaController = TextEditingController();

  String _selectedAreaUnit = 'acres';
  int _selectedBottomIndex = 0; // Home tab

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _varietyController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  void _handleSaveOrchard() {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final location = _locationController.text.trim();
    final variety = _varietyController.text.trim();
    final area = double.tryParse(_areaController.text.trim()) ?? 10.0;

    OrchardStateService().addOrchard(
      name: name,
      location: location,
      variety: variety,
      area: area,
      areaUnit: _selectedAreaUnit,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Orchard added successfully.'),
        backgroundColor: AppColors.darkGreen,
        duration: Duration(seconds: 2),
      ),
    );

    Navigator.of(context).pop();
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
              padding: EdgeInsets.only(
                top: topPadding > 0 ? topPadding + 8.h : 16.h,
                left: 20.w,
                right: 20.w,
                bottom: 16.h,
              ),
              decoration: BoxDecoration(
                color: AppColors.warmCream,
              ),
              child: Row(
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
                    'Add orchard',
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
                      _buildFieldLabel('Orchard name *'),
                      SizedBox(height: 8.h),
                      TextFormField(
                        controller: _nameController,
                        decoration: _buildInputDecoration(
                          hintText: 'e.g. Kinnow Block B',
                        ),
                        validator: (val) => val == null || val.trim().isEmpty
                            ? 'Please enter orchard name.'
                            : null,
                      ),

                      SizedBox(height: 20.h),

                      _buildFieldLabel('Location *'),
                      SizedBox(height: 8.h),
                      TextFormField(
                        controller: _locationController,
                        decoration: _buildInputDecoration(
                          hintText: 'e.g. Sargodha',
                        ),
                        validator: (val) => val == null || val.trim().isEmpty
                            ? 'Please enter location.'
                            : null,
                      ),

                      SizedBox(height: 20.h),

                      _buildFieldLabel('Fruit variety *'),
                      SizedBox(height: 8.h),
                      TextFormField(
                        controller: _varietyController,
                        decoration: _buildInputDecoration(
                          hintText: 'e.g. Kinnow',
                        ),
                        validator: (val) => val == null || val.trim().isEmpty
                            ? 'Please enter fruit variety.'
                            : null,
                      ),

                      SizedBox(height: 20.h),

                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isNarrow = constraints.maxWidth < 300;
                          if (isNarrow) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildFieldLabel('Area *'),
                                SizedBox(height: 8.h),
                                TextFormField(
                                  controller: _areaController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                                  decoration: _buildInputDecoration(
                                    hintText: 'e.g. 10',
                                  ),
                                  validator: (val) {
                                    if (val == null || val.trim().isEmpty) {
                                      return 'Enter area.';
                                    }
                                    if (double.tryParse(val.trim()) == null) {
                                      return 'Invalid number.';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 16.h),
                                _buildFieldLabel('Unit'),
                                SizedBox(height: 8.h),
                                DropdownButtonFormField<String>(
                                  initialValue: _selectedAreaUnit,
                                  isExpanded: true,
                                  dropdownColor: Colors.white,
                                  decoration: _buildInputDecoration(
                                    hintText: '',
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                      vertical: 14.h,
                                    ),
                                  ),
                                  items: ['acres', 'hectares']
                                      .map(
                                        (unit) => DropdownMenuItem(
                                          value: unit,
                                          child: Text(
                                            unit,
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              color: AppColors.primaryText,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (val) {
                                    if (val != null) {
                                      setState(() => _selectedAreaUnit = val);
                                    }
                                  },
                                ),
                              ],
                            );
                          }

                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildFieldLabel('Area *'),
                                    SizedBox(height: 8.h),
                                    TextFormField(
                                      controller: _areaController,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                      decoration: _buildInputDecoration(
                                        hintText: 'e.g. 10',
                                      ),
                                      validator: (val) {
                                        if (val == null || val.trim().isEmpty) {
                                          return 'Enter area.';
                                        }
                                        if (double.tryParse(val.trim()) ==
                                            null) {
                                          return 'Invalid number.';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildFieldLabel('Unit'),
                                    SizedBox(height: 8.h),
                                    DropdownButtonFormField<String>(
                                      initialValue: _selectedAreaUnit,
                                      isExpanded: true,
                                      dropdownColor: Colors.white,
                                      decoration: _buildInputDecoration(
                                        hintText: '',
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12.w,
                                          vertical: 14.h,
                                        ),
                                      ),
                                      items: ['acres', 'hectares']
                                          .map(
                                            (unit) => DropdownMenuItem(
                                              value: unit,
                                              child: Text(
                                                unit,
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  color: AppColors.primaryText,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (val) {
                                        if (val != null) {
                                          setState(
                                              () => _selectedAreaUnit = val);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),

                      SizedBox(height: 36.h),

                      // Save Orchard Button
                      SizedBox(
                        width: double.infinity,
                        height: 52.h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF99A20),
                            foregroundColor: AppColors.primaryText,
                            elevation: 2,
                            shadowColor: const Color(0xFFF99A20)
                                .withValues(alpha: 0.35),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                          ),
                          onPressed: _handleSaveOrchard,
                          child: Text(
                            'Save Orchard',
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

  Widget _buildFieldLabel(String labelText) {
    return Text(
      labelText,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryText,
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hintText,
    Color? fillColor,
    EdgeInsetsGeometry? padding,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        fontSize: 14.sp,
        color: AppColors.placeholderColor,
      ),
      filled: true,
      fillColor: fillColor ?? Colors.white,
      contentPadding: padding ??
          EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide(
          color: AppColors.cardBorder,
          width: 1.w,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide(
          color: AppColors.cardBorder,
          width: 1.w,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide(
          color: AppColors.darkGreen,
          width: 1.5.w,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide(
          color: AppColors.errorRed,
          width: 1.w,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide(
          color: AppColors.errorRed,
          width: 1.5.w,
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
