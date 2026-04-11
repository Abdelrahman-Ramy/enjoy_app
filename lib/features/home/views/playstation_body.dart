import 'package:enjoy_app/core/widgets/is_running_tab.dart';
import 'package:enjoy_app/features/home/views/playstation_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class PlaystationBody extends StatelessWidget {
  const PlaystationBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const IsRunningTab(),
            Gap(15.h),
            const PlaystationCard(
              cardName: 'Device',
              deviceNumber: '01',
              isRunning: true,
            ),
            Gap(12.h),
            const PlaystationCard(
              cardName: 'Device',
              deviceNumber: '02',
              isRunning: false,
            ),
            Gap(12.h),
            const PlaystationCard(
              cardName: 'Device',
              deviceNumber: '03',
              isRunning: true,
            ),
            Gap(12.h),
            const PlaystationCard(
              cardName: 'Device',
              deviceNumber: '04',
              isRunning: false,
            ),
            Gap(12.h),
            const PlaystationCard(
              cardName: 'Device',
              deviceNumber: '05',
              isRunning: true,
            ),
            Gap(20.h),
          ],
        ),
      ),
    );
  }
}
