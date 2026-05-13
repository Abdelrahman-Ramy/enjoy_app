import 'package:enjoy_app/core/constant/app_colors.dart';
import 'package:enjoy_app/core/constant/app_styles.dart';
import 'package:enjoy_app/features/home/widgets/order_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

/// Widget to display a list of orders added to a session
///
/// Shows:
/// - Order name
/// - Order price
/// - Optional note
/// - Delete button to remove the order
///
/// Usage:
/// ```dart
/// OrdersList(
///   orders: orders,
///   onRemoveOrder: (index) {
///     setState(() {
///       orders.removeAt(index);
///     });
///   },
/// )
/// ```
class OrdersList extends StatelessWidget {
  final List<OrderModel> orders;
  final Function(int) onRemoveOrder;

  const OrdersList({
    super.key,
    required this.orders,
    required this.onRemoveOrder,
  });

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return Center(
        child: Text(
          'No orders yet',
          style: AppStyle.font13White500.copyWith(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];

        return Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(10.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ORDER DETAILS
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product name
                      Text(
                        order.name,
                        style: AppStyle.font16WhiteW500,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // Note (if exists)
                      if (order.note != null && order.note!.isNotEmpty) ...[
                        Gap(4.h),
                        Text(
                          order.note!,
                          style: AppStyle.font15GreyW400,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ],
                  ),
                ),

                Gap(8.w),

                // PRICE
                Text(
                  '\$${order.price.toStringAsFixed(2)}',
                  style: AppStyle.font16WhiteW500.copyWith(
                    color: AppColors.greenColor,
                  ),
                ),

                Gap(8.w),

                // DELETE BUTTON
                GestureDetector(
                  onTap: () => onRemoveOrder(index),
                  child: Container(
                    padding: EdgeInsets.all(6.r),
                    decoration: BoxDecoration(
                      color: AppColors.redColor,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Icon(
                      Icons.close,
                      size: 16.sp,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
