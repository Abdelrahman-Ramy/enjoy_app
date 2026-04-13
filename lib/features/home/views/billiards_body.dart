import 'package:enjoy_app/features/home/views/playstation_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class BilliardsBody extends StatelessWidget {
  const BilliardsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Gap(70.h),
            PlaystationCard(
              cardName: 'Billiards',
              isType: false,
              deviceNumber: '01',
            ),
            Gap(12.h),
            PlaystationCard(
              cardName: 'Billiards',
              isType: false,
              deviceNumber: '02',
            ),
            Gap(20.h),
          ],
        ),
      ),
    );
    ;
  }
}
