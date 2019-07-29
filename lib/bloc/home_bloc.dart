import 'dart:async';
import 'package:grit/bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class HomeBloc implements BlocBase {
  StreamController<String> _titleController =
  StreamController<String>.broadcast();

//  Stream<String> get title => _titleController.stream;
//
//  StreamController<Filter> _filterController =
//  StreamController<Filter>.broadcast();
//
//  Stream<Filter> get filter => _filterController.stream;
//
  @override
  void dispose() {
    _titleController.close();
  }
//
//  void updateTitle(String title) {
//    _titleController.sink.add(title);
//  }
//
//  void applyFilter(String title, Filter filter) {
//    _filterController.sink.add(filter);
//    updateTitle(title);
//  }
}
