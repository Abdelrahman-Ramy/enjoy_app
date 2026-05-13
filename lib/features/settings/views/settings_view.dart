import 'package:enjoy_app/core/constant/app_colors.dart';
import 'package:enjoy_app/core/constant/app_styles.dart';
import 'package:enjoy_app/core/utils/session_prefs.dart';
import 'package:enjoy_app/features/home/widgets/show_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class SettingsView extends StatelessWidget {
  static const String routeName = 'SettingsView';
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,

        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            CupertinoIcons.back,
            size: 26.w,
            color: AppColors.whiteColor,
          ),
        ),

        title: Text(
          'Setting',
          style: AppStyle.font24PrimaryBold.copyWith(
            color: AppColors.whiteColor,
            fontSize: 30.sp,
          ),
        ),
      ),
      body: Column(
        children: [
          Gap(30.h),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.redColor,
                foregroundColor: AppColors.redColor,
              ),
              onPressed: () {
                showClearHistoryConfirmation(context, () async {
                  await SharedPrefService.clearHistory();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("History Cleared Successfully"),
                      ),
                    );
                  }
                });
              },
              child: Text(
                'Clear History',
                style: AppStyle.font18GreyW500.copyWith(
                  color: AppColors.whiteColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
