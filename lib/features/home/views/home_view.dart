import 'package:enjoy_app/core/constant/app_colors.dart';
import 'package:enjoy_app/core/constant/app_styles.dart';
import 'package:enjoy_app/features/home/views/billiards_body.dart';
import 'package:enjoy_app/features/home/views/ping_pong_body.dart';
import 'package:enjoy_app/features/home/views/playstation_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class HomeView extends StatefulWidget {
  static const String routeName = 'HomeScreen';

  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          leading: Icon(
            Icons.menu,
            fontWeight: FontWeight.bold,
            size: 26.sp,
            color: AppColors.whiteColor,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.settings,
                size: 28.sp,
                color: AppColors.whiteColor,
              ),
            ),
          ],
          elevation: 0,
          centerTitle: true,
          title: Text(
            'ENJOY',
            style: AppStyle.font24PrimaryBold.copyWith(
              color: AppColors.whiteColor,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            children: [
              Gap(5.h),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  children: List.generate(3, (index) {
                    final titles = ['PLAYSTATION', 'BILLIARDS', 'PING PONG'];
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 3.w,
                            vertical: 5.h,
                          ),
                          child: Container(
                            width: 150.w,
                            height: 50.h,
                            decoration: BoxDecoration(
                              border: BoxBorder.all(
                                color: selectedIndex == index
                                    ? AppColors.pinkColor
                                    : AppColors.darkPrimaryColor,
                              ),
                              color: selectedIndex == index
                                  ? AppColors.darkPrimaryColor
                                  : AppColors.darkPrimaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                titles[index],
                                style: TextStyle(
                                  fontSize: 18,
                                  color: selectedIndex == index
                                      ? AppColors.whiteColor
                                      : AppColors.greyColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              Expanded(
                child: selectedIndex == 0
                    ? const PlaystationBody()
                    : selectedIndex == 1
                    ? const BilliardsBody()
                    : const PingPongBody(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
