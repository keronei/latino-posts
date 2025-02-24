import 'package:latin_news/models/news_post.dart';

class DetailsContent {
  int selectedPostId;
  List<NewsPost> allOtherPosts;
  bool fromBottom;

  DetailsContent(this.allOtherPosts, this.selectedPostId, this.fromBottom);
}
