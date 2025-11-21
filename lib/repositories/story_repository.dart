import 'package:flutter_hn_clone/models/pagination.dart';
import 'package:flutter_hn_clone/models/story.dart';
import 'package:flutter_hn_clone/services/hn_service.dart';

enum StoryType {
  top(value: 'topstories'),
  best(value: 'beststories'),
  news(value: 'newstories');

  final String value;
  const StoryType({required this.value});
}

abstract class IStoryRepository {
  Future<Story> fetchStory(int id);
  Future<List<int>> fetchStoryIds(StoryType type);
}

Pagination<T> paginate<T>(List<T> items, int page, [int limit = 20]) {
  final startIndex = (page - 1) * limit;
  final endIndex = startIndex + limit;

  if (items.length < endIndex) {
    return Pagination(
      page: page,
      limit: limit,
      hasNext: false,
      items: items.sublist(startIndex),
    );
  }

  return Pagination(
    page: page,
    limit: limit,
    hasNext: true,
    items: items.sublist(startIndex, endIndex),
  );
}

class StoryRepository implements IStoryRepository {
  final HNService hnService;

  final Map<int, Story> _storyCache = {};

  StoryRepository(this.hnService);

  @override
  Future<Story> fetchStory(int id) async {
    final cache = _storyCache[id];
    if (cache != null) {
      return cache;
    }

    final data = await hnService.fetchItem(id);
    final story = Story.fromJson(data);
    _storyCache[id] = story;
    return story;
  }

  @override
  Future<List<int>> fetchStoryIds(StoryType type) async {
    final ids = await hnService.fetchStoryIds(type);
    return ids;
  }

  Future<Pagination<Story>> fetchStories(
    StoryType type,
    int page,
    int limit,
  ) async {
    final ids = await fetchStoryIds(type);

    final startIndex = (page - 1) * limit;
    final endIndex = startIndex + limit;
    final hasNext = ids.length > endIndex;

    final paginatedIds = ids.sublist(
      startIndex,
      hasNext ? endIndex : ids.length,
    );

    final items = await Future.wait(
      paginatedIds.map((id) async {
        return await fetchStory(id);
      }),
    );

    return Pagination(page: page, limit: limit, hasNext: hasNext, items: items);
  }
}
