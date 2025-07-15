import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:quron_app/feautures/view/screens/star_painter.dart';
import 'package:quron_app/gen/assets.gen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  void _checkLogin() async {
    await Future.delayed(const Duration(seconds: 4)); // loading uchun delay

    final user = FirebaseAuth.instance.currentUser;

    if (!mounted) return;

    if (user != null) {
      context.go('/home');
    } else {
      context.go('/log_in');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Animate(
        effects: [
          FadeEffect(duration: 600.ms),
          SlideEffect(
            begin: const Offset(0, 0.3),
            end: Offset.zero,
            duration: 1000.ms,
            curve: Curves.easeOutBack,
          ),
        ],
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF010E36), Color(0xFF081243)],
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              const AnimatedStarsLayer(),
              Assets.images.splashLogo.svg(),
              Positioned(
                bottom: 220.h,
                child: Text(
                  'Quran Kareem',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                bottom: 0.h,
                left: 0.w,
                right: 0.w,
                child: Assets.images.splashBottom.svg(
                  fit: BoxFit.cover,
                  colorFilter: const ColorFilter.mode(
                    Colors.black,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
