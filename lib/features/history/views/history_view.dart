import 'package:enjoy_app/core/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class HistoryView extends StatefulWidget {
  static const String routeName = 'HistoryView';
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Gap(50),
        Container(
          width: 500.w,
          height: 100.h,
          decoration: BoxDecoration(
            color: AppColors.redColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      
                    });
                    for (var item in categories) {
                      item.isSelected = false;
                    }
                    categories[index].isSelected = true;
                  },
                  child: Container(
                    width: 120,
                    height: 50,
                    decoration: BoxDecoration(
                      color: categories[index].isSelected
                          ? AppColors.greenColor
                          : AppColors.greyColor,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Center(
                      child: Text(
                        categories[index].text,
                        style: TextStyle(
                          fontSize: 18,
                          color: categories[index].isSelected
                              ? AppColors.whiteColor
                              : AppColors.blackColor,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class Category {
  String text;
  bool isSelected;

  Category({required this.text, required this.isSelected});
}

List<Category> categories = [
  Category(text: 'one', isSelected: true),
  Category(text: 'two', isSelected: true),
  Category(text: 'three', isSelected: false),
  Category(text: 'four', isSelected: false),
];
