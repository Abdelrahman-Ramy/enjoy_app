import 'package:enjoy_app/core/widgets/is_running_tab.dart';
import 'package:enjoy_app/features/home/views/playstation_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class PlaystationBody extends StatefulWidget {
  const PlaystationBody({super.key});

  @override
  State<PlaystationBody> createState() => _PlaystationBodyState();
}

class _PlaystationBodyState extends State<PlaystationBody> {
  List<Map<String, dynamic>> allDevices = [
    {"number": "01", "isRunning": true},
    {"number": "02", "isRunning": false},
    {"number": "03", "isRunning": true},
    {"number": "04", "isRunning": false},
    {"number": "05", "isRunning": true},
  ];
  List<Map<String, dynamic>> filteredDevices = [];

  @override
  void initState() {
    super.initState();
    filteredDevices = allDevices;
  }

  void filterDevices(int index) {
    if (index == 0) {
      filteredDevices = allDevices;
    } else if (index == 1) {
      filteredDevices = allDevices
          .where((d) => d["isRunning"] == false)
          .toList();
    } else {
      filteredDevices = allDevices
          .where((d) => d["isRunning"] == true)
          .toList();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          IsRunningTab(onChanged: filterDevices),
          Gap(15.h),
          Expanded(
            child: ListView.builder(
              itemCount: filteredDevices.length,
              itemBuilder: (context, index) {
                final device = filteredDevices[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: PlaystationCard(
                    deviceNumber: device["number"],
                    cardName: 'Device',
                  ),
                );
              },
            ),
          ),
          Gap(20.h),
        ],
      ),
    );
  }
}
