import 'package:enjoy_app/core/constant/app_colors.dart';
import 'package:enjoy_app/core/constant/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PriceCalculator extends StatelessWidget {
  final Duration duration;
  final double pricePerHour;

  const PriceCalculator({
    super.key,
    required this.duration,
    required this.pricePerHour,
  });

  double get totalPrice {
    final hours = duration.inMinutes / 60;
    return hours * pricePerHour;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "Price: ${totalPrice.toStringAsFixed(2)} EGP",
      style: AppStyle.font20BlackW500.copyWith(
        color: AppColors.greenLightColor,
        fontSize: 18.sp,
      ),
    );
  }
}
