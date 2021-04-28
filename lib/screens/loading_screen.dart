import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/storage/textstyles.dart';


import '../providers/content.dart';
import '../storage/colors.dart';

import '../providers/edit_tasks.dart';

import '../items/loading_item.dart';

class LoadingScreen extends StatelessWidget {
  static String routeName = 'LoadingScreen';

  @override
  Widget build(BuildContext context) {
    final _c = Provider.of<ContentProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: backgroundColor,
          body: Selector<TasksProvider, bool>(
          selector: (_, lul) => lul.failed,
          builder: (_, failed, __) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    failed
                        ? InkWell(
                            child: Icon(Icons.refresh,
                                color: writeColorfocus, size: 50),
                            onTap: () {
                              Provider.of<TasksProvider>(context, listen: false)
                                  .fetchTestData();
                            },
                          )
                        : indicator(true),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                          padding: const EdgeInsets.only(
                              top: 16.0, left: 16, right: 16),
                          child: AutoSizeText(
                              failed ? _c.checkYourInternet : _c.loadingDataC,
                              style: loadingtext,
                              textAlign: TextAlign.center)),
                    ),
                  ])),
    );
  }
}
