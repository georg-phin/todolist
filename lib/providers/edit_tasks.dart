import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:async';
import 'dart:convert';

import '../classes/task.dart';

class TasksProvider with ChangeNotifier {
  final int _currentTestUser = 1;
  final int minImpo = 1; //min priority
  final int maxImpo = 3; //max priority
  List<int> sortedKey = [];
  bool titleEmpty = true; //inorder to trigger the icon in the appbar
  int newPriority = 0; //0 means not set

  int currentTasks = 0;

  bool fetched = false;
  bool failed = false;

  Map<int, Task> tasks =
      {}; //key is taskid//class task consists of title & done

  int triggerUi =
      0; //as map changes dont trigger selector, we use an extra variable to trigger rebuild for the listview

  int latestKey = 0; //as your example uses normal integers as keys

  int makeNewKey() {
    latestKey = latestKey + 1;

    return latestKey;
  }

  void typeTitle(bool typed){
    titleEmpty = typed;
    notifyListeners();

  }

  void choosePrio(int how){
    newPriority = how;
    notifyListeners(); 
  }

  int makeRandomImportance() {
    //for the testdata as it doesnt include priority

    final Random _random = new Random();

    return minImpo + _random.nextInt(maxImpo - minImpo + 1);
    //return
  }

  void sort() {
    //makes a sorted list by the priority
   List<int> doneList = tasks.entries.where((ele) => ele.value.done).map((e) => e.key).toList(growable: false)
      ..sort(
          (k2, k1) => (tasks[k1].importance).compareTo(tasks[k2].importance));
    List<int> openList = tasks.entries.where((ele) => !ele.value.done).map((e) => e.key).toList(growable: false)
      ..sort(
          (k2, k1) => (tasks[k1].importance).compareTo(tasks[k2].importance));

        sortedKey = [...openList,...doneList];
  }

  void triggerRebuild() {
    triggerUi = triggerUi + 1;
    notifyListeners();
  }

  void addTask(String title, int importance) {
    tasks[makeNewKey()] =
        Task(title: title, done: false, importance: importance);
    titleEmpty = true;
    newPriority = 0;
    currentTasks = currentTasks + 1;
    sort();
    triggerRebuild();
  }

  void doneUndone(int id) {
    tasks.update(id, (thisTask) {
      final bool currentBool = thisTask.done;

      currentTasks = currentBool ? currentTasks - 1 : currentTasks + 1;

      return Task(
          title: thisTask.title,
          done: !currentBool,
          importance: thisTask.importance);
    });
    triggerRebuild();
  }

  void deleteTask(int taskId) {
    if (tasks.containsKey(taskId)) {
      tasks.remove(taskId);
      currentTasks = currentTasks - 1;
      sort();
      triggerRebuild();
    }
    //error task couldnt be deleted
  }

  void newTry() {
    failed = false;
    notifyListeners(); //reset fail to false
  }

  Future<void> fetchTestData() async {
    //only the user of the task can see its own tasks and no one else
    //this app simulates the testuser 1/ fetches data for testuser 1
    failed = false;

    void _fail() {
      failed = true;
      notifyListeners();
    }

    try {
      await http
          .get(
            Uri.https("jsonplaceholder.typicode.com", "todos"),
          )
          .timeout(Duration(seconds: 9))
          .then((res) {
        final List _tasklist = json.decode(res.body);

        _tasklist.forEach((ele) {
          //ele is a map

          if (ele['userId'] == _currentTestUser) {
            final bool completed = ele['completed'];
            final int _id = ele['id'];
            tasks[_id] = Task(
                title: ele['title'],
                importance:makeRandomImportance(),
                done: completed);

            if (_id > latestKey) {
              latestKey = _id;
            }
            if (!completed) {
              currentTasks = currentTasks + 1;
            }
          }
        });

        fetched = true;
        failed = false;
        sort();
        notifyListeners();
      });
    } on TimeoutException {
      _fail();
    } on SocketException {
      _fail();
    } catch (e) {
      print(e); //you can show error diolog if youwant to

    }
  }
}
