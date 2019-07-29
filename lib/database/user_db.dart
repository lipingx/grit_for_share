import 'package:firebase_auth/firebase_auth.dart';
import 'package:grit/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDB {
  static final UserDB _userDb = UserDB._internal();

  //private internal constructor to make it singleton
  UserDB._internal();

  String _userId;

  static UserDB get() {
    return _userDb;
  }

  void SetUserId(userId) {
    _userId = userId;
  }

  Future<User> getUser(String userId) async {
    var streamSnapshot = Firestore.instance
        .collection('users')
        .where(
      "userId",
      isEqualTo: userId,
    )
        .snapshots();
    await for (var s in streamSnapshot) {
      List<User> users = convertToUser(s);
      //print("users.len:" + users.length.toString());
      for (User user in users) {
        if (user.userId == userId) {
          print('User exist: ' + user.name);
          return user;
        }
      }
    }
  }

  Future<List<User>> getAllUser() async {
    var streamSnapshot = Firestore.instance.collection('users').snapshots();
    await for (var s in streamSnapshot) {
      List<User> users = convertToUser(s);
      //print("users.len:" + users.length.toString());
      return users;
    }
  }

  List<User> convertToUser(QuerySnapshot query_snapshot) {
    return query_snapshot.documents
        .map((doc) => User.fromSnapshot(doc))
        .toList();
  }

  Future<String> storeUser(userId, email) async {
    Map<String, dynamic> data = <String, dynamic>{
      "userId": userId,
      "email": email,
      "friends": [],
    };
    var newDocRef = Firestore.instance.collection("users").document();
    newDocRef.setData(data).whenComplete(() {
      print("UserDB: User added: " + email);
    }).catchError((e) => print(e));
    return newDocRef.documentID;
  }

  Future addFriend(String userDocId, List<String> friends) async {
    if (userDocId == null) {
      print('UserDB.addFriend: userDocId is null');
      return;
    }
    print('UserDB.addFriend userDocId: $userDocId');
    print('UserDB.addFriend friends: $friends');
    var docRef =
    await Firestore.instance.collection('users').document(userDocId);
    docRef.updateData({
      "friends": friends,
    });

    docRef.get().then((doc) {
      if (doc.exists) {
        print("Document exist:" + userDocId);
      } else {
        print("No such document!");
      }
    });
    return;
  }

  Future<String> getUserIdByEmail(String email) {
//    return "email";
    return null;
  }
}
