import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:todolist/providers/edit_tasks.dart';

import 'color_func.dart';

import '../widgets/picker.dart';

import '../providers/state_provider.dart';
import '../providers/content.dart';
import '../storage/textstyles.dart';

PickerItem<dynamic> _listIcon(
  Color color,
  String text,
  context,
) {
  final aha = MediaQuery.of(context).size.width;
  return PickerItem(
      text: Row(
    children: <Widget>[
      SizedBox(
          width:
              //dicker ? (aha * 0.4) / 2 :
              (aha * 0.52) / 2),
      Container(
        margin: const EdgeInsets.only(left: 20,top:5),
        height: 15,
        width: 15,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
      SizedBox(width: 9),
      Expanded(
          child: Padding(
        padding: const EdgeInsets.only(bottom: 4.0, right: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 8),
            AutoSizeText(
              text,
              style: loadingtext,
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      ))
    ],
  ));
}

Padding _canceli({@required context, Function fung}) {
  final _s = Provider.of<StateProvider>(context, listen: false);
  final _c = Provider.of<ContentProvider>(context, listen: false);
  return Padding(
    padding: const EdgeInsets.only(left: 20),
    child: TextButton(
        onPressed: () {
          _s.changeSheetState(0);

          if (fung != null) {
            fung();
          }

          Navigator.pop(context);
        },
        child: Text(_c.cancelC, style: onConfirm)),
  );
}

void showPriority(scaffoldKey, context) {
  final _c = Provider.of<ContentProvider>(context, listen: false);
  final _ch = Provider.of<StateProvider>(context, listen: false);
  final _t = Provider.of<TasksProvider>(context, listen: false);

  _ch.changeSheetState(2);

  List<PickerItem<dynamic>> listPriorites = [];

  final List<String> _impor = _c.importantC;

  for (int i=0; i < 3; i++) {
    listPriorites
        .add(_listIcon(priorityColor(3-i), _impor.elementAt( i), context));
  }

  Future.delayed(const Duration(milliseconds: 200), () {
    Picker(
        title: Text(
          _c.choosePriorityC,
          textAlign: TextAlign.center,
          style: pickoText,
        ),
        onCancel: () {},
        cancel: _canceli(
          context: context,
        ),
        confirmText: _c.donC,
        confirmTextStyle: onConfirm,
        height: 180,
        itemExtent: 70,
        adapter: PickerDataAdapter(data: listPriorites),
        onConfirm: (Picker picker, List value) {
          _t.choosePrio(1+value[0]);
          _ch.changeSheetState(0);
        }).show(scaffoldKey.currentState);
  });
}
