import 'package:flutter/material.dart';
import 'package:new_mk_v3/model/forum_model.dart';


class PostDetailsPage extends StatelessWidget {
  final Post post;

  const PostDetailsPage({required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('By ${post.author}', style: const TextStyle(fontSize: 16)),
            const Divider(height: 30),
            Text(post.content, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
