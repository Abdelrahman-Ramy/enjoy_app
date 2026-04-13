import 'package:enjoy_app/core/constant/app_colors.dart';
import 'package:enjoy_app/core/constant/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CustomCardTime extends StatelessWidget {
  final String timeType;
  final int index;
  final bool isSelected;
  final VoidCallback onTap;

  const CustomCardTime({
    super.key,
    required this.timeType,
    required this.index,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 140.w,
            height: 110.h,
            decoration: BoxDecoration(
              color: AppColors.darkPrimaryColor,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                width: 3.w,
                color: isSelected ? Colors.pink : AppColors.darkPrimaryColor,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(timeType, style: AppStyle.font35WhiteBold),
                  Gap(3.h),
                  Text('Hour', style: AppStyle.font22GreyW500),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
