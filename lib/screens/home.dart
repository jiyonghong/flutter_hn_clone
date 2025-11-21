import 'package:flutter/material.dart';
import 'package:flutter_hn_clone/repositories/story_repository.dart';
import 'package:flutter_hn_clone/screens/story_list.dart';
import 'package:flutter_hn_clone/utils/tab_bar_visibility_notifier.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final TabBarNotifier _tabBarNotifier = TabBarNotifier();

  late final TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HackerNews', style: TextStyle(fontFamily: 'Domine')),
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0.0,
      ),
      extendBody: true,
      body: TabBarProvider(
        notifier: _tabBarNotifier,
        child: TabBarView(
          controller: _tabController,
          children: [
            StoryPaginationScreen(storyType: StoryType.news),
            StoryPaginationScreen(storyType: StoryType.top),
            StoryPaginationScreen(storyType: StoryType.best),
          ],
        ),
      ),

      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    final tabBarWidget = Container(
      width: 250,
      height: 60,
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
      child: TabBar(
        dividerColor: Colors.transparent,
        controller: _tabController,
        indicator: BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: Colors.white,
        unselectedLabelColor: themeData.textTheme.labelLarge!.color,
        splashFactory: NoSplash.splashFactory,
        tabs: [
          Container(
            padding: EdgeInsets.all(8.0),
            child: Tab(icon: Icon(Icons.newspaper, size: 28)),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Tab(icon: Icon(Icons.whatshot, size: 28)),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Tab(icon: Icon(Icons.thumb_up, size: 28)),
          ),
        ],
      ),
    );

    return AnimatedBuilder(
      animation: _tabBarNotifier,
      builder: (context, child) {
        return SafeArea(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedScale(
              duration: const Duration(milliseconds: 300),
              scale: _tabBarNotifier.isVisible ? 1.0 : 0.0,
              curve: Curves.fastEaseInToSlowEaseOut,
              child: tabBarWidget,
            ),
          ),
        );
      },
    );
  }
}
