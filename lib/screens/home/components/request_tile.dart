import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:friend_story/models/user.dart';
import 'package:friend_story/services/database.dart';
import 'package:provider/provider.dart';

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
    DatabaseService().getUserDataByUid(widget.request.friendUid).then((friend) {
      setState(() {
        friendData = friend;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final request = widget.request;
    return ExpansionTile(
      leading: const CircleAvatar(
        backgroundImage: AssetImage("assets/avatar.png"),
      ),
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
        SizedBox(height: 40),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              child: Text(
                request.story,
              ),
            ),
          ),
        ),
        SizedBox(height: 40),
      ],
    );

    /* Container(
      height: 100,
      width: 100,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Expanded(
            child: ListTile(
              leading: const CircleAvatar(
                backgroundImage: AssetImage("assets/images/profile.png"),
              ),
              title: Text(friendData != null ? "${friendData!.name} ${friendData!.surname}" : ""),
              subtitle: Text(request.meetDate.toDate().toString().substring(0, 10)),
              trailing: Row(children: [
                IconButton(
                  onPressed: () {
                    DatabaseService(uid: request.friendUid).acceptStory(request.storyId);
                  },
                  icon: const Icon(Icons.check),
                ),
                IconButton(
                  onPressed: () {
                    DatabaseService(uid: request.friendUid).rejectStory(request.storyId);
                  },
                  icon: const Icon(Icons.close),
                ),
              ],)
            ),
          ),
        ),
      ),
    ); */
  }
}
