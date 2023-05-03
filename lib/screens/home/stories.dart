import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:friend_story/models/story.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import '../../services/auth.dart';
import '../../services/database.dart';
import 'components/story_list.dart';

class Stories extends StatefulWidget {
  const Stories({super.key});

  @override
  State<Stories> createState() => _StoriesState();
}

class _StoriesState extends State<Stories> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModal>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Stories"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              await _auth.signOut();
            },
          ),
        ],
      ),
      body: StreamProvider<List<Story>>.value(
        value: DatabaseService(
          uid: user.uid, // false because we want to see unaccepted stories
        ).stories,
        initialData: const [],
        child: const StoryList(),
      ),
    );
  }
}
