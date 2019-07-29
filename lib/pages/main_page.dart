import 'package:flutter/material.dart';
import 'package:grit/bloc/bloc.dart';
import 'package:grit/bloc/bloc_provider.dart';
import 'package:grit/bloc/home_bloc.dart';
//import 'package:grit/bloc/search_by_labels_bloc.dart';
import 'package:grit/bloc/user_bloc.dart';
import 'package:grit/database/db.dart';
import 'package:grit/pages/home/home_page.dart';
import 'package:grit/pages/quiz/quiz_page.dart';
import 'package:grit/pages/quiz/scroll_quiz_page.dart';
import 'package:grit/pages/records/records_page.dart';

class MainPage extends StatefulWidget {
  final VoidCallback onSignedOut;
  final String userId;
  final UserBloc userBloc;

  MainPage({this.userBloc, this.onSignedOut, this.userId});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>  with SingleTickerProviderStateMixin {
  TabController tabController;
//  RecordBloc recordBloc;
  HomeBloc homeBloc;
//  LabelBloc labelBloc;

  @override
  Widget initState() {
    print('***************** MainPage From initState');
    super.initState();
    tabController = new TabController(length: 2, vsync: this);
//    recordBloc = RecordBloc(
//      recordDb: RecordDB.get(),
//      labelDb: LabelDB.get(),
//      userId: widget.userId,);
//    homeBloc = HomeBloc();
//    labelBloc =  LabelBloc(labelDb:LabelDB.get(), userId:widget.userId);
  }
  @override
  void dispose() {
    print('***************** MainPage From dispose');
    tabController.dispose();
//    recordBloc?.dispose();
    homeBloc?.dispose();
//    labelBloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('***************** MainPage From build');
    return Scaffold(
      body: _buildBody(context),
      bottomNavigationBar: Material(
        color: Colors.blue,
        child: TabBar(controller: tabController, tabs: <Widget>[
          Tab(icon: Icon(Icons.description), text: 'Ask Question',),
          Tab(icon: Icon(Icons.label), text: 'Quiz',),
          //Tab(icon: Icon(Icons.label)),
        ]),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return TabBarView(
      //children: <Widget>[_buildHomePage(), ], _buildSeachByLabelsPage(), _buildLabelsPage()],
      children: <Widget>[_buildHomePage(), _buildRecordPage()],
      controller: tabController,
    );
  }

  Widget _buildHomePage() {
    return HomePage(
      homeBloc: homeBloc,
//      recordBloc: recordBloc,
//      labelBloc: labelBloc,
      userBloc: widget.userBloc,
      onSignedOut: widget.onSignedOut,
      userId: widget.userId,
    );
  }

  Widget _buildRecordPage() {
    //return Quiz1();
    return QuizPage();
  }
//  Widget _buildSeachByLabelsPage() {
//    print('mainpage: _buildSeachByLabelsPage');
//    return SearchByLabelsPage(widget.userId, recordBloc, labelBloc, widget.userBloc);
////    return BlocProvider(
////        bloc: SearchByLabelsBloc(RecordDB.get(), LabelDB.get(), SearchByLabelsHistoryDB.get(), widget.userId),
////        child: SearchByLabelsPage(widget.userId, recordBloc, LabelBloc(labelDb:LabelDB.get(), userId: widget.userId), widget.userBloc)
////    );
//  }
//
//  Widget _buildLabelsPage() {
//    print('mainpage: _buildLabelsPage');
//    return LabelsPage(widget.userId, recordBloc);
//  }
}