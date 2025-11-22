import 'package:flutter/material.dart';
import 'package:flutter_hn_clone/states/tab_bar_notifier.dart';
import 'package:heroicons/heroicons.dart';
import 'package:provider/provider.dart';

class HomeTabBar extends StatelessWidget {
  final TabController controller;

  const HomeTabBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final tabBarNotifier = context.read<TabBarNotifier>();

    final tabBarWidget = Container(
      width: 250,
      padding: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: themeData.cardColor,
        borderRadius: BorderRadius.circular(100.0),
        boxShadow: [
          BoxShadow(
            color: themeData.scaffoldBackgroundColor,
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: SizedBox(
        child: TabBar(
          padding: EdgeInsets.zero,
          dividerColor: Colors.transparent,
          controller: controller,
          indicator: BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: Colors.white,
          labelPadding: EdgeInsets.all(2.0),
          unselectedLabelColor: themeData.textTheme.labelLarge!.color,
          splashFactory: NoSplash.splashFactory,
          tabs: [
            Tab(
              icon: HeroIcon(
                HeroIcons.newspaper,
                size: 28,
                style: HeroIconStyle.solid,
              ),
            ),
            Tab(
              icon: HeroIcon(
                HeroIcons.fire,
                size: 28,
                style: HeroIconStyle.solid,
              ),
            ),
            Tab(
              icon: HeroIcon(
                HeroIcons.handThumbUp,
                size: 28,
                style: HeroIconStyle.solid,
              ),
            ),
          ],
        ),
      ),
    );

    return AnimatedBuilder(
      animation: tabBarNotifier,
      builder: (context, child) {
        return SafeArea(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedScale(
              duration: const Duration(milliseconds: 300),
              scale: tabBarNotifier.isVisible ? 1.0 : 0.0,
              curve: Curves.fastEaseInToSlowEaseOut,
              child: tabBarWidget,
            ),
          ),
        );
      },
    );
  }
}
