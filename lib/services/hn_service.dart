import 'dart:io';

import 'package:flutter_hn_clone/repositories/story_repository.dart';
import 'package:flutter_hn_clone/utils/api.dart';

class HNService {
  Future<Map<String, dynamic>> fetchItem(int id) async {
    final response = await api(
      'https://hacker-news.firebaseio.com/v0/item/$id.json',
    );

    if (response case Ok()) {
      return response.data;
    } else {
      throw HttpException('Failed to fetch story');
    }
  }

  Future<List<int>> fetchStoryIds(StoryType type) async {
    final response = await api(
      'https://hacker-news.firebaseio.com/v0/${type.value}.json',
    );

    if (response case Ok()) {
      return List<int>.from(response.data);
    } else {
      throw HttpException('Failed to fetch ${type.value}');
    }
  }
}
