import 'package:flutter/cupertino.dart';
import 'package:flutter_hn_clone/models/pagination.dart';
import 'package:flutter_hn_clone/models/story.dart';
import 'package:flutter_hn_clone/repositories/story_repository.dart';
import 'package:flutter_hn_clone/services/hn_service.dart';

abstract class IStoryPaginationController {
  Future<Pagination<Story>> fetchStories({int page = 1, int limit = 20});
}

class StoryPaginationController extends ChangeNotifier
    implements IStoryPaginationController {
  final StoryRepository _storyRepository = StoryRepository(HNService());

  final StoryType storyType;

  StoryPaginationController({required this.storyType});

  @override
  Future<Pagination<Story>> fetchStories({int page = 1, int limit = 20}) async {
    return await _storyRepository.fetchStories(storyType, page, limit);
  }

  void scrollToTop() {
    notifyListeners();
  }
}
