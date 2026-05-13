import 'dart:async';
import 'package:enjoy_app/core/constant/app_colors.dart';
import 'package:enjoy_app/core/constant/app_styles.dart';
import 'package:enjoy_app/core/utils/session_prefs.dart';
import 'package:enjoy_app/core/widgets/app_text_button.dart';
import 'package:enjoy_app/features/home/widgets/add_order_bottom_sheet.dart';
import 'package:enjoy_app/features/home/widgets/calculate_elpased.dart';
import 'package:enjoy_app/features/home/widgets/category_model.dart';
import 'package:enjoy_app/features/home/widgets/order_model.dart';
import 'package:enjoy_app/features/home/widgets/orders_list_widget.dart';
import 'package:enjoy_app/features/home/widgets/playstation_type_bottom_sheet.dart';
import 'package:enjoy_app/features/home/widgets/price_breakdown_widget.dart';
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
  List<OrderModel> orders =
      []; // NEW: List to store orders added during session

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
          // IMPORTANT: Load psGameType from SharedPreferences for PlayStation
          String? savedPsGameType;
          if (widget.category == Categories.playstation) {
            savedPsGameType = SharedPrefService.pref?.getString(
              "${keyPrefix}_psGameType",
            );
          }

          // Determine price per hour based on saved type
          double pricePerHour = 30.0; // Default
          if (widget.category == Categories.playstation) {
            pricePerHour = savedPsGameType == 'single' ? 25.0 : 30.0;
          }

          final finalDuration = totalDuration; // Fixed session duration

          // Calculate base price
          final basePrice = calculatePrice(finalDuration, pricePerHour);

          // Calculate orders total
          double ordersTotal = 0;
          for (final order in orders) {
            ordersTotal += order.price;
          }

          // Total price = base + orders (matching manual END SECTION)
          final totalPrice = basePrice + ordersTotal;

          // NEW: Include orders when saving to history
          final updatedSession = SessionModel(
            start: session.start,
            type: session.type,
            duration: finalDuration.inMinutes,
            index: session.index,
            price: totalPrice, // Store total price (base + orders)
            name: '${widget.cardName} #${widget.deviceNumber}',
            orders: orders, // NEW: Include orders
            psGameType: widget.category == Categories.playstation
                ? savedPsGameType
                : null,
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
            orders = []; // NEW: Clear orders
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
    // IMPORTANT: Ensure psGameType is saved to SharedPreferences for PlayStation
    if (widget.category == Categories.playstation && psGameType != null) {
      await SharedPrefService.pref?.setString(
        "${keyPrefix}_psGameType",
        psGameType!,
      );
    }

    // NOW use the saved value to calculate price
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
      orders: orders, // NEW: Include orders when saving session
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
      orders = session.orders; // NEW: Load orders from saved session

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

  /// NEW: Add a new order to the session
  void _addOrder(OrderModel order) async {
    setState(() {
      orders.add(order);
    });
    // Save the updated session with new orders
    await saveSession();
  }

  /// NEW: Remove an order by index
  void _removeOrder(int index) async {
    setState(() {
      if (index >= 0 && index < orders.length) {
        orders.removeAt(index);
      }
    });
    // Save the updated session without the removed order
    await saveSession();
  }

  /// NEW: Show bottom sheet to add new order
  void _showAddOrderSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) => AddOrderBottomSheet(onAddOrder: _addOrder),
      isScrollControlled: true,
    );
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

    // NEW: Calculate dynamic height based on number of orders
    final pricePerHour = getPricePerHour();
    final sessionPrice = calculatePrice(diff, pricePerHour);
    final extrasTotal = orders.fold<double>(
      0,
      (sum, order) => sum + order.price,
    );

    // Base height when running (timer + price + button)
    double cardHeight = 380.h;
    // Add height for each order (approximately 60.h per order)
    if (orders.isNotEmpty) {
      cardHeight += (orders.length * 60.h);
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: Container(
        width: double.infinity,
        height: isRunning ? cardHeight : 230.h,
        decoration: BoxDecoration(
          color: AppColors.darkPrimaryColor,
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: SingleChildScrollView(
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
                      ? ' PS  #${widget.deviceNumber}${isRunning && psGameType != null ? " - $psGameType" : ""}'
                      : ' Table  #${widget.deviceNumber}',
                  style: AppStyle.font40WhiteBold.copyWith(
                    color: widget.isType && isRunning && psGameType == 'multi'
                        ? Colors.purpleAccent
                        : widget.isType && isRunning && psGameType == 'single'
                        ? Colors.blueAccent
                        : AppColors.whiteColor,
                  ),
                ),

                Gap(5.h),

                if (isRunning)
                  Container(
                    width: double.infinity,
                    height: 100.h,
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

                Gap(12.h),

                if (isRunning)
                  Column(
                    children: [
                      // NEW: Use PriceBreakdownWidget instead of PriceCalculator
                      PriceBreakdownWidget(
                        sessionPrice: sessionPrice,
                        extrasTotal: extrasTotal,
                      ),

                      Gap(10.h),

                      // NEW: Display orders list if there are any
                      if (orders.isNotEmpty) ...[
                        Text('Added Orders', style: AppStyle.font18WhiteW500),
                        Gap(8.h),
                        OrdersList(orders: orders, onRemoveOrder: _removeOrder),
                        // Gap(12.h),
                      ],

                      // NEW: Add Order button
                      AppTextButton(
                        buttonText: '+ Add Order',
                        backgroundColor: AppColors.primaryColor,
                        textStyle: AppStyle.font18WhiteW500.copyWith(
                          color: AppColors.greenColor,
                        ),
                        onPressed: _showAddOrderSheet,
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

                            double totalPrice = 0;

                            if (session != null) {
                              // IMPORTANT: Load psGameType from SharedPreferences for PlayStation
                              String? savedPsGameType;
                              if (widget.category == Categories.playstation) {
                                savedPsGameType = SharedPrefService.pref
                                    ?.getString("${keyPrefix}_psGameType");
                              }

                              // Determine price per hour based on saved type
                              double pricePerHour = 30.0; // Default
                              if (widget.category == Categories.playstation) {
                                pricePerHour = savedPsGameType == 'single'
                                    ? 25.0
                                    : 30.0;
                              }

                              final basePrice = calculatePrice(
                                finalDuration,
                                pricePerHour,
                              );

                              // Calculate total price including orders
                              double ordersTotal = 0;
                              for (final order in orders) {
                                ordersTotal += order.price;
                              }
                              totalPrice = basePrice + ordersTotal;

                              // NEW: Include orders and total price in final session
                              final updatedSession = SessionModel(
                                start: session.start,
                                type: session.type,
                                duration: finalDuration.inMinutes,
                                index: session.index,
                                price:
                                    totalPrice, // Store total price (session + orders)
                                name:
                                    '${widget.cardName} #${widget.deviceNumber}',
                                orders: orders, // Include orders
                                psGameType:
                                    widget.category == Categories.playstation
                                    ? savedPsGameType
                                    : null,
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

                            // Show summary with total price (including orders)
                            showSummaryDialog(
                              context,
                              finalDuration,
                              totalPrice: totalPrice,
                              orders: orders,
                            );

                            setState(() {
                              isRunning = false;
                              startTime = null;
                              elapsed = Duration.zero;
                              psGameType = null;
                              orders = []; // NEW: Clear orders
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
      ),
    );
  }
}
