import 'package:enjoy_app/features/home/views/playstation_card.dart';
import 'package:enjoy_app/features/home/widgets/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class PlaystationBody extends StatefulWidget {
  const PlaystationBody({super.key});

  @override
  State<PlaystationBody> createState() => _PlaystationBodyState();
}

class _PlaystationBodyState extends State<PlaystationBody> {
  List<Map<String, dynamic>> devices = [
    {"number": "01", "isRunning": true},
    {"number": "02", "isRunning": false},
    {"number": "03", "isRunning": true},
    {"number": "04", "isRunning": false},
    {"number": "05", "isRunning": true},
  ];
  List<Map<String, dynamic>> filteredDevices = [];
  int selectedFilter = 0;

  void applyFilter() {
    filteredDevices = devices.where((device) {
      final isRunning = device["isRunning"] == true;

      if (selectedFilter == 1) return !isRunning; // Available
      if (selectedFilter == 2) return isRunning; // Running

      return true; // All
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    filteredDevices = List.from(devices);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // IsRunningTab(
          //   onChanged: (index) {
          //     setState(() {
          //       selectedFilter = index;
          //     });
          //     applyFilter();
          //   },
          // ),
          Gap(15.h),
          Expanded(
            child: ListView.builder(
              itemCount: filteredDevices.length,
              itemBuilder: (context, index) {
                final device = filteredDevices[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: 30.h),
                  child: PlaystationCard(
                    deviceNumber: device["number"],
                    cardName: 'Device',
                    category: Categories.playstation,
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
