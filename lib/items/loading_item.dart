import 'package:flutter/material.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';

import '../storage/foundation.dart';

import '../storage/colors.dart';

Widget indicator(bool dark) => isIos
    ? NutsActivityIndicator(
        radius: 14,
        activeColor:
         dark ? icoColor : 
         Colors.white,
        inactiveColor: dark ? Colors.black26 : Colors.white38,
        tickCount: 11,
        startRatio: 0.55,
        animationDuration: Duration(milliseconds: 1000),
      )
    : SizedBox(
        width: 30,
        height: 30,
        child: FittedBox(
            fit: BoxFit.scaleDown,
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(
                dark ? icoColor :
                 Colors.white,
              ),
            )),
      );