import 'package:flutter/material.dart';

class GuidePage extends StatelessWidget {
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
                  'Just take a picture of your question, upload it. And wait for some tutor to answer your question.',
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
            ],
          ),
        ));
  }
}
