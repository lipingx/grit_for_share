import 'package:flutter/material.dart';
import 'package:grit/auth/auth.dart';
import 'package:grit/auth/auth_provider.dart';
import 'package:grit/bloc/bloc.dart';
import 'package:grit/bloc/user_bloc.dart';
import 'package:grit/database/db.dart';

//import 'package:grit/pages/labels/label_page.dart';
import 'package:grit/models/models.dart';
import 'package:grit/pages/home/about_page.dart';
import 'package:grit/pages/home/guide_page.dart';

class SideDrawer extends StatelessWidget {
  final HomeBloc homeBloc;

//  final LabelBloc labelBloc;
  final String userId;
  final VoidCallback onSignedOut;

  SideDrawer({this.homeBloc, this.userId, this.onSignedOut});

  Future<void> _signOut(BuildContext context) async {
    try {
      final BaseAuth auth = AuthProvider.of(context).auth;
      await auth.signOut();
      onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    //HomeBloc homeBloc = BlocProvider.of(context);
    UserBloc userBloc = UserBloc(UserDB.get(), userId);
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: StreamBuilder(
                stream: userBloc.currentUserStream,
                initialData: User.create(userId, '', ''),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    print('SideDrawer: userBloc.currentUser: has no data');
                    return Container();
                  } else {
                    return Text(snapshot.data?.email);
                  }
                }),
            decoration: new BoxDecoration(
                image: new DecorationImage(
                    image: new NetworkImage(
                        "https://img00.deviantart.net/35f0/i/2015/018/2/6/low_poly_landscape__the_river_cut_by_bv_designs-d8eib00.jpg"),
                    fit: BoxFit.fill)),
// Email
//            accountEmail: StreamBuilder(
//              stream: userBloc.user,
//              initialData: User.create(userId, ''),
//              builder: (context, snapshot) =>
//                  Text(snapshot.data.name),
//            ),
//            otherAccountsPictures: <Widget>[
//              IconButton(
//                  icon: Icon(
//                    Icons.info,
//                    color: Colors.white,
//                    size: 36.0,
//                  ),
//                  onPressed: () {
////                    Navigator.push(
////                      context,
////                      MaterialPageRoute<bool>(
////                          builder: (context) => AboutUsScreen()),
////                    );
//                  })
//            ],
//            currentAccountPicture: CircleAvatar(
//              backgroundColor: Theme.of(context).accentColor,
//              //backgroundImage: AssetImage("assets/profile_pic.jpg"),
//            ),
          ),

          ListTile(
            leading: Icon(Icons.account_box),
            title: Text("About us"),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute<bool>(builder: (context) => AboutPage()),
              );
            },
          ),
          ListTile(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute<bool>(builder: (context) => GuidePage()),
                );
              },
              leading: Icon(Icons.live_help),
              title: Text("How to use?")),
//          LabelPage(labelBloc, homeBloc),
//          BlocProvider(
//            bloc: LabelBloc(labelDb:LabelDB.get(), userId:userId),
//            child: LabelPage(),
//          ),

          FlatButton(
            child: Text('Logout',
                style: TextStyle(fontSize: 17.0, color: Colors.red[300])),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
    );
  }
}
