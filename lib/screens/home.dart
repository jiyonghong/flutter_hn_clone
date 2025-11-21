import 'package:flutter/material.dart';
import 'package:flutter_hn_clone/repositories/story_repository.dart';
import 'package:flutter_hn_clone/screens/story_list.dart';
import 'package:flutter_hn_clone/states/tab_bar_notifier.dart';
import 'package:flutter_hn_clone/widgets/tab_bar.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  Widget build(BuildContext context) {
    final tabBarNotifier = context.read<TabBarNotifier>();

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
          StoryPaginationScreen(storyType: StoryType.news),
          StoryPaginationScreen(storyType: StoryType.top),
          StoryPaginationScreen(storyType: StoryType.best),
        ],
      ),

      bottomNavigationBar: HomeTabBar(controller: _tabController),
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
}
