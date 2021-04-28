import 'dart:io';

import 'package:flutter/material.dart';

class ContentProvider with ChangeNotifier {
  //content is in a changenotifier class to add a language change option for later developement

  String currentlanguage = 'en';

////------ content variables

  String newTaskC =
      ''; //c stands for content variable to avoid conflicts with other files
  String addNewTaskC = '';
  String titleC = '';
  String importanceC = '';
  String myTasksC = '';
  String checkYourInternet = '';
  String loadingDataC = '';

  String deletedC = '';
  String completedC = '';
  String unCompletedC = '';
  String choosePriorityC = '';

  String addTitleC = '';
  String addPriorityC = '';
  String deleteC = '';
  String doneC = '';
  String entryAddedC = '';
  String markC = '';
  String cancelC = '';
  String donC = '';

  List<String> importantC = [];

  void fetchDeviceLanguage() {
    String currentlanguage = Platform.localeName == null
        ? 'en'
        : Platform.localeName.substring(0, 2);
    switch (currentlanguage) {
      case 'de':
        newTaskC = 'Neue Aufgabe';
        addNewTaskC = 'Füge eine Aufgabe hinzu';
        myTasksC = 'Meine Aufgaben';
        checkYourInternet = 'Check your Internet';
        loadingDataC = 'Daten werden geladen...';
        titleC = 'Titel';
        importanceC = 'Priorität';
        choosePriorityC = 'Priorität auswählen';
        importantC = ['sehr wichtig', 'wichtig', 'weniger wichtig'];

        addTitleC = 'Titel hinzufügen';
        addPriorityC = 'Priorität hinzufügen';
        deletedC = 'Eintrag wurde gelöscht';
        completedC = 'geschafft ✓';
        unCompletedC = 'wieder makiert';
        deleteC = 'Löschen';
        doneC = 'Fertig';
        entryAddedC = 'Aufgabe wurde hinzugefügt ✓';
        markC = 'Markieren';
        cancelC = 'zurück';
        donC = 'fertig';
        break;
      default: //default is english
        newTaskC = 'New Task';
        deletedC = 'Entry has been deleted';
        importantC = ['very important', 'important', 'less important'];
        addNewTaskC = 'Add a new task';
        choosePriorityC = 'choose priority';
        titleC = 'Title';
        checkYourInternet = 'Überprüfe Deine InternetVerbindung';
        importanceC = 'Priority';
        myTasksC = 'My Tasks';
        loadingDataC = 'laoding data...';
        addTitleC = 'add title';
        addPriorityC = 'add priority';
        entryAddedC = 'entry has been added ✓';
        completedC = 'completed';
        unCompletedC = 'wieder makiert';
        deleteC = 'Delete';
        doneC = 'Done';
        markC = 'Tag';
        cancelC = 'cancel';
        donC = 'done';
        currentlanguage = 'en'; //set to english if not to german or not english
        break;
    }
  }
}
