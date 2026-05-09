import 'package:enjoy_app/core/constant/app_colors.dart';
import 'package:enjoy_app/core/constant/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

void showSummaryDialog(BuildContext context, Duration duration) {
  final price = calculatePrice(duration);
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: AppColors.darkPrimaryColor,
        title: const Text(
          "Session Summary",
          style: TextStyle(color: AppColors.whiteColor),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
        Gap(5.h),
            Text(
              "Time: ${duration.inHours.toString().padLeft(2, '0')}:"
              "${(duration.inMinutes % 60).toString().padLeft(2, '0')}:"
              "${(duration.inSeconds % 60).toString().padLeft(2, '0')}",
              style: AppStyle.font18WhiteW500,
            ),
            Gap(10.h),
            Text(
              "Price: ${price.toStringAsFixed(2)} EGP",
              style:  AppStyle.font18WhiteW500.copyWith(color: AppColors.greenLightColor)
            ),
          ],
        ),
        actions: [
          TextButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(AppColors.pinkColor)
            ),
            onPressed: () => Navigator.pop(context),
            child: Text("OK",style: AppStyle.font15GreyW500.copyWith(color: AppColors.whiteColor),),
          ),
        ],
      );
    },
  );
}


double calculatePrice(Duration duration) {
  final hours = duration.inMinutes / 60;
  return hours * 20;
}