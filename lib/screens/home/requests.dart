import 'package:flutter/material.dart';
import 'package:friend_story/services/database.dart';
import "package:provider/provider.dart";

import '../../models/story.dart';
import '../../models/user.dart';
import 'components/request_list.dart';

class Requests extends StatefulWidget {
  const Requests({super.key});

  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModal>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Requests"),
        backgroundColor: Colors.blue[400],
      ),
      body: StreamProvider<List<Story>>.value(
        value: DatabaseService(
          uid: user.uid,
          isAccepted: false,
        ).stories,
        initialData: const [],
        child: const RequestList(),
      ),
    );
  }
}
