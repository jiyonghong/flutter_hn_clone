import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hn_clone/controllers/story_list_controller.dart';
import 'package:flutter_hn_clone/models/story.dart';
import 'package:flutter_hn_clone/utils/tab_bar_visibility_notifier.dart';
import 'package:flutter_hn_clone/widgets/loading.dart';
import 'package:flutter_hn_clone/widgets/story.dart';

class StoryPaginationScreen extends StatefulWidget {
  final IStoryPaginationController controller;

  const StoryPaginationScreen({super.key, required this.controller});

  @override
  State<StoryPaginationScreen> createState() => _StoryPaginationScreenState();
}

class _StoryPaginationScreenState extends State<StoryPaginationScreen> {
  static const double topPadding = 10.0;

  final ScrollController _scrollController = ScrollController();
  bool _showTopFade = false;

  late Future<List<Story>> _storiesFuture;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return FutureBuilder<List<Story>>(
      future: _storiesFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Stack(
            children: [
              ListView.separated(
                controller: _scrollController,
                padding: EdgeInsets.only(
                  top: topPadding,
                  left: 8,
                  right: 8,
                  bottom: MediaQuery.of(context).padding.bottom,
                ),
                separatorBuilder: (context, index) {
                  return SizedBox(height: 8);
                },
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return StoryWidget(story: snapshot.data![index]);
                },
              ),
              AnimatedOpacity(
                opacity: _showTopFade ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                child: IgnorePointer(
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          themeData.scaffoldBackgroundColor,
                          themeData.scaffoldBackgroundColor.withAlpha(0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        return LoadingWidget();
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _storiesFuture = widget.controller.fetchStories();
  }

  void _onScroll() {
    final shouldTopFade = _scrollController.offset > topPadding;
    if (_showTopFade != shouldTopFade) {
      setState(() {
        _showTopFade = shouldTopFade;
      });
    }

    final direction = _scrollController.position.userScrollDirection;
    if (direction == ScrollDirection.reverse) {
      if (tabBarVisibilityNotifier.isVisible) {
        tabBarVisibilityNotifier.hide();
      }
    }
    if (direction == ScrollDirection.forward) {
      if (!tabBarVisibilityNotifier.isVisible) {
        tabBarVisibilityNotifier.show();
      }
    }
  }
}
