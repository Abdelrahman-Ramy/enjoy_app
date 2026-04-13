import 'package:enjoy_app/features/home/views/playstation_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class PingPongBody extends StatelessWidget {
  const PingPongBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Gap(70.h),
            PlaystationCard(
              cardName: 'Table',
              isType: false,
              deviceNumber: '01',
            ),
          ],
        ),
      ),
    );
  }
}
