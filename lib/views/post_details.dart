import 'package:flutter/material.dart';
import 'package:latin_news/models/news_post.dart';

class PostDetailsScreen extends StatelessWidget {
  final NewsPost post;

  const PostDetailsScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Post Details")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: Text(post.title),
          ),
          const SizedBox(height: 16),
          Text(
            post.title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(post.body, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
