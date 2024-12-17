import 'package:flutter/material.dart';
import 'package:new_mk_v3/model/forum_model.dart';
import 'package:new_mk_v3/pages/features/postdetails_pages.dart';


class ForumPage extends StatefulWidget {
  @override
  _ForumPageState createState() => _ForumPageState();
}

List<Post> dummyPosts = [
  Post(
    id: '1',
    title: 'Welcome to the Forum',
    content: 'This is the first post in the forum. Feel free to share your thoughts!',
    author: 'Admin',
  ),
  Post(
    id: '2',
    title: 'Flutter vs React Native',
    content: 'What are your thoughts on Flutter vs React Native for app development?',
    author: 'User123',
  ),
];

class _ForumPageState extends State<ForumPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forum'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: const Text(
              'Isu Semasa',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic
              ),
            ),
          ),
          // Expand the ListView to take up remaining space
          Expanded(
            child: ListView.builder(
              itemCount: dummyPosts.length,
              itemBuilder: (context, index) {
                final post = dummyPosts[index];
                return ListTile(
                  title: Text(post.title),
                  subtitle: Text('by ${post.author}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PostDetailsPage(post: post),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

