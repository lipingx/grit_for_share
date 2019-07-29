import 'package:flutter/material.dart';
import 'package:grit/auth/auth.dart';
import 'package:grit/auth/auth_provider.dart';
//import 'package:keep/pages/home/home_page.dart';
import 'package:grit/pages/root_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthProvider(
      auth: Auth(),
      child: MaterialApp(
        title: 'Flutter login demo',
        routes: <String, WidgetBuilder>{
          //All available pages
          //'/Home': (BuildContext contrext) => HomePage(),
          //'/Second': (BuildContext contrext) => new Second(),
        },
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: RootPage(),
      ),
    );
  }
}
