import 'package:extended_text_library/extended_text_library.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class pText extends SpecialText {
  pText(
    TextStyle textStyle,
    SpecialTextGestureTapCallback onTap, {
    this.showAtBackground = false,
    this.start,
  }) : super(
          flag,
          '</p>' ?? '</div>',
          textStyle,
          onTap: onTap,
        );
  static const String flag = '<p' ?? '<div';
  final int start;

  /// whether show background for @somebody
  final bool showAtBackground;

  @override
  InlineSpan finishText() {
    final TextStyle textStyle = this.textStyle?.copyWith();
    String html;
    String text;
    html = flag + getContent() + '>';
    text = "\n\n${html.replaceAll(new RegExp('<p.*?>'), '').replaceAll('</p>', '')}\n\n";

    return SpecialTextSpan(
      text: text,
      actualText: html,
      start: start,
      style: textStyle,
      deleteAll: true,
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          if (onTap != null) {
            onTap(text);
          }
        },
    );
  }
}
