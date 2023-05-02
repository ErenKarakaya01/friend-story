import 'package:cloud_firestore/cloud_firestore.dart';

class Story {
  final String storyId;
  final String userUid;
  final String friendUid;
  final Timestamp meetDate;
  final String story;
  final bool accepted;

  Story(
      {required this.storyId,
      required this.userUid,
      required this.friendUid,
      required this.meetDate,
      required this.story,
      required this.accepted});
}
