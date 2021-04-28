import 'package:flutter/material.dart';

import '../storage/colors.dart';

Color priorityColor(int prio) {
  switch (prio) {
    case 3:
      return veryImportantColor;
    case 2:
      return importantColor;
    case 1:
      return leastImportantColor;
    default:
      return Colors.transparent;
  }
}
