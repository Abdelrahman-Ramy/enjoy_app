import 'package:enjoy_app/core/constant/app_colors.dart';
import 'package:enjoy_app/core/utils/session_prefs.dart';
import 'package:enjoy_app/features/history/views/history_view.dart';
import 'package:enjoy_app/features/home/views/home_view.dart';
import 'package:enjoy_app/features/settings/views/settings_view.dart';
import 'package:enjoy_app/shared/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      child: MaterialApp(
        theme: ThemeData(
          splashColor: Colors.transparent,
          scaffoldBackgroundColor: AppColors.primaryColor,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: SplashScreen.routeName,
        routes: {
          SplashScreen.routeName: (context) => const SplashScreen(),
          HomeView.routeName: (context) => const HomeView(),
          HistoryView.routeName: (context) => const HistoryView(),
          SettingsView.routeName: (context) => const SettingsView(),
        },
      ),
    );
  }
}
