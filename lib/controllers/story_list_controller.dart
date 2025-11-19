import 'package:flutter_hn_clone/models/story.dart';
import 'package:flutter_hn_clone/repositories/story_repository.dart';
import 'package:flutter_hn_clone/services/hn_service.dart';

abstract class IStoryPaginationController {
  Future<List<Story>> fetchStories({int page = 1, int limit = 20});
}

class BestStoryPaginationController implements IStoryPaginationController {
  final StoryRepository _storyRepository = StoryRepository(HNService());

  @override
  Future<List<Story>> fetchStories({int page = 1, int limit = 20}) async {
    final ids = await _storyRepository.fetchBestStoryIds();
    final start = (page - 1) * limit;
    return await Future.wait(
      ids.sublist(start, start + limit).map((id) async {
        return _storyRepository.fetchStory(id);
      }),
    );
  }
}

class NewStoryPaginationController implements IStoryPaginationController {
  final StoryRepository _storyRepository = StoryRepository(HNService());

  @override
  Future<List<Story>> fetchStories({int page = 1, int limit = 20}) async {
    final ids = await _storyRepository.fetchNewStoryIds();
    final start = (page - 1) * limit;
    return await Future.wait(
      ids.sublist(start, start + limit).map((id) async {
        return _storyRepository.fetchStory(id);
      }),
    );
  }
}

class TopStoryPaginationController implements IStoryPaginationController {
  final StoryRepository _storyRepository = StoryRepository(HNService());

  @override
  Future<List<Story>> fetchStories({int page = 1, int limit = 20}) async {
    final ids = await _storyRepository.fetchTopStoryIds();
    final start = (page - 1) * limit;
    return await Future.wait(
      ids.sublist(start, start + limit).map((id) async {
        return _storyRepository.fetchStory(id);
      }),
    );
  }
}
