import 'package:flutter/material.dart';
import 'package:flutter_hn_clone/controllers/story_list_controller.dart';
import 'package:flutter_hn_clone/models/story.dart';
import 'package:flutter_hn_clone/repositories/story_repository.dart';
import 'package:flutter_hn_clone/utils/infinite_scroll.dart';
import 'package:flutter_hn_clone/widgets/story.dart';

class StoryPaginationScreen extends StatefulWidget {
  final StoryType storyType;

  const StoryPaginationScreen({super.key, required this.storyType});

  @override
  State<StoryPaginationScreen> createState() => _StoryPaginationScreenState();
}

class _StoryPaginationScreenState extends State<StoryPaginationScreen>
    with AutomaticKeepAliveClientMixin {
  late final PagingController<Story, int> _pagingController;
  late final StoryPaginationController _controller;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _controller = StoryPaginationController(storyType: widget.storyType);
    _pagingController = PagingController<Story, int>(
      fetchPage: (key) async {
        await Future.delayed(const Duration(milliseconds: 1000));
        return await _controller.fetchStories(page: key, limit: 10);
      },
      getNextPageKey: (lastPage) => lastPage != null ? lastPage.page + 1 : 1,
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return InfiniteScrollBuilder(
      controller: _pagingController,
      itemBuilder: (context, item, index) {
        return StoryWidget(story: item);
      },
    );
  }
}
