import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class StatusWidget extends StatelessWidget {
  final bool isRunning;
  const StatusWidget({super.key, required this.isRunning});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isRunning == true
            ? Colors.red.withOpacity(0.1)
            : Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(
          color: isRunning == true
              ? Colors.red.withOpacity(0.5)
              : Colors.green.withOpacity(0.5),
          width: 1.5.w,
        ),
        boxShadow: [
          BoxShadow(
            color: isRunning == true
                ? Colors.red.withOpacity(0.2)
                : Colors.green.withOpacity(0.2),
            blurRadius: 10.r,
            spreadRadius: 2.r,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10.w,
            height: 10.h,
            decoration: BoxDecoration(
              color: isRunning == true
                  ? Colors.redAccent
                  : Colors.greenAccent,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: isRunning == true ?
                  Colors.redAccent.withOpacity(0.8):
                   Colors.greenAccent.withOpacity(0.8),
                  blurRadius: 8.r,
                  spreadRadius: 1.r,
                ),
              ],
            ),
          ),
          Gap(12.w),
          Text(
            isRunning == true ?
            'RUNNING':
            'AVAILABLE',
            style: TextStyle(
              color: isRunning == true ?
              Colors.redAccent:
              Colors.greenAccent,
              fontWeight: FontWeight.bold,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}
