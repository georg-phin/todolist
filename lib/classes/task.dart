import 'package:flutter/material.dart';

class Task {
  final String title;
  bool done;
  final int importance;//3 is very important; 2 is medium, 1 is ,,good to have''

  Task({@required this.title, @required this.done, @required this.importance});
}
