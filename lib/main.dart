import 'package:flutter/material.dart';
import 'package:latin_news/models/news_post.dart';
import 'package:latin_news/utils/constants.dart';
import 'package:latin_news/views/news_list.dart';
import 'package:latin_news/views/post_details.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: homeDestination,
      onGenerateRoute: (settings) {
        if (settings.name == detailsDestination) {
          final post = settings.arguments as NewsPost;
          return MaterialPageRoute(
            builder: (context) => PostDetailsScreen(post: post),
          );
        }
      },
      routes: { homeDestination: (BuildContext context) => HomePage()},
    );
  }
}
