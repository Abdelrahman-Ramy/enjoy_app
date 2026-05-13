import 'package:enjoy_app/core/constant/app_colors.dart';
import 'package:enjoy_app/core/constant/app_styles.dart';
import 'package:enjoy_app/core/widgets/app_text_button.dart';
import 'package:enjoy_app/features/home/widgets/custom_card_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class StartSessionBottomSheet extends StatefulWidget {
  final Function(int index, String type, Duration duration) onSelect;

  const StartSessionBottomSheet({super.key, required this.onSelect});

  @override
  State<StartSessionBottomSheet> createState() =>
      _StartSessionBottomSheetState();
}

class _StartSessionBottomSheetState extends State<StartSessionBottomSheet> {
  int selectedIndex = -1;
  String? selectedType;
  Duration totalDuration = Duration.zero;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),      ),
      child: Padding(
        padding: EdgeInsets.all(8.r),
        child: Column(
          children: [
            Gap(10.h),
            Text('Select Time', style: AppStyle.font25WhiteBold),
            Gap(15.h),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                children: [
                  CustomCardTime(
                    timeType: '1/2',
                    index: 0,
                    isSelected: selectedIndex == 0,
                    onTap: () {
                      setState(() {
                        selectedIndex = 0;
                        selectedType = "fixed";
                        totalDuration = const Duration(minutes: 30);
                      });
                    },
                  ),
                  CustomCardTime(
                    timeType: '1',
                    index: 1,
                    isSelected: selectedIndex == 1,
                    onTap: () {
                      setState(() {
                        selectedIndex = 1;
                        selectedType = "fixed";
                        totalDuration = const Duration(hours: 1);
                      });
                    },
                  ),
                  CustomCardTime(
                    timeType: '2',
                    index: 2,
                    isSelected: selectedIndex == 2,
                    onTap: () {
                      setState(() {
                        selectedIndex = 2;
                        selectedType = "fixed";
                        totalDuration = const Duration(hours: 2);
                      });
                    },
                  ),
                  CustomCardTime(
                    timeType: 'Open',
                    index: 3,
                    isSelected: selectedIndex == 3,
                    onTap: () {
                      setState(() {
                        selectedIndex = 3;
                        selectedType = "open";
                      });
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
              child: AppTextButton(
                backgroundColor: AppColors.pinkColor,
                buttonText: 'Start',
                textStyle: AppStyle.font35WhiteBold.copyWith(fontSize: 28.sp),
                onPressed: () {
                  if (selectedType == null) return;
                  widget.onSelect(selectedIndex, selectedType!, totalDuration);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
