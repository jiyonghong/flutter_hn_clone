import 'package:flutter_hn_clone/models/story.dart';
import 'package:flutter_hn_clone/services/hn_service.dart';

abstract class IStoryRepository {
  Future<Story> fetchStory(int id);
  Future<List<int>> fetchTopStoryIds();
  Future<List<int>> fetchNewStoryIds();
  Future<List<int>> fetchBestStoryIds();
}

class StoryRepository implements IStoryRepository {
  final HNService hnService;

  final Map<int, Story> _cache = {};

  StoryRepository(this.hnService);

  @override
  Future<Story> fetchStory(int id) async {
    if (_cache.containsKey(id)) {
      return _cache[id]!;
    }

    final data = await hnService.fetchStory(id);
    final story = Story.fromJson(data);
    _cache[id] = story;
    return story;
  }

  @override
  Future<List<int>> fetchTopStoryIds() async {
    return await hnService.fetchTopStoryIds();
  }

  @override
  Future<List<int>> fetchNewStoryIds() async {
    return await hnService.fetchNewStoryIds();
  }

  @override
  Future<List<int>> fetchBestStoryIds() async {
    return await hnService.fetchBestStoryIds();
  }
}
