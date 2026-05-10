import 'dart:async';
import 'package:enjoy_app/core/constant/app_colors.dart';
import 'package:enjoy_app/core/constant/app_styles.dart';
import 'package:enjoy_app/core/utils/session_prefs.dart';
import 'package:enjoy_app/core/widgets/app_text_button.dart';
import 'package:enjoy_app/features/home/widgets/calculate_elpased.dart';
import 'package:enjoy_app/features/home/widgets/category_model.dart';
import 'package:enjoy_app/features/home/widgets/playstation_type_bottom_sheet.dart';
import 'package:enjoy_app/features/home/widgets/price_calculator.dart';
import 'package:enjoy_app/features/home/widgets/session_model.dart';
import 'package:enjoy_app/features/home/widgets/show_dialog.dart';
import 'package:enjoy_app/features/home/widgets/start_session_bottom_sheet.dart';
import 'package:enjoy_app/features/home/widgets/status_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

// ignore: must_be_immutable
class PlaystationCard extends StatefulWidget {
  final String deviceNumber;
  final String cardName;
  final String category;
  final bool isType;
  final VoidCallback? onStop;

  const PlaystationCard({
    super.key,
    required this.deviceNumber,
    required this.cardName,
    required this.category,
    this.isType = true,
    this.onStop,
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
  String? psGameType; // 'single' or 'multi' for PlayStation

  String get keyPrefix => "${widget.category}_${widget.deviceNumber}";

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

    timer = Timer.periodic(const Duration(seconds: 1), (_) async {
      if (!mounted || startTime == null) return;

      Duration newElapsed = calculateElapsed(
        startTime: startTime!,
        selectedType: selectedType,
        totalDuration: totalDuration,
      );

      // Check if session ended automatically (for fixed sessions)
      if (selectedType == "fixed" && newElapsed == Duration.zero && isRunning) {
        timer?.cancel();

        final session = SharedPrefService.getSession(keyPrefix);
        if (session != null) {
          final pricePerHour = getPricePerHour();
          final finalDuration = totalDuration; // Fixed session duration

          final updatedSession = SessionModel(
            start: session.start,
            type: session.type,
            duration: finalDuration.inMinutes,
            index: session.index,
            price: calculatePrice(finalDuration, pricePerHour),
            name: '${widget.cardName} #${widget.deviceNumber}',
          );

          await SharedPrefService.saveToHistory(updatedSession);
          await SharedPrefService.clearSession(keyPrefix);

          if (widget.category == Categories.playstation) {
            await SharedPrefService.pref?.remove("${keyPrefix}_psGameType");
          }
        }

        if (mounted) {
          setState(() {
            isRunning = false;
            startTime = null;
            elapsed = Duration.zero;
            psGameType = null;
          });
        }
        return;
      }

      setState(() {
        elapsed = newElapsed;
      });
    });
  }

  Future<void> saveSession() async {
    final pricePerHour = getPricePerHour();
    final price = calculatePrice(elapsed, pricePerHour);

    await SharedPrefService.saveSession(
      key: keyPrefix,
      start: startTime!.millisecondsSinceEpoch,
      type: selectedType ?? "open",
      duration: totalDuration.inSeconds,
      index: selectedIndex,
      price: price,
      name: '${widget.cardName} #${widget.deviceNumber}',
    );

    // Save PlayStation game type if applicable
    if (widget.category == Categories.playstation && psGameType != null) {
      await SharedPrefService.pref?.setString(
        "${keyPrefix}_psGameType",
        psGameType!,
      );
    }
  }

  Future<void> loadSession() async {
    final session = SharedPrefService.getSession(keyPrefix);

    if (session != null) {
      startTime = DateTime.fromMillisecondsSinceEpoch(session.start);
      selectedType = session.type;
      selectedIndex = session.index;
      totalDuration = Duration(seconds: session.duration);
      isRunning = true;

      // Load PlayStation game type if applicable
      if (widget.category == Categories.playstation) {
        psGameType = SharedPrefService.pref?.getString(
          "${keyPrefix}_psGameType",
        );
      }

      final diff = DateTime.now().difference(startTime!);

      if (selectedType == "open") {
        elapsed = diff;
      } else {
        final remaining = totalDuration - diff;
        elapsed = remaining.isNegative ? Duration.zero : remaining;
      }

      startTimer();
    }

    if (mounted) setState(() {});
  }

  double calculatePrice(Duration duration, double pricePerHour) {
    final hours = duration.inMinutes / 60;
    return hours * pricePerHour;
  }

  double getPricePerHour() {
    switch (widget.category) {
      case Categories.playstation:
        if (psGameType == 'multi') {
          return 30.0;
        }
        return 25.0;
      case Categories.billiards:
        return 30.0;
      case Categories.ping:
        return 30.0;
      default:
        return 30.0;
    }
  }

  void _showStartSessionSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return StartSessionBottomSheet(
          onSelect: (index, type, duration) async {
            setState(() {
              isRunning = true;
              startTime = DateTime.now();
              selectedIndex = index;
              selectedType = type;
              totalDuration = duration;
            });

            await saveSession();
            startTimer();
          },
        );
      },
    );
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
        height: isRunning ? 380.h : 230.h,
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

              Text(
                widget.isType
                    ? ' PS  #${widget.deviceNumber}'
                    : ' Table  #${widget.deviceNumber}',
                style: AppStyle.font40WhiteBold,
              ),

              Gap(5.h),

              if (isRunning)
                Container(
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
                ),

              Gap(30.h),

              if (isRunning)
                Column(
                  children: [
                    PriceCalculator(
                      duration: diff,
                      pricePerHour: getPricePerHour(),
                    ),

                    Gap(12.h),

                    AppTextButton(
                      buttonText: 'END SECTION',
                      backgroundColor: AppColors.redColor,
                      textStyle: AppStyle.font18WhiteW500,
                      onPressed: () {
                        showEndSessionConfirmation(context, () async {
                          timer?.cancel();

                          final finalDuration = startTime == null
                              ? Duration.zero
                              : DateTime.now().difference(startTime!);

                          final session = SharedPrefService.getSession(
                            keyPrefix,
                          );

                          if (session != null) {
                            final pricePerHour = getPricePerHour();
                            final updatedSession = SessionModel(
                              start: session.start,
                              type: session.type,
                              duration: finalDuration.inMinutes,
                              index: session.index,
                              price: calculatePrice(
                                finalDuration,
                                pricePerHour,
                              ),
                              name:
                                  '${widget.cardName} #${widget.deviceNumber}',
                            );

                            await SharedPrefService.saveToHistory(
                              updatedSession,
                            );
                            await SharedPrefService.clearSession(keyPrefix);

                            // Clear PlayStation game type
                            if (widget.category == Categories.playstation) {
                              await SharedPrefService.pref?.remove(
                                "${keyPrefix}_psGameType",
                              );
                            }
                          }

                          showSummaryDialog(context, finalDuration);

                          setState(() {
                            isRunning = false;
                            startTime = null;
                            elapsed = Duration.zero;
                            psGameType = null;
                          });
                        });
                      },
                    ),
                  ],
                )
              else
                AppTextButton(
                  buttonText: 'START SECTION',
                  backgroundColor: AppColors.greenColor,
                  textStyle: AppStyle.font18WhiteW500,
                  onPressed: () {
                    if (widget.category == Categories.playstation) {
                      showModalBottomSheet(
                        context: context,
                        builder: (_) {
                          return PlaystationTypeBottomSheet(
                            onSelect: (gameType) {
                              setState(() {
                                psGameType = gameType;
                              });
                              _showStartSessionSheet();
                            },
                          );
                        },
                      );
                    } else {
                      _showStartSessionSheet();
                    }
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
