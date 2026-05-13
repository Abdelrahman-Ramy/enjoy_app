import 'package:enjoy_app/core/constant/app_colors.dart';
import 'package:enjoy_app/core/constant/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

void showEndSessionConfirmation(BuildContext context, VoidCallback onConfirm) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: AppColors.darkPrimaryColor,
        title: const Text(
          "End Session",
          style: TextStyle(color: AppColors.whiteColor),
          textAlign: TextAlign.center,
        ),
        content: const Text(
          "Do you want to end this session?",
          style: TextStyle(color: AppColors.whiteColor),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "No",
              style: AppStyle.font15GreyW500.copyWith(
                color: AppColors.whiteColor,
              ),
            ),
          ),
          TextButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(AppColors.pinkColor),
            ),
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: Text(
              "Yes",
              style: AppStyle.font15GreyW500.copyWith(
                color: AppColors.whiteColor,
              ),
            ),
          ),
        ],
      );
    },
  );
}

void showClearHistoryConfirmation(
  BuildContext context,
  VoidCallback onConfirm,
) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: AppColors.darkPrimaryColor,
        title: const Text(
          "Clear History",
          style: TextStyle(color: AppColors.whiteColor),
          textAlign: TextAlign.center,
        ),
        content: const Text(
          "Are you sure you want to clear all history? This action cannot be undone.",
          style: TextStyle(color: AppColors.whiteColor),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: AppStyle.font15GreyW500.copyWith(
                color: AppColors.whiteColor,
              ),
            ),
          ),
          TextButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(AppColors.redColor),
            ),
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: Text(
              "Clear",
              style: AppStyle.font15GreyW500.copyWith(
                color: AppColors.whiteColor,
              ),
            ),
          ),
        ],
      );
    },
  );
}

void showSummaryDialog(
  BuildContext context,
  Duration duration, {
  double? totalPrice,
  List? orders,
}) {
  // Calculate orders total
  double ordersTotal = 0;
  if (orders != null) {
    for (final order in orders) {
      ordersTotal += order.price;
    }
  }

  // Calculate base price: if totalPrice is provided, subtract orders; otherwise calculate from duration
  final basePriceDisplay = totalPrice != null
      ? (totalPrice - ordersTotal)
      : calculatePrice(duration);

  final totalDisplayPrice = totalPrice ?? calculatePrice(duration);

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
            // ORDERS PRICE
            if (ordersTotal > 0)
              Text(
                "Orders: ${ordersTotal.toStringAsFixed(2)} EGP",
                style: AppStyle.font18WhiteW500.copyWith(
                  color: Colors.orangeAccent,
                ),
              ),
            if (ordersTotal > 0) Gap(6.h),
            // SESSION BASE PRICE
            Text(
              "Session: ${basePriceDisplay.toStringAsFixed(2)} EGP",
              style: AppStyle.font18WhiteW500.copyWith(
                color: Colors.blueAccent,
              ),
            ),
            Gap(6.h),
            // TOTAL PRICE
            Text(
              "Total: ${totalDisplayPrice.toStringAsFixed(2)} EGP",
              style: AppStyle.font18WhiteW500.copyWith(
                color: AppColors.greenLightColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(AppColors.pinkColor),
            ),
            onPressed: () => Navigator.pop(context),
            child: Text(
              "OK",
              style: AppStyle.font15GreyW500.copyWith(
                color: AppColors.whiteColor,
              ),
            ),
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
