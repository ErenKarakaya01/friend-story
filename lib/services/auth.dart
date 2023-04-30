import 'package:friend_story/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:friend_story/models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on firebase user
  UserModal _userFromFirebaseUser(User? user) {
    return user != null ? UserModal(uid: user.uid) : UserModal(uid: "");
  }

  // auth change user stream
  Stream<UserModal> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  // sign in anon
  /* Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  } */

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(String email, String password,
      String name, String surname, DateTime dateOfBirth) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      // update the user display name
      await user?.updateDisplayName(name.toLowerCase() + " " + surname.toLowerCase());

      // create a new document for the user with the uid
      await DatabaseService(uid: user!.uid)
          .updateUserData(name, surname, dateOfBirth);

      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}
