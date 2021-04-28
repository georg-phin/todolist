
import 'package:flutter/material.dart';


class StateProvider with ChangeNotifier {



int openSheet=0;//0 is nothing //1 is keyboard //2 is bottomsheet


void changeSheetState(int how){
  openSheet = how;
}

}