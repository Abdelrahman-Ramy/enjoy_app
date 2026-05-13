import 'package:enjoy_app/core/constant/app_colors.dart';
import 'package:enjoy_app/core/constant/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomOrderTextField extends StatelessWidget {
  final TextEditingController nameController;
  final String hintText;
  final TextInputType keyboardType;
  final int? maxLine;
  final String? prefixText;
  const CustomOrderTextField({
    required this.hintText,
    required this.nameController,
    super.key,
    this.maxLine,
    this.prefixText,
    required this.keyboardType
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: maxLine,
      controller: nameController,
      style: AppStyle.font20BlackW500.copyWith(color: AppColors.whiteColor),
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppStyle.font15GreyW500,
        prefixText: prefixText,
        prefixStyle: AppStyle.font15GreyW500,
        filled: true,
        fillColor: AppColors.primaryColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      ),
    );
  }
}
