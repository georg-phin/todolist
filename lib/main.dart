import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/providers/state_provider.dart';


import 'helpers/custom_route.dart';

import 'storage/colors.dart';

import 'providers/content.dart';
import 'providers/edit_tasks.dart';

import 'screens/loading_screen.dart';
import 'screens/add_new_task_screen.dart';
import 'screens/todolist_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
   

    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: TasksProvider(),
          ),
          ChangeNotifierProvider.value(
            value: ContentProvider(),
          ),
          ChangeNotifierProvider.value(
            value: StateProvider(),
          ),
        ],
        //fetchDeviceLanguage()
        child: MaterialApp(theme: ThemeData(fontFamily: 'Raleway',
          
          
          iconTheme: IconThemeData(color: writeColorfocus),  pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.android: CustomPageTransitionBuilder(),
            TargetPlatform.iOS: CustomPageTransitionBuilder(),
          }),),
            debugShowCheckedModeBanner: false,
           
            title: 'ToDoList',
            initialRoute: '/',
            routes: {
              '/': (ctx) {
                 Provider.of<ContentProvider>(ctx, listen: false).fetchDeviceLanguage();
                Provider.of<TasksProvider>(ctx, listen: false).fetchTestData();

                return Selector<TasksProvider, bool>(
                    selector: (_, lul) => lul.fetched,
                    builder: (_, fetched, __) =>
                        fetched ? ToDoListScreen() : LoadingScreen());
              },
              ToDoListScreen.routeName: (_) => ToDoListScreen(),
              AddNewTaskScreen.routeName: (_) => AddNewTaskScreen(),
              LoadingScreen.routeName: (_) => LoadingScreen(),
         
            }));
  }
}
