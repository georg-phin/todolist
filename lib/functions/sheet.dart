
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';


import '../providers/state_provider.dart';


void schliesUpdate(bool bottomShett, context) {
  final _s = Provider.of<StateProvider>(context, listen: false);
  final int jup = _s.openSheet;
  final int fals = !bottomShett ? 2 : 1;
  final int neu = !bottomShett ? 1 : 2;

  if (jup == fals) {
    bottomShett
        ? FocusScope.of(context).requestFocus(FocusNode())
        : Navigator.pop(context);
  }
  _s.changeSheetState(neu);
}
void justschlies(context) {
 
 final _s = Provider.of<StateProvider>(context, listen: false);
  final int jup = _s.openSheet;

  switch (jup) {
    case 0:
      break;
    case 1:
      Navigator.pop(context);

      break;
    case 2:
      FocusScope.of(context).requestFocus(FocusNode());
      break;
  }

 _s.changeSheetState(0);
}