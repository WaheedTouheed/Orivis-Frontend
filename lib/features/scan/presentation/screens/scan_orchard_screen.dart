import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_colors.dart';
import 'scan_processing_screen.dart';

class ScanOrchardScreen extends StatefulWidget {
  const ScanOrchardScreen({super.key});

  @override
  State<ScanOrchardScreen> createState() => _ScanOrchardScreenState();
}

class _ScanOrchardScreenState extends State<ScanOrchardScreen> {
  String _selectedOrchard = 'Kinnow Block A';
  String _selectedSource = 'Photo'; // 'Photo', 'Video', 'Gallery'

  List<CameraDescription> _cameras = [];
  CameraController? _cameraController;
  int _selectedCameraIndex = 0;
  bool _isCameraInitializing = true;
  String? _capturedImagePath;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      setState(() => _isCameraInitializing = true);
      _cameras = await availableCameras();
      if (_cameras.isNotEmpty) {
        _cameraController = CameraController(
          _cameras[_selectedCameraIndex],
          ResolutionPreset.high,
          enableAudio: false,
        );
        await _cameraController!.initialize();
        if (mounted) {
          setState(() {
            _isCameraInitializing = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isCameraInitializing = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isCameraInitializing = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
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

  Future<void> _handleCapture() async {
    if (_capturedImagePath != null) {
      // Retake: reset captured image
      setState(() {
        _capturedImagePath = null;
      });
      _showDemoMessage('Reset capture. Ready for new photo.');
      return;
    }

    if (_cameraController != null && _cameraController!.value.isInitialized) {
      try {
        final image = await _cameraController!.takePicture();
        setState(() {
          _capturedImagePath = image.path;
        });
        _showDemoMessage('Photo captured successfully.');
      } catch (e) {
        // Fallback for emulator / camera hardware error
        setState(() {
          _capturedImagePath = 'demo_sample_photo';
        });
        _showDemoMessage('Demo photo captured.');
      }
    } else {
      // Fallback for demo mode when live camera is unavailable (e.g. emulator)
      setState(() {
        _capturedImagePath = 'demo_sample_photo';
      });
      _showDemoMessage('Demo photo captured.');
    }
  }

  Future<void> _switchCamera() async {
    if (_cameras.length > 1) {
      _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras.length;
      await _cameraController?.dispose();
      await _initializeCamera();
    } else {
      _showDemoMessage('Only one camera is available on this device.');
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _capturedImagePath = image.path;
          _selectedSource = 'Gallery';
        });
        _showDemoMessage('Image selected from gallery.');
      }
    } catch (e) {
      // Fallback for emulator without gallery photos
      setState(() {
        _capturedImagePath = 'demo_sample_photo';
        _selectedSource = 'Gallery';
      });
      _showDemoMessage('Demo photo selected.');
    }
  }

  void _showOrchardChangeDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Orchard',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGreen,
                ),
              ),
              SizedBox(height: 16.h),
              ListTile(
                title: const Text('Kinnow Block A'),
                trailing: _selectedOrchard == 'Kinnow Block A'
                    ? const Icon(Icons.check, color: AppColors.darkGreen)
                    : null,
                onTap: () {
                  setState(() => _selectedOrchard = 'Kinnow Block A');
                  Navigator.of(context).pop();
                },
              ),
              const Divider(),
              ListTile(
                title: const Text('Block C'),
                trailing: _selectedOrchard == 'Block C'
                    ? const Icon(Icons.check, color: AppColors.darkGreen)
                    : null,
                onTap: () {
                  setState(() => _selectedOrchard = 'Block C');
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleSubmitScan() {
    final imagePath = _capturedImagePath ?? 'demo_sample_photo';

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ScanProcessingScreen(
          imagePath: imagePath,
          orchardName: _selectedOrchard,
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
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.warmCream,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(
              top: topPadding > 0 ? topPadding + 8.h : 16.h,
              left: 20.w,
              right: 20.w,
              bottom: 24.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ==========================================
                // 1. HEADER SECTION
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
                      'Scan orchard',
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkGreen,
                      ),
                    ),
                    SizedBox(width: 40.r), // Spacer
                  ],
                ),

                SizedBox(height: 14.h),

                // Step Indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildStepChip('1. Orchard', isActive: false),
                    SizedBox(width: 8.w),
                    _buildStepChip('2. Capture', isActive: true),
                    SizedBox(width: 8.w),
                    _buildStepChip('3. Review', isActive: false),
                  ],
                ),

                SizedBox(height: 20.h),

                // ==========================================
                // 2. ORCHARD SELECTOR CARD
                // ==========================================
                Text(
                  'Orchard',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryText,
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: AppColors.cardBorder,
                      width: 1.w,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedOrchard,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryText,
                        ),
                      ),
                      InkWell(
                        onTap: _showOrchardChangeDialog,
                        borderRadius: BorderRadius.circular(6.r),
                        child: Text(
                          'Change ›',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20.h),

                // ==========================================
                // 3. SOURCE SELECTOR (Photo / Video / Gallery)
                // ==========================================
                Text(
                  'Source',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryText,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Expanded(
                      child: _buildSourceTab(
                        modeKey: 'Photo',
                        label: 'Photo',
                        iconData: Icons.camera_alt_outlined,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: _buildSourceTab(
                        modeKey: 'Video',
                        label: 'Video',
                        iconData: Icons.videocam_outlined,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: _buildSourceTab(
                        modeKey: 'Gallery',
                        label: 'Gallery',
                        iconData: Icons.image_outlined,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20.h),

                // ==========================================
                // 4. REAL-TIME CAMERA PREVIEW CONTAINER
                // ==========================================
                Container(
                  height: 300.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.darkGreen,
                    borderRadius: BorderRadius.circular(24.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Camera Preview or Captured Image
                      if (_capturedImagePath != null)
                        _capturedImagePath!.startsWith('demo')
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.check_circle_outline,
                                      size: 52.r,
                                      color: const Color(0xFFF99A20),
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      'Photo Captured',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      'Tap Submit scan to analyze.',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: AppColors.subtitleLight,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Image.file(
                                File(_capturedImagePath!),
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              )
                      else if (_isCameraInitializing)
                        const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFF99A20),
                          ),
                        )
                      else if (_cameraController != null &&
                          _cameraController!.value.isInitialized)
                        SizedBox.expand(
                          child: CameraPreview(_cameraController!),
                        )
                      else
                        // Fallback when camera hardware is unavailable on emulator
                        Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera_enhance_outlined,
                                  size: 48.r,
                                  color: const Color(0xFFF99A20),
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  'Camera Ready',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  'Tap the orange capture button to take a photo.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: AppColors.subtitleLight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      // Fruit Framing Overlay Guide
                      if (_capturedImagePath == null)
                        Positioned.fill(
                          child: Container(
                            margin: EdgeInsets.all(20.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18.r),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.6),
                                width: 1.5.w,
                              ),
                            ),
                            child: Stack(
                              children: [
                                // Orange Focus Markers
                                Positioned(
                                  top: 40.h,
                                  left: 30.w,
                                  child: _buildFocusMarker(),
                                ),
                                Positioned(
                                  top: 90.h,
                                  right: 30.w,
                                  child: _buildFocusMarker(),
                                ),
                                Positioned(
                                  bottom: 50.h,
                                  left: 110.w,
                                  child: _buildFocusMarker(),
                                ),
                              ],
                            ),
                          ),
                        ),

                      // Bottom Instruction Banner
                      Positioned(
                        bottom: 16.h,
                        left: 20.w,
                        right: 20.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 10.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.55),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            _capturedImagePath != null
                                ? 'Photo ready. Tap Submit scan to proceed.'
                                : 'Frame the fruit and tap capture.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20.h),

                // ==========================================
                // 5. CAMERA CAPTURE CONTROLS
                // ==========================================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Gallery Shortcut
                    InkWell(
                      onTap: _pickFromGallery,
                      borderRadius: BorderRadius.circular(14.r),
                      child: Container(
                        height: 50.r,
                        width: 50.r,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14.r),
                          border: Border.all(
                            color: AppColors.cardBorder,
                            width: 1.w,
                          ),
                        ),
                        child: Icon(
                          Icons.image_outlined,
                          size: 24.r,
                          color: AppColors.primaryText,
                        ),
                      ),
                    ),

                    // Main Capture Action Button
                    InkWell(
                      onTap: _handleCapture,
                      borderRadius: BorderRadius.circular(32.r),
                      child: Container(
                        height: 64.r,
                        width: 64.r,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF99A20), // Orange
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.darkGreen,
                            width: 4.w,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFF99A20).withValues(alpha: 0.4),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          _capturedImagePath != null
                              ? Icons.refresh_rounded
                              : Icons.camera_alt,
                          size: 28.r,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // Switch Camera Shortcut
                    InkWell(
                      onTap: _switchCamera,
                      borderRadius: BorderRadius.circular(14.r),
                      child: Container(
                        height: 50.r,
                        width: 50.r,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14.r),
                          border: Border.all(
                            color: AppColors.cardBorder,
                            width: 1.w,
                          ),
                        ),
                        child: Icon(
                          Icons.flip_camera_ios_outlined,
                          size: 24.r,
                          color: AppColors.primaryText,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 14.h),

                // Guidance Text
                Center(
                  child: Text(
                    'Shoot in even daylight and avoid fast movement.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ),

                SizedBox(height: 20.h),

                // ==========================================
                // 6. SUBMIT SCAN BUTTON
                // ==========================================
                SizedBox(
                  width: double.infinity,
                  height: 52.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkGreen,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shadowColor: Colors.black.withValues(alpha: 0.15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                    onPressed: _handleSubmitScan,
                    child: Text(
                      'Submit scan',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepChip(String label, {required bool isActive}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFFFFE8C7)
            : const Color(0xFFEAF1E9),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
          color: isActive
              ? const Color(0xFFB5623B)
              : AppColors.darkGreen,
        ),
      ),
    );
  }

  Widget _buildSourceTab({
    required String modeKey,
    required String label,
    required IconData iconData,
  }) {
    final isSelected = _selectedSource == modeKey;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedSource = modeKey;
          if (modeKey == 'Gallery') {
            _pickFromGallery();
          } else if (modeKey == 'Video') {
            _showDemoMessage('Demo mode: video capture is not connected yet.');
          }
        });
      },
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFE8C7) : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? const Color(0xFFF99A20) : AppColors.cardBorder,
            width: isSelected ? 1.5.w : 1.w,
          ),
        ),
        child: Column(
          children: [
            Icon(
              iconData,
              size: 20.r,
              color: isSelected ? AppColors.darkGreen : AppColors.primaryText,
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.darkGreen : AppColors.primaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFocusMarker() {
    return Container(
      height: 28.r,
      width: 28.r,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(
          color: const Color(0xFFF99A20),
          width: 2.w,
        ),
      ),
    );
  }
}
