import 'package:enjoy_app/core/constant/app_colors.dart';
import 'package:enjoy_app/core/constant/app_styles.dart';
import 'package:enjoy_app/core/widgets/app_text_button.dart';
import 'package:enjoy_app/features/home/widgets/status_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class PlaystationCard extends StatelessWidget {
  final String deviceNumber;
  final String cardName;
  final bool isType;
  final bool isRunning;
  const PlaystationCard({
    super.key,
    required this.deviceNumber,
    required this.isRunning,
    required this.cardName,
    this.isType = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Container(
        width: double.infinity,
        height: isRunning == true ? 280.h : 200.h,
        decoration: BoxDecoration(
          color: AppColors.darkPrimaryColor,
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(cardName, style: AppStyle.font18WhiteW500),
                  StatusWidget(isRunning: isRunning),
                ],
              ),
              isType == true
                  ? Text(
                      ' PS  #$deviceNumber',
                      style: AppStyle.font40WhiteBold,
                    )
                  : Text(
                      ' Table  #$deviceNumber',
                      style: AppStyle.font40WhiteBold,
                    ),
              Gap(15.h),
              isRunning == true
                  ? Container(
                      width: double.infinity,
                      height: 90.h,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Time', style: AppStyle.font18GreyW500),
                            Text(
                              '01:45:22',
                              style: AppStyle.font40WhiteBold.copyWith(
                                fontSize: 33.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Gap(1.h),
              Gap(15.h),
              isRunning == true
                  ? AppTextButton(
                      buttonText: 'END SECTION',
                      backgroundColor: AppColors.redColor,
                      textStyle: AppStyle.font18WhiteW500,
                      onPressed: () {},
                    )
                  : AppTextButton(
                      buttonText: 'START SECTION',
                      backgroundColor: AppColors.greenColor,
                      textStyle: AppStyle.font18WhiteW500,
                      onPressed: () {},
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
