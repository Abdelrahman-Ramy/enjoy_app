import 'package:enjoy_app/core/constant/app_colors.dart';
import 'package:enjoy_app/core/constant/app_styles.dart';
import 'package:enjoy_app/core/widgets/app_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class PlaystationTypeBottomSheet extends StatefulWidget {
  final Function(String type) onSelect;

  const PlaystationTypeBottomSheet({super.key, required this.onSelect});

  @override
  State<PlaystationTypeBottomSheet> createState() =>
      _PlaystationTypeBottomSheetState();
}

class _PlaystationTypeBottomSheetState
    extends State<PlaystationTypeBottomSheet> {
  String? selectedType;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          children: [
            Text(
              'Select Game Mode',
              style: AppStyle.font24PrimaryBold.copyWith(
                color: AppColors.whiteColor,
                fontSize: 22.sp,
              ),
            ),
            Gap(30.h),
            Expanded(
              child: Row(
                children: [
                  // SINGLE
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedType = 'single';
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: selectedType == 'single'
                                ? AppColors.pinkColor
                                : AppColors.darkPrimaryColor,
                            width: 2,
                          ),
                          color: AppColors.darkPrimaryColor,
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'SINGLE',
                              style: AppStyle.font24PrimaryBold.copyWith(
                                color: AppColors.whiteColor,
                                fontSize: 20.sp,
                              ),
                            ),
                            Gap(10.h),
                            Text(
                              '25 EGP/h',
                              style: AppStyle.font18GreyW500.copyWith(
                                color: Colors.greenAccent,
                                fontSize: 16.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Gap(15.w),
                  // MULTI
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedType = 'multi';
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: selectedType == 'multi'
                                ? AppColors.pinkColor
                                : AppColors.darkPrimaryColor,
                            width: 2,
                          ),
                          color: AppColors.darkPrimaryColor,
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'MULTI',
                              style: AppStyle.font24PrimaryBold.copyWith(
                                color: AppColors.whiteColor,
                                fontSize: 20.sp,
                              ),
                            ),
                            Gap(10.h),
                            Text(
                              '30 EGP/h',
                              style: AppStyle.font18GreyW500.copyWith(
                                color: Colors.greenAccent,
                                fontSize: 16.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Gap(20.h),
            AppTextButton(
              buttonText: 'CONFIRM',
              backgroundColor: selectedType != null
                  ? AppColors.greenColor
                  : AppColors.greyColor,
              textStyle: AppStyle.font18WhiteW500,
              onPressed: selectedType != null
                  ? () {
                      Navigator.pop(context);
                      widget.onSelect(selectedType!);
                    }
                  : () {},
            ),
          ],
        ),
      ),
    );
  }
}
