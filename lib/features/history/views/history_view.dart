import 'package:enjoy_app/core/constant/app_colors.dart';
import 'package:enjoy_app/core/constant/app_styles.dart';
import 'package:enjoy_app/core/utils/session_prefs.dart';
import 'package:enjoy_app/features/home/widgets/session_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class HistoryView extends StatefulWidget {
  static const String routeName = 'HistoryView';

  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  List<SessionModel> history = [];
  String? selectedDate;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ar');
    loadHistory();
  }

  void loadHistory() {
    history = SharedPrefService.getHistory();
    setState(() {});
  }

  Map<String, List<SessionModel>> _groupSessionsByDate() {
    final grouped = <String, List<SessionModel>>{};

    for (final session in history) {
      final date = DateTime.fromMillisecondsSinceEpoch(session.start);
      final dateKey = DateFormat('yyyy-MM-dd').format(date);

      if (grouped[dateKey] == null) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(session);
    }

    return grouped;
  }

  String _formatDateHeader(String dateKey) {
    final date = DateTime.parse(dateKey);
    return DateFormat('d / M / y').format(date);
  }

  void _showDatePicker() {
    final grouped = _groupSessionsByDate();
    final dates = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkPrimaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Text(
              'Selected Date',
              style: AppStyle.font24PrimaryBold.copyWith(
                color: AppColors.whiteColor,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: dates.length,
              itemBuilder: (context, index) {
                final dateKey = dates[index];
                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedDate = dateKey;
                    });
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: selectedDate == dateKey
                          ? AppColors.pinkColor
                          : AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: selectedDate == dateKey
                            ? AppColors.pinkColor
                            : AppColors.greyColor,
                      ),
                    ),
                    child: Text(
                      _formatDateHeader(dateKey),
                      textAlign: TextAlign.center,
                      style: AppStyle.font18GreyW500.copyWith(
                        color: selectedDate == dateKey
                            ? AppColors.darkPrimaryColor
                            : AppColors.whiteColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

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
          'History',
          style: AppStyle.font24PrimaryBold.copyWith(
            color: AppColors.whiteColor,
            fontSize: 30.sp,
          ),
        ),
      ),

      // BODY
      body: history.isEmpty
          ? const Center(
              child: Text(
                "No Sessions Yet",
                style: TextStyle(color: AppColors.greyColor),
              ),
            )
          : Builder(
              builder: (context) {
                final grouped = _groupSessionsByDate();
                final dates = grouped.keys.toList()
                  ..sort((a, b) => b.compareTo(a));
                final displayDate = selectedDate ?? dates.first;
                final sessions = grouped[displayDate] ?? [];

                return ListView(
                  padding: EdgeInsets.all(12.r),
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // DATE HEADER WITH DATE PICKER
                        GestureDetector(
                          onTap: dates.length > 1 ? _showDatePicker : null,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _formatDateHeader(displayDate),
                                  textAlign: TextAlign.center,
                                  style: AppStyle.font20BlackW500.copyWith(
                                    color: AppColors.pinkColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (dates.length > 1)
                                  Padding(
                                    padding: EdgeInsets.only(left: 8.w),
                                    child: Icon(
                                      Icons.calendar_today,
                                      color: AppColors.pinkColor,
                                      size: 20.sp,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        // SESSIONS FOR THIS DATE
                        ...sessions.map((session) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 12.h),
                            padding: EdgeInsets.all(14.r),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.pinkColor),
                              color: const Color.fromARGB(255, 172, 170, 210),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // DEVICE NAME
                                Text(
                                  session.name,
                                  style: AppStyle.font24PrimaryBold.copyWith(
                                    color: AppColors.whiteColor,
                                  ),
                                ),
                                Gap(10.h),
                                // TIME RANGE
                                Builder(
                                  builder: (context) {
                                    final startTime =
                                        DateTime.fromMillisecondsSinceEpoch(
                                          session.start,
                                        );
                                    final endTime = startTime.add(
                                      Duration(minutes: session.duration),
                                    );
                                    final startFormatted = DateFormat(
                                      'hh:mm a',
                                    ).format(startTime);
                                    final endFormatted = DateFormat(
                                      'hh:mm a',
                                    ).format(endTime);
                                    return Text(
                                      "From $startFormatted | To $endFormatted",
                                      style: AppStyle.font18GreyW500,
                                    );
                                  },
                                ),
                                Gap(10.h),
                                // DURATION
                                Text(
                                  "Duration: ${session.duration} min",
                                  style: AppStyle.font18GreyW500,
                                ),
                                Gap(6.h),
                                // PRICE
                                Text(
                                  "Price: ${session.price.toStringAsFixed(2)} EGP",
                                  style: AppStyle.font20BlackW500.copyWith(
                                    color: Colors.greenAccent,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        Gap(5.h),
                      ],
                    ),
                  ],
                );
              },
            ),
    );
  }
}
