import 'package:flutter/material.dart';
import 'package:latin_news/models/news_post.dart';
import 'package:latin_news/utils/constants.dart';
import 'package:latin_news/views/posts_list.dart';
import 'package:latin_news/views/post_details.dart';

import 'models/details_content.dart';

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
          final pageContent = settings.arguments as DetailsContent;
          return MaterialPageRoute(
            builder:
                (context) => PostDetailsScreen(
                  selectedPost: pageContent.allOtherPosts.firstWhere(
                    (post) => post.id == pageContent.selectedPostId,
                  ),
                  otherPosts: pageContent.allOtherPosts,
                ),
          );
        }
        return null;
      },
      routes: {homeDestination: (BuildContext context) => HomePage()},
    );
  }
}
