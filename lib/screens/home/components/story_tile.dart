import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:random_avatar/random_avatar.dart';

import '../../../models/story.dart';
import '../../../models/user.dart';
import '../../../services/database.dart';

class StoryTile extends StatefulWidget {
  final Story story;
  const StoryTile({super.key, required this.story});

  @override
  State<StoryTile> createState() => _StoryTileState();
}

class _StoryTileState extends State<StoryTile> {
  UserData? friendData;

  @override
  void initState() {
    super.initState();
    DatabaseService().getUserDataByUid(widget.story.userUid).then((friend) {
      setState(() {
        friendData = friend;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final story = widget.story;
    return ExpansionTile(
      leading: RandomAvatar(story.userUid,
          trBackground: true, height: 50, width: 50),
      title: Text(friendData != null
          ? "${friendData!.name} ${friendData!.surname}"
          : ""),
      subtitle: Text(
          "The date you met: ${story.meetDate.toDate().toString().substring(0, 10)}"),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                story.story,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
