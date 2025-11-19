import 'dart:io';

import 'package:flutter_hn_clone/utils/api.dart';

class HNService {
  Future<Map<String, dynamic>> fetchStory(int id) async {
    final response = await api(
      'https://hacker-news.firebaseio.com/v0/item/$id.json',
    );

    if (response case Ok()) {
      return response.data;
    } else {
      throw HttpException('Failed to fetch story');
    }
  }

  Future<List<int>> fetchTopStoryIds() async {
    final response = await api(
      'https://hacker-news.firebaseio.com/v0/topstories.json',
    );

    if (response case Ok()) {
      return List<int>.from(response.data);
    } else {
      throw HttpException('Failed to fetch top stories');
    }
  }

  Future<List<int>> fetchNewStoryIds() async {
    final response = await api(
      'https://hacker-news.firebaseio.com/v0/newstories.json',
    );

    if (response case Ok()) {
      return List<int>.from(response.data);
    } else {
      throw HttpException('Failed to fetch new stories');
    }
  }

  Future<List<int>> fetchBestStoryIds() async {
    final response = await api(
      'https://hacker-news.firebaseio.com/v0/beststories.json',
    );

    if (response case Ok()) {
      return List<int>.from(response.data);
    } else {
      throw HttpException('Failed to fetch best stories');
    }
  }
}
