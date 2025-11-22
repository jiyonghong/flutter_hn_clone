import 'package:flutter/material.dart';
import 'package:flutter_hn_clone/controllers/story_list_controller.dart';
import 'package:flutter_hn_clone/repositories/story_repository.dart';
import 'package:flutter_hn_clone/screens/story_list.dart';
import 'package:flutter_hn_clone/widgets/tab_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final StoryPaginationController _newsController = StoryPaginationController(
    storyType: StoryType.news,
  );
  final StoryPaginationController _topController = StoryPaginationController(
    storyType: StoryType.top,
  );
  final StoryPaginationController _bestController = StoryPaginationController(
    storyType: StoryType.best,
  );

  void _scrollToTop() {
    switch (_tabController.index) {
      case 0:
        _newsController.scrollToTop();
      case 1:
        _topController.scrollToTop();
      case 2:
        _bestController.scrollToTop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: _scrollToTop,
          child: Text('HackerNews', style: TextStyle(fontFamily: 'Domine')),
        ),
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0.0,
      ),
      extendBody: true,
      body: TabBarView(
        controller: _tabController,
        children: [
          StoryPaginationScreen(controller: _newsController),
          StoryPaginationScreen(controller: _topController),
          StoryPaginationScreen(controller: _bestController),
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
    _tabController = TabController(length: 3, initialIndex: 1, vsync: this);
  }
}
