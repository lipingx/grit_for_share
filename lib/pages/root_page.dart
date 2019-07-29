import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grit/auth/auth.dart';
import 'package:grit/bloc/user_bloc.dart';
import 'package:grit/database/db.dart';
import 'package:grit/pages/login_page.dart';
import 'package:grit/auth/auth_provider.dart';
import 'package:grit/pages/main_page.dart';

class RootPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RootPageState();
}

enum AuthStatus {
  notDetermined,
  notSignedIn,
  signedIn,
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.notDetermined;
  String _userId;
  UserBloc userBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final BaseAuth auth = AuthProvider.of(context).auth;
    auth.currentUser().then((FirebaseUser user) {
      setState(() {
        _userId = user?.uid;
        authStatus =
        _userId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
        userBloc = UserBloc(UserDB.get(), _userId);
      });
    });
  }

  void _signedIn() {
    setState(() {
      authStatus = AuthStatus.signedIn;
      didChangeDependencies();
    });
  }

  void _signedOut() {
    setState(() {
      authStatus = AuthStatus.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    //UserBloc userBloc = UserBloc(UserDB.get(), _userId);
    switch (authStatus) {
      case AuthStatus.notDetermined:
        return _buildWaitingScreen();
      case AuthStatus.notSignedIn:
        return LoginPage(
          _signedIn,
          userBloc,
        );
      case AuthStatus.signedIn:
        return MainPage(
          userBloc: userBloc,
          onSignedOut: _signedOut,
          userId: _userId,
        );
    }
    return null;
  }

  Widget _buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }
}
