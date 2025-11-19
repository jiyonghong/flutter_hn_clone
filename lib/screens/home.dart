import 'package:flutter/material.dart';
import 'package:flutter_hn_clone/controllers/story_list_controller.dart';
import 'package:flutter_hn_clone/screens/story_list.dart';
import 'package:flutter_hn_clone/utils/tab_bar_visibility_notifier.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('HackerNews', style: TextStyle(fontFamily: 'Domine')),
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0.0,
      ),
      extendBody: true,
      body: TabBarView(
        controller: _tabController,
        children: [
          StoryPaginationScreen(controller: NewStoryPaginationController()),
          StoryPaginationScreen(controller: TopStoryPaginationController()),
          StoryPaginationScreen(controller: BestStoryPaginationController()),
        ],
      ),

      bottomNavigationBar: ListenableBuilder(
        listenable: tabBarVisibilityNotifier,
        builder: (context, child) {
          return AnimatedScale(
            duration: const Duration(milliseconds: 300),
            scale: tabBarVisibilityNotifier.isVisible ? 1.0 : 0.0,
            curve: Curves.fastEaseInToSlowEaseOut,
            child: Container(
              margin: EdgeInsets.only(
                left: 24.0,
                right: 24.0,
                bottom: MediaQuery.of(context).padding.bottom,
              ),
              width: 280,
              height: 60,
              alignment: Alignment.center,
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
                indicator: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
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
            ),
          );
        },
      ),
    );
  }
}
