import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:latin_news/models/news_post.dart';
import 'package:latin_news/providers/db_provider.dart';
import 'package:latin_news/utils/constants.dart';
import 'package:http/http.dart' as http;

class NewsPostApiProvider {
  Future<List<NewsPost>> getNextPage(int nextPage) async {
    try {
      final response = await http.get(
        Uri.parse("$baseApiEndpoint?_page=$nextPage&_limit=$apiPageSize"),
      );

      List posts = [];
      List<NewsPost> parsedPosts = [];

      posts = json.decode(response.body);

      // Alternatively use status==200 to determine if reachable

      parsedPosts = posts.map((post) => NewsPost.fromJson(post)).toList();

      for (var poster in parsedPosts) {
        DBProvider.db.createNews(poster);
      }

      return parsedPosts;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }

      // return from caches here
      return [];
    }
  }
}
