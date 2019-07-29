import 'dart:async';
import 'package:grit/bloc/bloc_provider.dart';
import 'package:grit/models/models.dart';
import 'package:grit/database/db.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc implements BlocBase {
  BehaviorSubject<List<User>> _userListController =
  BehaviorSubject<List<User>>();

  Stream<List<User>> get users => _userListController.stream;

  User currentUser;
  BehaviorSubject<User> _userController = BehaviorSubject<User>();

  Stream<User> get currentUserStream => _userController.stream;

  BehaviorSubject<List<String>> _currentUserFriends = BehaviorSubject<List<String>>();

  Stream<List<String>> get currentUserFriends => _currentUserFriends.stream;

  BehaviorSubject<String> _arg2 = BehaviorSubject<String>();

  Stream<String> get arg2 => _arg2.stream;

  final UserDB userDb;
  final String userId;
  String userDocId;
  String _friendUserId;

  // Store all users in memory.
  Map<String, String> docIdToEmail = Map();
  Map<String, String> emailToUserId = Map();
  Map<String, String> userIdToEmail = Map();
  Map<String, String> userIdToDocId = Map();

  UserBloc(this.userDb, this.userId) {
    _loadAllUsers();
  }

  @override
  void dispose() {
    print('-------------------- UserBloc dipsonse');
    _userListController.close();
    _userController.close();
  }

//  void getCurrentUser() {
//    userDb.getUser(userId).then((user) {
//      _currentUser = user;
//      print('UserBloc _currentUser: $_currentUser');
//      _userController.sink.add(user);
//    });
//  }

  void _loadAllUsers() {
    userDb.getAllUser().then((users) {
      for (var user in users) {
        //print('--------user.email: ${user.email}');
//        print('--------user.userId: ${user.userId}');
        docIdToEmail[user.docId] = user.email;
        emailToUserId[user.email] = user.userId;
        userIdToDocId[user.userId] = user.docId;
        userIdToEmail[user.userId] = user.email;
      }
      // Get current user.
      for (var user in users) {
        if (user.userId == userId) {
          //print('UserBloc map has userId $userId');
          userDocId = userIdToDocId[userId];
          //print('UserBloc: userDocId $userDocId');
          currentUser = user;
          //print('UserBloc _currentUser: ${_currentUser.email}');
          _userController.sink.add(user);
          currentUser.friendsEmails = currentUser.friends.map((friendUserId) => userIdToEmail[friendUserId]).toList();
          //print('friendsEmails : ${_currentUser.friendsEmails}');
          _currentUserFriends.sink.add(currentUser.friendsEmails);
          return;
        }
        //print('UserBloc map doesnot have $userId');
      }
    });
  }

  String getUserIdByEmail(String userEmail) {
    if (!emailToUserId.containsKey(userEmail)) {print('No such user.'); return null;}
    return emailToUserId[userEmail];
//    userDb.getUserIdByEmail(userEmail);
  }

  bool IsUserExistByEmail(String userEmail){
    print('IsUserExistByEmail called');
    //var exist = EmailToUserId.containsKey(userEmail);
    return emailToUserId.containsKey(userEmail);
  }

  bool IsFriend(String userEmail) {
//    print('EmailToUserId[userEmail]:' +  EmailToUserId[userEmail]);
//    bool isFriend = _currentUser.friends.contains(EmailToUserId[userEmail]);
    bool isFriend = currentUser.friendsEmails.contains(userEmail);
    print('isFriend $isFriend');
    return currentUser.friendsEmails.contains(userEmail);
  }

  void setFriendUserId(String friendEmail) {
    _friendUserId = getUserIdByEmail(friendEmail);
    print('set _friendUserId: $_friendUserId');
  }

  Observable<String> addFriend() {
//    _arg1.add();
    _arg2.add('arg2');
    print('Add frined');
    if (_friendUserId != null) {
      return Observable.zip2(currentUserFriends, arg2, (List<String> currentUserFriends, String arg2) {
        print('Before call addFriend: _currentUser.friends: ${currentUser.friends}');
        userDb
            .addFriend(userDocId, currentUser.friends + [_friendUserId])
            .then((_) {
          print('Add friend to $userDocId done');
        });
      });
    } else {
      print('_friendUserId is null.');
    }
  }

  void storeUser(userId, email) async {
    userDocId = await userDb.storeUser(userId, email);
  }
}
