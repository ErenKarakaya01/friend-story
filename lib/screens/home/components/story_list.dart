import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:friend_story/screens/home/components/story_tile.dart';
import 'package:provider/provider.dart';

import '../../../models/story.dart';
import '../../../models/user.dart';
import '../../../services/database.dart';

class StoryList extends StatefulWidget {
  const StoryList({super.key});

  @override
  State<StoryList> createState() => _StoryListState();
}

class _StoryListState extends State<StoryList> {
  @override
  Widget build(BuildContext context) {
    final stories = Provider.of<List<Story>>(context);

    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: stories.length,
          itemBuilder: (context, index) => StoryTile(story: stories[index]),
        ),
      ],
    );
  }
}
