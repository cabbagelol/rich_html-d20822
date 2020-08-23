import 'dart:ui' as ui show PlaceholderAlignment;
import 'package:extended_text_library/extended_text_library.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../pages/rich-html.dart' show RichHtmlUtil;

class bText extends SpecialText {
  bText(
    TextStyle textStyle,
    SpecialTextGestureTapCallback onTap, {
    this.start,
    this.context,
    this.controller,
  }) : super(
          flag,
          '</b>',
          textStyle,
          onTap: onTap,
        );

  static const String flag = '<b';
  final BuildContext context;
  final TextEditingController controller;
  final int start;


  @override
  InlineSpan finishText() {
    final String text = flag + getContent() + '>';

    return SpecialTextSpan(
      text: RichHtmlUtil().remStringHtml(text),
      actualText: text,
      start: start,
      style: textStyle?.copyWith(fontWeight: FontWeight.bold),
      deleteAll: false,
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          if (onTap != null) {
            onTap(text);
          }
        },
    );
  }
}
