import 'package:enjoy_app/core/constant/app_colors.dart';
import 'package:enjoy_app/core/constant/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

/// Widget to display price breakdown for a session
///
/// Shows:
/// - Session price (calculated from timer)
/// - Extras total (sum of all orders)
/// - Final total (session + extras)
///
/// Usage:
/// ```dart
/// PriceBreakdownWidget(
///   sessionPrice: 25.50,
///   extrasTotal: 7.50,
/// )
/// ```
class PriceBreakdownWidget extends StatelessWidget {
  final double sessionPrice;
  final double extrasTotal;

  const PriceBreakdownWidget({
    super.key,
    required this.sessionPrice,
    required this.extrasTotal,
  });

  double get totalPrice => sessionPrice + extrasTotal;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(15.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Text('Price', style: AppStyle.font18GreyW500),
          Gap(12.h),

          // SESSION PRICE ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Session Price:', style: AppStyle.font16WhiteW500),
              Text(
                '\$${sessionPrice.toStringAsFixed(2)}',
                style: AppStyle.font16WhiteW500,
              ),
            ],
          ),
          Gap(8.h),

          // EXTRAS TOTAL ROW (Only show if there are extras)
          if (extrasTotal > 0) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Extras Total:',
                  style: AppStyle.font16WhiteW500.copyWith(
                    color: AppColors.greenColor,
                  ),
                ),
                Text(
                  '\$${extrasTotal.toStringAsFixed(2)}',
                  style: AppStyle.font16WhiteW500.copyWith(
                    color: AppColors.greenColor,
                  ),
                ),
              ],
            ),
            Gap(12.h),

            // DIVIDER
            Container(height: 1, color: Colors.grey.withOpacity(0.3)),
            Gap(12.h),
          ],

          // FINAL TOTAL ROW (Highlighted)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Final Total:',
                style: AppStyle.font18WhiteW500.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '\$${totalPrice.toStringAsFixed(2)}',
                style: AppStyle.font18WhiteW500.copyWith(
                  color: AppColors.greenColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
