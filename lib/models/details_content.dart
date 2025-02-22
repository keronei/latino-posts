import 'package:latin_news/models/news_post.dart';

class DetailsContent {
  int selectedPostId;
  List<NewsPost> allOtherPosts;

  DetailsContent(this.allOtherPosts, this.selectedPostId);
}
