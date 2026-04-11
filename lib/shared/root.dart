import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:enjoy_app/core/constant/app_colors.dart';
import 'package:enjoy_app/features/history/views/history_view.dart';
import 'package:enjoy_app/features/home/views/home_view.dart';
import 'package:enjoy_app/features/settings/views/settings_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  late final PageController controller;
  late final NotchBottomBarController notchController;

  late final List<Widget> screens;
  int currentScreen = 0;

  @override
  void initState() {
    controller = PageController(initialPage: currentScreen);
    notchController = NotchBottomBarController(index: currentScreen);
    screens = [const HistoryView(), const HomeView(), const SettingsView()];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller,
        physics: const NeverScrollableScrollPhysics(),
        children: screens,
      ),
      bottomNavigationBar: AnimatedNotchBottomBar(
        elevation: 0,
        color: AppColors.primaryColor,
        itemLabelStyle: const TextStyle(color: Colors.grey, fontSize: 15.0),
        notchBottomBarController: notchController,
        showLabel: true,
        notchColor: AppColors.primaryColor,
        bottomBarItems: const [
          BottomBarItem(
            inActiveItem: Icon(CupertinoIcons.home, color: Colors.grey),
            activeItem: Icon(CupertinoIcons.home, color: Colors.white),
            itemLabel: 'Home',
          ),
          BottomBarItem(
            inActiveItem: Icon(CupertinoIcons.settings, color: Colors.grey),
            activeItem: Icon(CupertinoIcons.settings, color: Colors.white),
            itemLabel: 'Settings',
          ),
          BottomBarItem(
            inActiveItem: Icon(CupertinoIcons.time, color: Colors.grey),
            activeItem: Icon(CupertinoIcons.time, color: Colors.white),
            itemLabel: 'History',
          ),
        ],
        onTap: (index) {
          setState(() {
            currentScreen = index;
          });
          controller.jumpToPage(index);
          notchController.jumpTo(index);
        },
        kIconSize: 24,
        kBottomRadius: 10,
      ),
    );
  }
}
