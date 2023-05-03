import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:friend_story/models/user.dart';
import 'package:friend_story/services/database.dart';
import 'package:provider/provider.dart';
import 'package:random_avatar/random_avatar.dart';

import '../../../models/story.dart';

class RequestTile extends StatefulWidget {
  final Story request;
  const RequestTile({super.key, required this.request});

  @override
  State<RequestTile> createState() => _RequestTileState();
}

class _RequestTileState extends State<RequestTile> {
  UserData? friendData;

  @override
  void initState() {
    super.initState();
    DatabaseService().getUserDataByUid(widget.request.userUid).then((friend) {
      setState(() {
        friendData = friend;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final request = widget.request;
    return ExpansionTile(
      leading: RandomAvatar(request.userUid,
          trBackground: true, height: 50, width: 50),
      title: Text(friendData != null
          ? "${friendData!.name} ${friendData!.surname}"
          : ""),
      subtitle: Text(
          "The date you met: ${request.meetDate.toDate().toString().substring(0, 10)}"),
      children: <Widget>[
        Row(
          children: [
            IconButton(
              onPressed: () {
                DatabaseService(uid: request.friendUid)
                    .acceptStory(request.storyId);
              },
              icon: const Icon(Icons.check),
              color: Colors.green,
            ),
            IconButton(
              onPressed: () {
                DatabaseService(uid: request.friendUid)
                    .rejectStory(request.storyId);
              },
              icon: const Icon(Icons.close),
              color: Colors.red,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                request.story,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
