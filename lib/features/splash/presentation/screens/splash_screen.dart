import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/screens/welcome_role_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // Step 1: Logo Fade & Scale
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _logoScaleAnimation;

  // Step 2: Logo Shift Left (Row Shift Offset)
  late Animation<Offset> _rowShiftAnimation;

  // Step 3: Text Fade & Slide In
  late Animation<double> _textFadeAnimation;
  late Animation<Offset> _textSlideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );

    // Step 1: Logo Fade & Scale (0ms to 900ms)
    _logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.28, curve: Curves.easeOut),
      ),
    );

    _logoScaleAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.28, curve: Curves.easeOutBack),
      ),
    );

    // Step 2: Shift Row to move logo smoothly to final left position (900ms to 1700ms)
    _rowShiftAnimation = Tween<Offset>(
      begin: const Offset(0.28, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.28, 0.55, curve: Curves.easeInOutCubic),
      ),
    );

    // Step 3: Text Fade In & Slide In from right (1700ms to 2400ms)
    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.55, 0.78, curve: Curves.easeOut),
      ),
    );

    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0.3, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.55, 0.78, curve: Curves.easeOutCubic),
      ),
    );

    // Status listener to navigate once animation completes
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _navigateToNextScreen();
      }
    });

    // Start animation sequence
    _controller.forward();
  }

  void _navigateToNextScreen() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const WelcomeRoleScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return SlideTransition(
                position: _rowShiftAnimation,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // --- ORIVIS Logo ---
                    FadeTransition(
                      opacity: _logoFadeAnimation,
                      child: ScaleTransition(
                        scale: _logoScaleAnimation,
                        child: Image.asset(
                          AppAssets.logo,
                          height: 95.h,
                          width: 95.w,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.eco,
                              size: 95.r,
                              color: AppColors.darkGreen,
                            );
                          },
                        ),
                      ),
                    ),

                    SizedBox(width: 16.w),

                    // --- ORIVIS Animated Text ---
                    FadeTransition(
                      opacity: _textFadeAnimation,
                      child: SlideTransition(
                        position: _textSlideAnimation,
                        child: Text(
                          'ORIVIS',
                          style: TextStyle(
                            fontSize: 36.sp,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 3.5,
                            color: AppColors.darkGreen,
                            fontFamily: 'sans-serif',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
