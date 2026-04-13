import 'dart:async';
import 'package:enjoy_app/core/constant/app_colors.dart';
import 'package:enjoy_app/core/constant/app_styles.dart';
import 'package:enjoy_app/core/widgets/app_text_button.dart';
import 'package:enjoy_app/features/home/widgets/custom_card_time.dart';
import 'package:enjoy_app/features/home/widgets/status_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class PlaystationCard extends StatefulWidget {
  final String deviceNumber;
  final String cardName;
  final bool isType;

  const PlaystationCard({
    super.key,
    required this.deviceNumber,
    required this.cardName,
    this.isType = true,
  });

  @override
  State<PlaystationCard> createState() => _PlaystationCardState();
}

class _PlaystationCardState extends State<PlaystationCard>
    with WidgetsBindingObserver {
  Duration elapsed = Duration.zero;
  bool isRunning = false;
  DateTime? startTime;
  Timer? timer;
  String? selectedType;
  Duration totalDuration = Duration.zero;
  int selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    loadSession();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      timer?.cancel();
    }

    if (state == AppLifecycleState.resumed) {
      loadSession();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    timer?.cancel();

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;

      if (startTime == null) return; // 🔴 FIX 1 (crash protection)

      setState(() {
        final diff = DateTime.now().difference(startTime!);

        if (selectedType == "open") {
          elapsed = diff;
        } else if (selectedType == "fixed") {
          final remaining = totalDuration - diff;

          if (remaining.isNegative) {
            timer?.cancel();
            isRunning = false;
            elapsed = Duration.zero;
          } else {
            elapsed = remaining;
          }
        }
      });
    });
  }

  Future<void> saveSession() async {
    final pref = await SharedPreferences.getInstance();

    await pref.setInt(
      "start_${widget.deviceNumber}",
      startTime!.millisecondsSinceEpoch,
    );

    await pref.setString("type_${widget.deviceNumber}", selectedType ?? "open");

    await pref.setInt(
      "duration_${widget.deviceNumber}",
      totalDuration.inSeconds,
    );

    await pref.setInt("index_${widget.deviceNumber}", selectedIndex);
  }

  Future<void> loadSession() async {
    final pref = await SharedPreferences.getInstance();

    final start = pref.getInt("start_${widget.deviceNumber}");
    final type = pref.getString("type_${widget.deviceNumber}");
    final duration = pref.getInt("duration_${widget.deviceNumber}");
    final index = pref.getInt("index_${widget.deviceNumber}");

    if (start != null) {
      startTime = DateTime.fromMillisecondsSinceEpoch(start);
      selectedType = type;
      selectedIndex = index ?? -1;
      totalDuration = Duration(seconds: duration ?? 0);
      isRunning = true;

      startTimer();
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final diff = startTime == null
        ? Duration.zero
        : DateTime.now().difference(startTime!);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: Container(
        width: double.infinity,
        height: isRunning == true ? 350.h : 230.h,
        decoration: BoxDecoration(
          color: AppColors.darkPrimaryColor,
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.cardName, style: AppStyle.font18WhiteW500),
                  StatusWidget(isRunning: isRunning),
                ],
              ),
              widget.isType
                  ? Text(
                      ' PS  #${widget.deviceNumber}',
                      style: AppStyle.font40WhiteBold,
                    )
                  : Text(
                      ' Table  #${widget.deviceNumber}',
                      style: AppStyle.font40WhiteBold,
                    ),
              Gap(5.h),

              isRunning
                  ? Container(
                      width: double.infinity,
                      height: 120.h,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Gap(8.h),
                            Text('Time', style: AppStyle.font18GreyW500),
                            Gap(5.h),
                            Text(
                              "${elapsed.inHours.toString().padLeft(2, '0')}:"
                              "${(elapsed.inMinutes % 60).toString().padLeft(2, '0')}:"
                              "${(elapsed.inSeconds % 60).toString().padLeft(2, '0')}",
                              style: AppStyle.font40WhiteBold.copyWith(
                                fontSize: 33.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Gap(1.h),

              Gap(30.h),

              isRunning
                  ? AppTextButton(
                      buttonText: 'END SECTION',
                      backgroundColor: AppColors.redColor,
                      textStyle: AppStyle.font18WhiteW500,
                      onPressed: () {
                        timer?.cancel();

                        final finalDuration = startTime == null
                            ? Duration.zero
                            : DateTime.now().difference(startTime!);

                        showSummaryDialog(context, finalDuration);

                        setState(() {
                          isRunning = false;
                          startTime = null;
                          elapsed = Duration.zero;
                        });
                      },
                    )
                  : AppTextButton(
                      buttonText: 'START SECTION',
                      backgroundColor: AppColors.greenColor,
                      textStyle: AppStyle.font18WhiteW500,
                      onPressed: () {
                        showBottomSheet(
                          elevation: 0,
                          backgroundColor: AppColors.primaryColor,
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (context, sheetSetState) {
                                return Container(
                                  height: 500.h,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  child: Column(
                                    children: [
                                      Gap(20.h),

                                      Expanded(
                                        child: GridView.count(
                                          crossAxisCount: 2,
                                          childAspectRatio: 1.4,
                                          children: [
                                            CustomCardTime(
                                              timeType: '1/2',
                                              index: 0,
                                              isSelected: selectedIndex == 0,
                                              onTap: () {
                                                sheetSetState(() {
                                                  selectedIndex = 0;
                                                  selectedType = "fixed";
                                                  totalDuration =
                                                      const Duration(
                                                        minutes: 30,
                                                      );
                                                });
                                              },
                                            ),
                                            CustomCardTime(
                                              timeType: '1',
                                              index: 1,
                                              isSelected: selectedIndex == 1,
                                              onTap: () {
                                                sheetSetState(() {
                                                  selectedIndex = 1;
                                                  selectedType = "fixed";
                                                  totalDuration =
                                                      const Duration(hours: 1);
                                                });
                                              },
                                            ),
                                            CustomCardTime(
                                              timeType: '2',
                                              index: 2,
                                              isSelected: selectedIndex == 2,
                                              onTap: () {
                                                sheetSetState(() {
                                                  selectedIndex = 2;
                                                  selectedType = "fixed";
                                                  totalDuration =
                                                      const Duration(hours: 2);
                                                });
                                              },
                                            ),
                                            CustomCardTime(
                                              timeType: 'Open',
                                              index: 3,
                                              isSelected: selectedIndex == 3,
                                              onTap: () {
                                                sheetSetState(() {
                                                  selectedIndex = 3;
                                                  selectedType = "open";
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),

                                      Padding(
                                        padding: EdgeInsets.all(15.w),
                                        child: AppTextButton(
                                          backgroundColor: AppColors.pinkColor,
                                          buttonText: 'Start',
                                          textStyle: AppStyle.font35WhiteBold
                                              .copyWith(fontSize: 30.sp),
                                          onPressed: () async {
                                            final selected = selectedIndex;

                                            Navigator.pop(context);

                                            setState(() {
                                              isRunning = true;
                                              startTime = DateTime.now();
                                              selectedIndex = selected;
                                            });

                                            await saveSession();
                                            startTimer();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

double calculatePrice(Duration duration) {
  final hours = duration.inMinutes / 60;
  return hours * 20;
}

void showSummaryDialog(BuildContext context, Duration duration) {
  final price = calculatePrice(duration);
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.black,
        title: const Text(
          "Session Summary",
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Time: ${duration.inHours.toString().padLeft(2, '0')}:"
              "${(duration.inMinutes % 60).toString().padLeft(2, '0')}:"
              "${(duration.inSeconds % 60).toString().padLeft(2, '0')}",
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              "Price: ${price.toStringAsFixed(2)} EGP",
              style: const TextStyle(
                color: Colors.green,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      );
    },
  );
}
