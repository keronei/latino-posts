import 'package:flutter/material.dart';
import 'package:latin_news/models/news_post.dart';
import 'package:latin_news/utils/shared_functions.dart';
import 'package:latin_news/views/post_details_divider.dart';

import '../models/details_content.dart';
import '../utils/constants.dart';

class PostDetailsScreen extends StatelessWidget {
  final NewsPost selectedPost;
  final List<NewsPost> otherPosts;

  const PostDetailsScreen({
    super.key,
    required this.selectedPost,
    required this.otherPosts,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            floating: true,
            pinned: false,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  key: const Key("header_title"),
                  selectedPost.title.capitalizeSentences(),
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                selectedPost.body.capitalizeFirstLetter(),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w100),
              ),
            ),
          ),

          SliverPersistentHeader(pinned: false, delegate: SearchBoxDelegate()),

          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              if (otherPosts[index].id == selectedPost.id) {
                return SizedBox.shrink();
              } else {
                return ListTile(
                  leading: Chip(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),

                    label: Text(
                      "# ${otherPosts[index].id}",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    backgroundColor:
                        Theme.of(context).colorScheme.secondaryContainer,
                  ),
                  title: Text(otherPosts[index].title.capitalizeFirstLetter()),
                  onTap: () {
                    Navigator.pushReplacementNamed(
                      context,
                      detailsDestination,
                      arguments: DetailsContent(
                        otherPosts,
                        otherPosts[index].id,
                      ),
                    );
                  },
                );
              }
            }, childCount: otherPosts.length),
          ),
        ],
      ),
    );
  }
}
