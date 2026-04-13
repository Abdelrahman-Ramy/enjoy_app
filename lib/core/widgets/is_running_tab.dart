import 'package:enjoy_app/core/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IsRunningTab extends StatefulWidget {
  final Function(int) onChanged;
  const IsRunningTab({super.key, required this.onChanged});

  @override
  State<IsRunningTab> createState() => _IsRunningTabState();
}

class _IsRunningTabState extends State<IsRunningTab> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final titles = ['All', 'Available', 'Running'];
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: List.generate(3, (index) {
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
                widget.onChanged(index);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                decoration: BoxDecoration(
                  color: selectedIndex == index
                      ? AppColors.pinkColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Center(
                  child: Text(
                    titles[index],
                    style: TextStyle(
                      color: selectedIndex == index
                          ? Colors.white
                          : AppColors.greyColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
