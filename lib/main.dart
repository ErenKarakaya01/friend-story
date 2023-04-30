import 'package:friend_story/screens/wrapper.dart';
import 'package:friend_story/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:friend_story/models/user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserModal>.value(
      value: AuthService().user,
      initialData: UserModal(uid: ""),
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}