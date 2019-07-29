import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String docId;
  String userId;
  String name;
  String email;
  List<String> friends = List();
  List<String> friendsEmails = List();
//  final DocumentReference reference = null;
//
  User.fromMap(Map<String, dynamic> map, DocumentReference reference)
      : //assert(map['userId'] != null),
  //assert(map['name'] != null),
        name = map['name'],
        userId = map['userId'],
        email  = map['email'],
        friends =  (map['friends'] as List).cast<String>().toList(),
        docId = reference.documentID;
  //
  User.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, snapshot.reference);

  User.create(this.userId,this.email, this.name,);

  bool operator ==(o) => o is User && o.docId == docId;
}