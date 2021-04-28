import 'package:flutter/material.dart';

class Task {
  final String title;
  bool done;
  final int importance;//2 is very important; 1 is medium, 0 is ,,good to have''

  Task({@required this.title, @required this.done, @required this.importance});
}
