import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todolist/functions/color_func.dart';
import 'package:todolist/widgets/flushbar/flushbar.dart';

import '../classes/task.dart';

import '../storage/colors.dart';
import '../storage/textstyles.dart';

import '../screens/add_new_task_screen.dart';

import '../providers/edit_tasks.dart';
import '../providers/content.dart';

class ToDoListScreen extends StatelessWidget {
  static String routeName = '/ToDoListScreen';
  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;

    final double _w = _mediaQuery.width;
    final _c = Provider.of<ContentProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: backgroundColor,
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () =>
            Navigator.pushNamed(context, AddNewTaskScreen.routeName),
        tooltip: 'add',
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        title: Selector<TasksProvider, int>(
            selector: (_, lul) => lul.currentTasks,
            builder: (_, current, __) =>
                Text('${_c.myTasksC} ($current)', style: headerText)),
      ),
      body: Selector<TasksProvider, int>(
          selector: (_, lul) => lul.triggerUi,
          builder: (_, marked, __) {
            final _t = Provider.of<TasksProvider>(context, listen: false);
            final Map<int, Task> _tasks = _t.tasks;

            return _tasks.isEmpty
                ? SizedBox(
                    width: _w,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 14.0),
                            child: Text(
                              _c.addNewTaskC,
                              style: normaltext,
                              textAlign: TextAlign.center,
                            ),
                          )
                        ]),
                  )
                : ListView.builder(
                    itemCount: _tasks.length,
                    itemBuilder: (__, int i) {
                      final int _key = _t.sortedKey.elementAt(i);
                      final Task _task = _t.tasks[_key];
                      final bool _done = _task.done;

                      final Color _prioCol = priorityColor(_task.importance);

                      return Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 0.25,
                        child: Container(
                          height: 75,
                          //color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 20,top:4),
                                height: 15,
                                width: 15,
                                decoration: BoxDecoration(
                                    color:
                                        _done ? Colors.transparent : _prioCol,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: _prioCol,
                                        width: _done ? 2.0 : 0.0)),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 21.0),
                                  child: AutoSizeText(
                                    _task.title,
                                    style: _done ? doneText : loadingtext,
                                    maxLines: 2,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        secondaryActions: <Widget>[
                          IconSlideAction(
                            caption: _done ? _c.markC : _c.doneC,
                            color: lightDark,
                            icon: _done ? Icons.push_pin : Icons.done,
                            onTap: () {
                              flushi(_done ? _c.unCompletedC : _c.completedC,
                                  context, 1000);
                              _t.doneUndone(_key);
                            },
                          ),
                          IconSlideAction(
                              caption: _c.deleteC,
                              color: deleteColor,
                              icon: Icons.delete,
                              onTap: () {
                                flushi(_c.deletedC, context, 1000);
                                _t.deleteTask(_key);
                              }),
                        ],
                      );
                    },
                  );
          }),
    );
  }
}
