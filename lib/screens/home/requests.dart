import 'package:flutter/material.dart';
import 'package:friend_story/services/database.dart';
import "package:provider/provider.dart";

import '../../models/story.dart';
import '../../models/user.dart';
import '../../services/auth.dart';
import 'components/request_list.dart';

class Requests extends StatefulWidget {
  const Requests({super.key});

  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  final AuthService _auth = AuthService();
  
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModal>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Requests"),
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
          uid: user.uid,// false because we want to see unaccepted stories
        ).requests,
        initialData: const [],
        child: const RequestList(),
      ),
    );
  }
}
