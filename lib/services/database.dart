import 'package:friend_story/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:friend_story/core/extentions/string_extension.dart";
import "package:friend_story/models/story.dart";

class DatabaseService {
  final String uid;
  DatabaseService({this.uid = ""});

  // collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference storyCollection =
      FirebaseFirestore.instance.collection('stories');

  Future<void> updateUserData(String name, String surname, DateTime dateOfBirth,
      String username) async {
    return await userCollection.doc(uid).set({
      'name': name.capitalize(),
      'surname': surname.capitalize(),
      'dateOfBirth': Timestamp.fromDate(dateOfBirth),
      "username": username,
    });
  }

  Future<List<String>> getUsernames(String query, {int limit = 5}) async {
    List<String> users = [];

    QuerySnapshot snapshot = await userCollection
        // starts with specific value
        .where('username',
            isGreaterThanOrEqualTo: query,
            isLessThan: query.substring(0, query.length - 1) +
                String.fromCharCode(query.codeUnitAt(query.length - 1) + 1))
        // limit to the first 5 results
        .limit(limit)
        .get();

    // add the usernames to the list
    for (var doc in snapshot.docs) {
      users.add(doc['username'].toString());
    }

    return users;
  }

  // get requests stream
  Stream<List<Story>> get requests {
    return storyCollection
        .where('friendUid', isEqualTo: uid)
        .where('accepted', isEqualTo: false)
        .snapshots(includeMetadataChanges: true)
        .map(_storyDataFromSnapshot);
  }

  // get stories stream
  Stream<List<Story>> get stories {
    return storyCollection
        .where('friendUid', isEqualTo: uid)
        .where('accepted', isEqualTo: true)
        .snapshots(includeMetadataChanges: true)
        .map(_storyDataFromSnapshot);
  }

  Future<UserData?> getUserData(String username) async {
    QuerySnapshot snapshot = await userCollection
        .where('username', isEqualTo: username)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    DocumentSnapshot doc = snapshot.docs[0];

    return _userDataFromSnapshot(doc);
  }

  // get user by uid
  Future<UserData?> getUserDataByUid(String uid) async {
    DocumentSnapshot snapshot = await userCollection.doc(uid).get();

    if (!snapshot.exists) {
      return null;
    }

    return _userDataFromSnapshot(snapshot);
  }

  // user data from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: snapshot.reference.id,
        name: snapshot["name"],
        surname: snapshot["surname"],
        dateOfBirth: snapshot["dateOfBirth"],
        username: snapshot["username"]);
  }

  // story list from snapshot
  List<Story> _storyDataFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      //print(doc.data);
      return Story(
        storyId: doc.reference.id,
        userUid: doc['userUid'] ?? "",
        friendUid: doc['friendUid'] ?? '',
        meetDate: doc['meetDate'] ?? '',
        story: doc['story'] ?? '',
        accepted: doc['accepted'] ?? false,
      );
    }).toList();
  }

  Future<DocumentReference<Object?>> addStory(
      String friendUid, DateTime meetDate, String story) async {
    return await storyCollection.add({
      "userUid": uid,
      "friendUid": friendUid,
      "meetDate": Timestamp.fromDate(meetDate),
      "story": story,
      "accepted": false,
    });
  }

  // accept story
  Future<void> acceptStory(String storyId) async {
    return await storyCollection.doc(storyId).update({"accepted": true});
  }

  // reject story
  Future<void> rejectStory(String storyId) async {
    return await storyCollection.doc(storyId).delete();
  }

  // brew list from snapshot
  /* List<User> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      //print(doc.data);
      return Brew(
          name: doc.data['name'] ?? '',
          strength: doc.data['strength'] ?? 0,
          sugars: doc.data['sugars'] ?? '0');
    }).toList();
  } */

  // user data from snapshots
  /* UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: uid,
        name: snapshot.value,
        sugars: snapshot.data()!['sugars'],
        strength: snapshot.data()['strength'],
        );
  } */

  // get brews stream
  /* Stream<List<Brew>> get brews {
    return brewCollection.snapshots().map(_brewListFromSnapshot);
  } */

  // get user doc stream
  /* Stream<UserData> get userData {
    return brewCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  } */
}
