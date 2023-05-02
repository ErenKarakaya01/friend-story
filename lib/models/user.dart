import 'package:cloud_firestore/cloud_firestore.dart';

class UserModal {
  final String uid;

  UserModal({required this.uid});
}

class UserData {
  final String uid;
  final String name;
  final String surname;
  final String username;
  final Timestamp dateOfBirth;

  UserData(
      {required this.uid,
      required this.name,
      required this.surname,
      required this.username,
      required this.dateOfBirth});
}
