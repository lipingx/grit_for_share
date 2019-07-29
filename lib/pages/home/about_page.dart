import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("About")),
        body: Container(
          //padding: EdgeInsets.all(20),
          padding: EdgeInsets.symmetric(vertical: 40, ),

          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Text(
                  'Grit is a tutoring platform to let students post questions and get answers from people all around the world!',
                  style: TextStyle(fontSize: 18, ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 15, ),
                child: Text(
                  'Contact us: grit.corp@support.com',
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
              ),

              Container(
                padding: EdgeInsets.symmetric(vertical: 15, ),
                child: Text(
                  'TERMS OF USE',
                  style: TextStyle(fontSize: 18,),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 15, ),
                child: Text(
                  'PRIVACY POLICY',
                  style: TextStyle(fontSize: 18,),
                ),
              ),
            ],
          ),
        ));
  }
}
