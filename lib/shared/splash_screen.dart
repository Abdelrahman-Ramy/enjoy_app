import 'package:enjoy_app/core/constant/app_colors.dart';
import 'package:enjoy_app/features/home/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = 'SplashScreen';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, HomeView.routeName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,

      body: Center(
        child: Lottie.asset(
          "assets/animations/Game Controller.json",
          width: 300.h,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
