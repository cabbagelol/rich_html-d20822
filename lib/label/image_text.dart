import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart' hide Element;
import 'package:html/dom.dart' hide Text;
import 'package:html/parser.dart';

import 'package:flutter_bubble/bubble_widget.dart';

import '../pages/rich-html.dart' show RichHtmlData, RichHtmlDataImage, RichHtmlLabelType;

class ImageText extends SpecialText {
  final BuildContext context;
  static const String flag = '<img';
  final imageView;
  final int start;

  ImageText(
    TextStyle textStyle, {
    this.start,
    SpecialTextGestureTapCallback onTap,
    this.context,
    this.imageView,
  }) : super(
          ImageText.flag,
          '/>',
          textStyle,
          onTap: onTap,
        );

  bool show = false;

  _showAlertDialog(BuildContext context) {
    var title = Row(//标题
      children: <Widget>[
        Image.asset("images/icon_wwx.png", width: 30,height: 30,),
        SizedBox(width: 10,),
        new Text("表白")],
    );
    var content = Row(//内容
      children: <Widget>[
        Text("我💖你，你是我的"),
        Image.asset("images/icon_ylm.png",width: 30, height: 30, )],
    );

    showDialog(
        context: context,
        builder: (context) => //构造器
        AlertDialog(title: title, content: content, actions: <Widget>[
          FlatButton(
            child: Text("不要闹"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text("走开"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ]));
  }

  @override
  InlineSpan finishText() {
    final String text = flag + getContent() + '>';
    var t = parse(text);
    final Element img = t.getElementsByTagName('img').first;
    final String url = img.attributes['src'];

    return ExtendedWidgetSpan(
      start: start,
      actualText: text,
      child: GestureDetector(
        onTap: () {
          print(url);
          this._showAlertDialog(context);
          onTap?.call(url);
          show = show != true;
        },
        child: Stack(
          overflow: Overflow.visible,
          children: [
            imageView(url, img),
            Visibility(
              visible: false,
              child: Positioned(
                top: -30,
                left: 10,
                right: 10,
                child: Align(
                  child: BubbleWidget(
                    200.0,
                    40.0,
                    Color(0xff535353),
                    BubbleArrowDirection.bottom,
                    style: PaintingStyle.fill,
                    innerPadding: 5.0,
                    strokeWidth: .0,
                    radius: 5.0,
                    arrHeight: 5,
                    arrAngle: 90,
                    child: Text(
                      '你好，我是萌新 BubbleWidget！',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
