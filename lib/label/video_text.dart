import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart' hide Element;
import 'package:html/dom.dart' hide Text;
import 'package:html/parser.dart';

class VideoText extends SpecialText {
  static const String flag = '<video';
  final videoView;
  final int start;

  VideoText(
    TextStyle textStyle, {
    this.start,
    SpecialTextGestureTapCallback onTap,
    this.videoView,
  }) : super(
          VideoText.flag,
          '/>',
          textStyle,
          onTap: onTap,
        );

  @override
  InlineSpan finishText() {
    final String text = flag + getContent() + '>';
    final Document html = parse(text);
    final Element img = html.getElementsByTagName('video').first;
    final String url = img.attributes['src'];

    return ExtendedWidgetSpan(
      start: start,
      actualText: text,
      child: videoView(url, img),
    );
  }
}
