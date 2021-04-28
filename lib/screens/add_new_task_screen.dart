import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/functions/color_func.dart';
import 'package:todolist/functions/priority_picker.dart';
import 'package:todolist/items/user_input/gesture_dec.dart';
import 'package:todolist/providers/state_provider.dart';

import '../functions/sheet.dart';

import '../widgets/flushbar/flushbar.dart';

import '../storage/colors.dart';

import '../storage/foundation.dart';
import '../storage/textstyles.dart';

import '../providers/content.dart';
import '../providers/edit_tasks.dart';

class AddNewTaskScreen extends StatelessWidget {
  static String routeName = '/AddNewTaskScreen';

  static GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>(debugLabel: 'AddNewTaskScreen');
  final TextEditingController controllerF = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final _c = Provider.of<ContentProvider>(context, listen: false);
    final _t = Provider.of<TasksProvider>(context, listen: false);
    final _mediaQuery = MediaQuery.of(context).size;

    final double _w = _mediaQuery.width;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(_c.newTaskC, style: headerText),
        backgroundColor: primaryColor,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Selector<TasksProvider, int>(
              selector: (_, lul) => lul.newPriority,
              builder: (_, prio, __) => Selector<TasksProvider, bool>(
                  selector: (_, lul) => lul.titleEmpty,
                  builder: (_, title, __) {
                    final bool _go = !title && prio != 0;
                    return InkWell(
                        splashColor: Colors.transparent,
                        onTap: () {
                          justschlies(context);
                          if (_go) {
                        
                            _t.addTask(controllerF.text,4- prio);

                            Navigator.of(context).pop();
                               flushi(_c.entryAddedC, context, 2000);
                          } else {
                            flushi(
                              !title ? _c.addPriorityC : _c.addTitleC,
                              context,
                              2000,
                            );
                          }
                        },
                        child: Icon(
                          Icons.done,
                          size: 35,
                          color: _go ? writeColorfocus : writeColorUn,
                        ));
                  }),
            ),
          )
        ],
        leading: InkWell(
            child: Icon(isIos ? CupertinoIcons.back : Icons.arrow_back,
                size: 30, color: writeColorfocus),
            splashColor: Colors.transparent,
            onTap: () {
              justschlies(context);
              Navigator.pop(context);
            }),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              SizedBox(width: 20),
              Column(
                children: <Widget>[
                  const SizedBox(height: 5),
                  const Icon(Icons.title, color: primaryColor, size: 37),
                ],
              ),
              const SizedBox(width: 14),
              Container(
                width: _w * 0.75,
                constraints:
                    BoxConstraints(maxHeight: _mediaQuery.height * 0.25),
                child: TextField(
                  onTap: () {
                    schliesUpdate(false, context);
                  },
                  onChanged: (l) => _t.typeTitle(l.isEmpty),
                  onSubmitted: (str) {
                    final _s =
                        Provider.of<StateProvider>(context, listen: false);

                    _s.changeSheetState(0);
                  },
                  autofocus: false,
                  autocorrect: true,
                  enableSuggestions: true,
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.text,
                  maxLines: null,
                  maxLength: 80,
                  style: focusText,
                  cursorColor: icoColor,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(
                        left: 0), //sonst komischer bug
                    counterText: '',
                    hintText: _c.titleC,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: primaryColor),
                    ),
                    hintStyle: unfocusText,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: primaryColor),
                    ),
                  ),
                  controller: controllerF,
                ),
              ),
            ],
          ),
          const SizedBox(height: 45),
          Selector<TasksProvider, int>(
            selector: (_, lul) => lul.newPriority,
            builder: (_, newPriority, __) => SelectTransactionGesture(
                typedText: newPriority == 0
                    ? _c.importanceC
                    : _c.importantC.elementAt(newPriority - 1),
                onPress: () {
                  schliesUpdate(true, context);
                  showPriority(scaffoldKey, context);
                },
                lead: Icon(Icons.style,
                    size: 39,
                    color: newPriority == 0
                        ? primaryColor
                        : priorityColor(4 - newPriority)),
                hell: newPriority == 0),
          ),
          const SizedBox(height: 45),
        ],
      ),
    );
  }
}
