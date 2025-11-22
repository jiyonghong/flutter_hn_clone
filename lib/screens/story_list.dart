import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hn_clone/controllers/story_list_controller.dart';
import 'package:flutter_hn_clone/db/database.dart';
import 'package:flutter_hn_clone/models/story.dart';
import 'package:flutter_hn_clone/widgets/pagination_builder.dart';
import 'package:flutter_hn_clone/widgets/story.dart';
import 'package:provider/provider.dart';

class StoryPaginationScreen extends StatefulWidget {
  final StoryPaginationController controller;

  const StoryPaginationScreen({super.key, required this.controller});

  @override
  State<StoryPaginationScreen> createState() => _StoryPaginationScreenState();
}

class _StoryPaginationScreenState extends State<StoryPaginationScreen>
    with AutomaticKeepAliveClientMixin {
  late final PaginationController<Story, int> _pagingController;
  final ScrollController _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _pagingController = PaginationController<Story, int>(
      fetchPage: (key) async {
        await Future.delayed(const Duration(seconds: 1));
        return await widget.controller.fetchStories(page: key, limit: 10);
      },
      getNextPageKey: (lastPage) => lastPage != null ? lastPage.page + 1 : 1,
    );
    widget.controller.addListener(_scrollToTop);
  }

  @override
  void dispose() {
    _pagingController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final db = context.read<AppDatabase>();

    return StreamBuilder<Set<int>>(
      stream: db.bookmarksDao.watchBookmarkedItemIds(),
      builder: (context, snapshot) {
        final bookmarkIds = snapshot.data ?? {};

        return PaginationBuilder(
          controller: _pagingController,
          scrollController: _scrollController,
          itemBuilder: (context, item, index) {
            return StoryWidget(
              story: item,
              isBookmarked: bookmarkIds.contains(item.id),
              onToggleBookmark: () {
                db.bookmarksDao.toggleBookmark(
                  BookmarksCompanion(
                    itemId: Value(item.id),
                    title: Value(item.title),
                    url: Value(item.url),
                    by: Value(item.by),
                    content: Value(item.text),
                    time: Value(item.time),
                    score: Value(item.score),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
