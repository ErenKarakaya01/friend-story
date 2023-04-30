import 'package:friend_story/models/user.dart';
import 'package:friend_story/screens/authenticate/authenticate.dart';
import 'package:friend_story/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModal>(context);

    // return either the Home or Authenticate widget
    if (user.uid == "") {
      return Authenticate();
    } else {
      print(user.uid);
      return Home();
    }
  }
}
