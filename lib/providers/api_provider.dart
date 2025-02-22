import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:latin_news/models/news_post.dart';
import 'package:latin_news/providers/db_provider.dart';
import 'package:latin_news/utils/constants.dart';
import 'package:http/http.dart' as http;

import '../models/response_data.dart';
import '../utils/shared_functions.dart';

class NewsPostApiProvider {
  Future<ResponseData> getNextPage(int nextPage) async {
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

      return ResponseData(newsPostsCount: parsedPosts.length);
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }

      return ResponseData(
        newsPostsCount: 0,
        responseMessage: getErrorMessage(error as Exception),
      );
    }
  }

}
