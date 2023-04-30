import 'package:friend_story/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid = ""});

  // collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> updateUserData(String name, String surname, DateTime dateOfBirth) async {
    return await userCollection.doc(uid).set({
      'name': name,
      'surname': surname,
      'dateOfBirth': Timestamp.fromDate(dateOfBirth),
    });
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
