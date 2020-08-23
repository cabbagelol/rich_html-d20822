import 'dart:ui';

import 'rich-html-theme.dart';

class RichHtmlCursor {
  final double cursorWidth;
  final Color cursorColor;
  final Radius cursorRadius;

  RichHtmlCursor({
    this.cursorWidth = 2.0,
    Color cursorColor,
    Radius cursorRadius,
  })  : cursorColor = cursorColor ?? RichHtmlTheme().mainColor,
        cursorRadius = cursorRadius ?? Radius.circular(5);
}
