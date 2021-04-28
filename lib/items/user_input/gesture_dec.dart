import 'package:flutter/material.dart';

import '../../storage/colors.dart';
import '../../storage/textstyles.dart';

class SelectTransactionGesture extends StatelessWidget {
  final String typedText;
  final bool hell;
  final Function onPress;
  final lead;

  SelectTransactionGesture(
      {@required this.typedText,
      this.onPress,
      @required this.lead,
      @required this.hell});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;

    final double wi = mediaQuery.width;

    return Container(
      child: Row(
        children: <Widget>[
          SizedBox(width: 20),
          lead,
          SizedBox(width: 12),
          SizedBox(
            width: wi * 0.75,
            child: GestureDetector(
              onTap: onPress != null ? onPress : () {},
              child: Column(
                children: <Widget>[
                  SizedBox(height: 14),
                  SizedBox(
                    width: wi * 0.75,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                            width: wi * 0.75 - 10,
                            child: Text(typedText,
                                maxLines: 1,
                                style: hell ? unfocusText : focusText)),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 1,
                    width: wi * 0.75,
                    child: Divider(
                      color: primaryColor,
                      thickness: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
