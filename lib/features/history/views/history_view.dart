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
                    padding: EdgeInsets.all(15.r),
                    decoration: BoxDecoration(
                      color: selectedDate == dateKey
                          ? AppColors.primaryColor
                          : AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        width: 2,
                        color: selectedDate == dateKey
                            ? AppColors.pinkColor
                            : AppColors.darkPrimaryColor,
                      ),
                    ),
                    child: Text(
                      _formatDateHeader(dateKey),
                      textAlign: TextAlign.center,
                      style: AppStyle.font18GreyW500.copyWith(
                        color: selectedDate == dateKey
                            ? AppColors.whiteColor
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
                                    color: AppColors.whiteColor,
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
                              color: AppColors.darkPrimaryColor,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // DEVICE NAME WITH PLAYSTATION TYPE
                                Builder(
                                  builder: (context) {
                                    // Display PlayStation type if available
                                    String deviceLabel = session.name;
                                    Color labelColor = AppColors.whiteColor;

                                    if (session.psGameType != null) {
                                      deviceLabel =
                                          "${session.name} - ${session.psGameType}";
                                      labelColor = session.psGameType == "multi"
                                          ? Colors.purpleAccent
                                          : Colors.blueAccent;
                                    }

                                    return Text(
                                      deviceLabel,
                                      style: AppStyle.font24PrimaryBold
                                          .copyWith(color: labelColor),
                                    );
                                  },
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
                                // DURATION - Format based on length
                                Builder(
                                  builder: (context) {
                                    final hours = session.duration ~/ 60;
                                    final minutes = session.duration % 60;

                                    String durationText;
                                    if (session.duration < 60) {
                                      // Less than 1 hour: show as minutes
                                      durationText = "${session.duration} min";
                                    } else if (minutes == 0) {
                                      // Exact hours
                                      durationText = "$hours h";
                                    } else {
                                      // Hours and minutes
                                      durationText = "${hours}h ${minutes}m";
                                    }

                                    return Text(
                                      "Duration: $durationText",
                                      style: AppStyle.font18GreyW500,
                                    );
                                  },
                                ),
                                Gap(6.h),
                                // CALCULATE PRICES
                                Builder(
                                  builder: (context) {
                                    // Calculate orders total
                                    double ordersTotal = 0;
                                    for (final order in session.orders) {
                                      ordersTotal += order.price;
                                    }

                                    // Base price = stored total - orders
                                    final basePrice =
                                        session.price - ordersTotal;

                                    // Total price = base + orders
                                    final totalPrice = session.price;

                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // ORDERS DETAILS
                                        if (session.orders.isNotEmpty) ...[
                                          Text(
                                            "Orders:",
                                            style: AppStyle.font18GreyW500
                                                .copyWith(
                                                  color: Colors.orangeAccent,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          Gap(3.h),
                                          ...session.orders.map((order) {
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                bottom: 2.h,
                                                left: 8.w,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "• ${order.name} : ${order.price.toStringAsFixed(2)}",
                                                    style: AppStyle
                                                        .font16WhiteW500
                                                        .copyWith(
                                                          color: Colors
                                                              .orangeAccent,
                                                        ),
                                                  ),
                                                  Text(
                                                    "• note: ${order.note ?? "...."}",
                                                    style: AppStyle
                                                        .font16WhiteW500
                                                        .copyWith(
                                                          color: Colors
                                                              .orangeAccent,
                                                        ),
                                                  ),
                                                  const Divider(thickness: 0.5),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                          Gap(6.h),
                                        ],
                                        // SESSION BASE PRICE
                                        Text(
                                          "Session: ${basePrice.toStringAsFixed(2)} EGP",
                                          style: AppStyle.font18GreyW500
                                              .copyWith(
                                                color: Colors.blueAccent,
                                              ),
                                        ),
                                        Gap(4.h),
                                        // TOTAL PRICE
                                        Text(
                                          "Total: ${totalPrice.toStringAsFixed(2)} EGP",
                                          style: AppStyle.font20BlackW500
                                              .copyWith(
                                                color: Colors.greenAccent,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ],
                                    );
                                  },
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
