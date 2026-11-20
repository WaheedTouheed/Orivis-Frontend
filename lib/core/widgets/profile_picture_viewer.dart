import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';

void showProfilePictureViewer({
  BuildContext? context,
  dynamic imageFile,
  String? userName,
  String? name,
  VoidCallback? onChangePhoto,
}) {
  final displayName = userName ?? name;
  if (context == null) return;

  showDialog(
    context: context,
    builder: (dialogContext) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(dialogContext).pop(),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: imageFile is File
                  ? Image.file(
                      imageFile,
                      width: 280.r,
                      height: 280.r,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _defaultAvatar(),
                    )
                  : (imageFile is String && imageFile.isNotEmpty)
                      ? Image.file(
                          File(imageFile),
                          width: 280.r,
                          height: 280.r,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _defaultAvatar(),
                        )
                      : _defaultAvatar(),
            ),
            if (displayName != null && displayName.isNotEmpty) ...[
              SizedBox(height: 16.h),
              Text(
                displayName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
            if (onChangePhoto != null) ...[
              SizedBox(height: 16.h),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  onChangePhoto();
                },
                icon: const Icon(Icons.camera_alt_rounded, size: 18),
                label: const Text('Change Photo'),
              ),
            ],
          ],
        ),
      );
    },
  );
}

Widget _defaultAvatar() {
  return Container(
    width: 280.r,
    height: 280.r,
    color: const Color(0xFFE3EFE6),
    child: Icon(
      Icons.person_rounded,
      size: 120.r,
      color: AppColors.darkGreen,
    ),
  );
}
