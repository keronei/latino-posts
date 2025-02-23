import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:latin_news/providers/api_provider.dart';
import 'package:latin_news/providers/db_provider.dart';
import 'package:latin_news/utils/constants.dart';
import 'package:latin_news/views/posts_list.dart';
import 'package:latin_news/views/post_details.dart';
import 'package:latin_news/views/theme/app_theme.dart';
import 'package:provider/provider.dart';

import 'models/details_content.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<http.Client>(create: (_) => http.Client()),
        Provider<DBProvider>(create: (_) => DBProvider.db),
        ProxyProvider2<http.Client, DBProvider, NewsPostApiProvider>(
          update:
              (_, httpClient, dbProvider, __) => NewsPostApiProvider(
                httpClient: httpClient,
                dbProvider: dbProvider,
              ),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme,
      themeMode: ThemeMode.system,
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
